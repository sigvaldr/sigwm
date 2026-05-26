//! SIGWM :: "Built in" status-bar
//!
//! The `penrose_ui` crate contains some UI elements that make use of the penrose APIs
//! to provide native integration with the rest of the library. This example shows how
//! to set up a simple `dwm` style status bar and add it to your existing window
//! manager set up.
//!
//! For more customisation options, see the `bar` module of the `penrose_ui` crate in
//! the `/crates` directory.

use penrose::x11rb::RustConn;
use penrose::{
    Result,
    builtin::{
        actions::{exit, log_current_state, modify_with, send_layout_message, spawn},
        layout::{
            MainAndStack, Monocle,
            messages::{ExpandMain, IncMain, ShrinkMain},
            transformers::{Gaps, ReserveTop},
        },
    },
    core::{
        Config, WindowManager,
        bindings::{KeyEventHandler, parse_keybindings_with_xmodmap},
        layout::LayoutStack,
    },
    extensions::hooks::add_ewmh_hooks,
    map, stack,
};

use penrose_ui::{
    bar::{Position, StatusBar},
    core::TextStyle,
};

// Private items from bar::widgets that need direct import
use penrose_ui::bar::widgets::{ActiveWindowName, CurrentLayout, Text, Workspaces};
use std::collections::HashMap;
use tracing_subscriber::{self, prelude::*};

const FONT: &str = "BigBlueTermPlus Nerd Font Mono";
const BLACK: u32 = 0x282828ff;
const WHITE: u32 = 0xebdbb2ff;
const GREY: u32 = 0x3c3836ff;
const BLUE: u32 = 0x458588ff;
//const SIGBLUE: u32 = 0x022525ff;
const SIGBLUE: u32 = 0x00a6d7ff;
const MAX_MAIN: u32 = 1;
const RATIO: f32 = 0.6;
const RATIO_STEP: f32 = 0.1;
const OUTER_PX: u32 = 5;
const INNER_PX: u32 = 5;
const BAR_HEIGHT_PX: u32 = 18;

fn raw_key_bindings() -> HashMap<String, Box<dyn KeyEventHandler<RustConn>>> {
    let mut raw_bindings = map! {
        map_keys: |k: &str| k.to_owned();

        "M-j" => modify_with(|cs| cs.focus_down()),
        "M-k" => modify_with(|cs| cs.focus_up()),
        "M-S-j" => modify_with(|cs| cs.swap_down()),
        "M-S-k" => modify_with(|cs| cs.swap_up()),
        "M-S-q" => modify_with(|cs| cs.kill_focused()),
        "M-Tab" => modify_with(|cs| cs.toggle_tag()),
        "M-bracketright" => modify_with(|cs| cs.next_screen()),
        "M-bracketleft" => modify_with(|cs| cs.previous_screen()),
        "M-grave" => modify_with(|cs| cs.next_layout()),
        "M-S-grave" => modify_with(|cs| cs.previous_layout()),
        "M-Up" => send_layout_message(|| IncMain(1)),
        "M-Down" => send_layout_message(|| IncMain(-1)),
        "M-Right" => send_layout_message(|| ExpandMain),
        "M-Left" => send_layout_message(|| ShrinkMain),
        "M-semicolon" => spawn("dmenu_run"),
        "M-S-s" => log_current_state(),
        "M-Return" => spawn("alacritty"),
        "M-C" => modify_with(|cs| cs.kill_focused()),
        "M-Escape" => exit(),
    };

    for tag in &["1", "2", "3", "4", "5", "6", "7", "8", "9"] {
        raw_bindings.extend([
            (
                format!("M-{tag}"),
                modify_with(move |client_set| client_set.focus_tag(tag)),
            ),
            (
                format!("M-S-{tag}"),
                modify_with(move |client_set| client_set.move_focused_to_tag(tag)),
            ),
        ]);
    }

    raw_bindings
}

fn layouts() -> LayoutStack {
    stack!(
        MainAndStack::side(MAX_MAIN, RATIO, RATIO_STEP),
        MainAndStack::side_mirrored(MAX_MAIN, RATIO, RATIO_STEP),
        MainAndStack::bottom(MAX_MAIN, RATIO, RATIO_STEP),
        Monocle::boxed()
    )
    .map(|layout| ReserveTop::wrap(Gaps::wrap(layout, OUTER_PX, INNER_PX), BAR_HEIGHT_PX))
}

fn main() -> Result<()> {
    tracing_subscriber::fmt()
        .with_env_filter("debug")
        .finish()
        .init();

    let config = add_ewmh_hooks(Config {
        default_layouts: layouts(),
        focused_border: SIGBLUE.into(),
        ..Config::default()
    });

    let conn = RustConn::new()?;
    let key_bindings = parse_keybindings_with_xmodmap(raw_key_bindings())?;
    let style = TextStyle {
        fg: WHITE.into(),
        bg: Some(BLACK.into()),
        padding: (2, 2),
    };

    // Build widgets for the status bar
    let widgets: Vec<Box<dyn penrose_ui::bar::widgets::Widget<RustConn> + 'static>> = vec![
        Box::new(Workspaces::new(style.clone(), BLUE, GREY)),
        Box::new(CurrentLayout::new(style.clone())),
        Box::new(ActiveWindowName::new(80, style.clone(), true, false)),
        // Custom Text widget showing "SIGWM" instead of "penrose"
        Box::new(Text::new("SIGWM", style, false, true)),
    ];

    let bar = match StatusBar::try_new(
        Position::Top,
        BAR_HEIGHT_PX,
        style.bg.unwrap_or_else(|| 0x000000.into()),
        FONT,
        8u8, // point_size
        widgets,
    ) {
        Ok(bar) => bar,
        Err(_) => {
            return Err(penrose::Error::from(std::io::Error::new(
                std::io::ErrorKind::Other,
                "Failed to create status bar",
            )));
        }
    };

    let wm_manager = match WindowManager::new(config, key_bindings, HashMap::new(), conn) {
        Ok(wm) => wm,
        Err(_) => {
            return Err(penrose::Error::from(std::io::Error::new(
                std::io::ErrorKind::Other,
                "Failed to create window manager",
            )));
        }
    };

    let wm = bar.add_to(wm_manager);

    wm.run()
}

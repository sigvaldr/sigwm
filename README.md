# SIGWM – Lightweight Rust Window Manager

[![Built on Penrose](https://img.shields.io/badge/%E2%99%A5-Built%20on%20Penrose-8b5cf6?style=for-the-badge)](https://github.com/sonohzr/penrose)
[![Version](https://img.shields.io/badge/version-0.1.1-blue.svg)](./Cargo.toml)

---

## 🖥️ Overview

**SIGWM** (Sigvaldr's Individual GNU Window Manager) is a custom X11 window manager written in Rust, built on top of the [Penrose](https://github.com/sonohzr/penrose) framework. It provides a dwm-inspired tiling layout experience with native status bar integration and EWMH support.

A personal, opinionated take on X11 window management – minimal dependencies, maximum control.

---

## ✨ Key Features

- **Tiling Layout Engine**: Multiple layout options including side layouts, monocle, and bottom split
- **Built-in Status Bar**: Displays workspaces, current layout, active window title, and version info
- **EWMH Hooks**: Proper compositing manager protocol support for desktop environment integration
- **Keyboard-Driven**: Pure keyboard navigation with `Mod +` keybindings
- **Multi-Screen Support**: Seamless screen switching

---

## 🛠️ Technologies

| Technology       | Purpose                      |
| ---------------- | ---------------------------- |
| **Rust**         | Core language (edition 2024) |
| **Penrose**      | X11 window manager framework |
| **penrose_ui**   | Status bar and UI components |
| **tracing**      | Structured logging           |
| **X11/RustConn** | Direct X11 protocol access   |

---

## 📦 Prerequisites

Before building or running SIGWM, ensure you have:

- Rust (Cargo) installed
- X11 development libraries (`xorg-dev`)
- XModMap accessible for keybinding parsing

### Arch Linux / Manjaro Dependencies

```bash
sudo pacman -S xorg-xinit xorg-server xdg-utils ttf-bigblueterminal-nerd alacritty
```

Full installation script included in `installRequirements.sh`.

---

## 🚀 Installation

### Quick Start

```bash
# Clone the repository
git clone https://github.com/sigvaldr/sigwm.git
cd sigwm

# Build in release mode
cargo build --release

# Install to system path
sudo cp target/release/sigwm /usr/bin/sigwm
```

### Full Setup (including config & deps)

Use the provided installation script (Only works on Arch):

```bash
./installRequirements.sh
```

> **Note**: This script will switch your shell to `fish`, install themes, and configure your `.config` directory. Review before running!

---

## 🏗️ Building

### Release Build

```bash
cargo build --release
```

### Debug Build (with logs)

```bash
cargo build
```

### Rebuild & Install Script

```bash
./rebuild.sh
```

---

## 🖱️ Usage

Start the window manager:

```bash
sigwm
```

Or from your display manager/autostart configuration.

Launch with Xinit:

```bash
exec startx
```

(Configure `~/.xinitrc` to run `sigwm`).

---

## ⌨️ Keyboard Shortcuts

All shortcuts use the `Mod` key (default: **Super**). Press `Mod + S` to toggle state logging.

| Shortcut               | Action                           |
| ---------------------- | -------------------------------- |
| `Mod + j` / `Mod + k`  | Focus down/up window             |
| `Mod + Shift + j`      | Swap focused window with below   |
| `Mod + Shift + k`      | Swap focused window with above   |
| `Mod + Shift + q`      | Kill focused window              |
| `Mod + Tab`            | Toggle tags                      |
| `Mod + \`              | Cycle layouts (forward)          |
| `Mod + Shift + \`      | Cycle layouts (backward)         |
| `Mod + Up` / `Down`    | Increase/decrease main area size |
| `Mod + Right` / `Left` | Expand/shrink main split         |
| `Mod + 1`–`9`          | Focus workspace 1–9              |
| `Mod + Shift + 1`–`9`  | Move focused window to workspace |
| `Mod + m` / `k`        | Swap workspace up/down           |
| `Mod + Return`         | Launch terminal (`alacritty`)    |
| `Mod + Space`          | Open application launcher (Rofi) |
| `Mod + f`              | Launch file manager (`thunar`)   |
| `Mod + w`              | Launch browser (`librewolf`)     |
| `Mod + c`              | Kill focused window              |
| `Mod + Escape`         | Exit window manager              |

> Workspace numbers and tags can be customized by modifying the key bindings in `src/main.rs`.

---

## 🎨 Configuration

Edit these constants in `src/main.rs`:

### Application Defaults

```rust
const TERMINAL: &str = "alacritty";
const LAUNCHER: &str = "rofi -show drun";
const BROWSER: &str = "librewolf";
const EXPLORER: &str = "thunar";
```

### Style & Appearance

| Variable        | Default                            | Description                       |
| --------------- | ---------------------------------- | --------------------------------- |
| `FONT`          | `"BigBlueTermPlus Nerd Font Mono"` | Main UI font                      |
| `BLACK`         | `0x282828ff`                       | Background color (hex with alpha) |
| `WHITE`         | `0xebdbb2ff`                       | Foreground color                  |
| `SIGBLUE`       | `0x00a6d7ff`                       | Accent/focused border color       |
| `BAR_HEIGHT_PX` | `18`                               | Status bar height                 |

### Layout Behavior

```rust
const MAX_MAIN: u32 = 1;    // Max split ratio for main area
const RATIO: f32 = 0.6;     // Initial main area ratio
const RATIO_STEP: f32 = 0.1; // Step size for layout resizing
const OUTER_PX: u32 = 5;    // Outer window spacing
const INNER_PX: u32 = 5;    // Inner window spacing
```

---

## 🧩 Layout Stack

Available layouts (configured in `layouts()`):

1. **Side Layout** – Main area on the right
2. **Mirrored Side** – Main area on the left
3. **Bottom Layout** – Main area at the bottom
4. **Monocle Boxed** – Single tiled window

All layouts reserve space for the status bar at the top and add outer/inner gaps.

---

## 🔧 Utilities

### `installRequirements.sh`

Installs system dependencies, themes, custom binaries (`rdir`, `boxr`), and copies your `.xinitrc`.

### `rebuild.sh`

Rebuilds SIGWM in release mode and installs the binary to `/usr/bin/sigwm`.

### `utils/`

Additional helper scripts for environment setup.

---

## 📁 Project Structure

```
sigwm/
├── Cargo.toml              # Rust dependencies & metadata
├── README.md               # This file
├── .gitignore              # Git ignore rules
├── .xinitrc                # X11 display manager startup config
├── installRequirements.sh  # Dependency & config installation
├── rebuild.sh              # Build & install script
├── src/
│   └── main.rs             # Main application logic
└── utils/
    ├── rustup.sh           # Rust toolchain setup helper
    └── yay.sh              # AUR helper wrapper (optional)
```

---

## 🔍 Logging & Debugging

SIGWM uses `tracing-subscriber` with default `debug` level:

```bash
RUST_LOG=trace cargo run
```

Logs appear in your terminal if running without a compositor.

---

## 📜 Roadmap / Future Enhancements

- [ ] Configurable via TOML/JSON (instead of hard-coded in `main.rs`)
- [ ] Theme system support for bar and window borders
- [ ] Drag-and-drop between workspaces
- [ ] More layout algorithms (stack, grid, spiral)
- [ ] Wayland port (ambitious!)

---

## 📄 License

Unspecified. See the repository root for details.

---

## 🙋 Support & Credits

**Author**: Sigvaldr Nótthrafn (`me@sigvaldr.lol`)

**Inspired by**: [dwm](https://dwm.sucks.com), [Penrose](https://github.com/sonohzr/penrose)

**Contributions Welcome**: Open an issue or PR for layout tweaks, bug reports, or feature ideas.

---

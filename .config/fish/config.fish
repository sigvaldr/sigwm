#if status is-interactive
## Commands to run in interactive sessions can go here
#end
#set -U fish_greeting

function fish_greeting
    clear
    fastfetch
    echo ""
end

starship init fish | source
startx

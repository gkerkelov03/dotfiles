set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx SUDO_EDITOR nvim
set -gx BROWSER qutebrowser
set -gx PAGER bat
set -gx SSH_AUTH_SOCK /home/gkerkelov03/.ssh/agent.sock

set -gx DOTNET_ROOT /usr/share/dotnet
set -p PATH $HOME/.dotnet/tools
set -p PATH $HOME/.local/bin

set -gx BAT_THEME ansi

#Set the default fish_greeting to nothing otherwise it prints Welcome to fish
set -g fish_greeting

if status is-interactive
    #Load Caelestia color scheme into the shell's 16 colors
    cat ~/.local/state/caelestia/sequences.txt 2>/dev/null

    sleep 0.01 #because the terminal width in the call-fastfetch function is calculated too fast otherwise and its wrong
    call-fastfetch

    atuin init fish --disable-up-arrow --disable-ctrl-r | source
    tv init fish | source

    set -U fish_key_bindings fish_vi_key_bindings
    set -U nvm_default_version lts

    set -U tide_character_icon \U000f016c
    set -U tide_character_vi_icon_default \U000f016c
    set -U tide_character_vi_icon_visual \U000f016c
    set -U tide_character_vi_icon_insert \U000f016c
    set -U tide_character_vi_icon_replace \U000f016d

    abbr b --function projectdo_build
    abbr r --function projectdo_run
    abbr t --function projectdo_test

    abbr lg lazygit
    abbr ld lazydocker
    abbr f fzf
    abbr v nvim
    abbr y yazi
    abbr c cd

    abbr gd 'git diff'
    abbr ga 'git add'
    abbr gaa 'git add -A'
    abbr gc --set-cursor 'git commit -m "%"'
    abbr gl 'git log'
    abbr gs git-status
    abbr gst 'git stash'
    abbr gsp 'git stash pop'
    abbr gp 'git push'
    abbr gpl 'git pull'
    abbr gsw 'git switch'
    abbr gsm 'git switch main'
    abbr gb 'git branch'
    abbr gbd 'git branch -d'
    abbr gco 'git checkout'
    abbr gsh 'git show'

    alias l="eza -1 --icons --git --group-directories-first --color-scale --mounts"
    alias ls="eza -a1 --icons --git --group-directories-first --color-scale --mounts"
    alias lsl="eza -la --icons --octal-permissions --group --git --header --group-directories-first --color-scale --created --mounts --modified"
    alias lsls="eza -la --icons --total-size --octal-permissions --group --git --header --group-directories-first --color-scale --created --mounts --modified"

    alias vim="nvim"
    alias cat="bat"
    alias grep="rg"
    alias du="dust"
    alias df="duf"
    alias neo="neo-matrix --defaultbg --colormode=16"

    #Keybindigs for vim mode
    bind -M default yy fish_clipboard_copy
    bind -M default Y fish_clipboard_copy
    bind -M default p fish_clipboard_paste
    bind -M visual y 'fish_clipboard_copy; set fish_bind_mode default; commandline -f end-selection repaint-mode'
    bind -M visual p 'commandline -f kill-selection; fish_clipboard_paste'

    function clone --description 'git clone into ~/repos'
        if test (count $argv) -eq 0
            echo 'Usage: clone <url or user/repo> [git clone options]' >&2
            return 1
        end

        set -l repo $argv[1]
        if string match -rq '^[^/:@]+/[^/:@]+$' -- $repo
            set repo https://github.com/$repo
        end

        mkdir -p ~/repos
        and git -C ~/repos clone $repo $argv[2..]
    end

    function man
        tldr $argv 2>/dev/null; or command man $argv
    end

    function mkcd --description 'create a directory and cd into it'
        mkdir -p $argv[1] && cd $argv[1]
    end

    function auto_ls --on-variable PWD
        l
    end
end

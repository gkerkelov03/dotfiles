set -gx DOTNET_ROOT /usr/share/dotnet
fish_add_path --path --move $HOME/.local/bin $HOME/.dotnet/tools

set -gx BAT_THEME ansi

# Set the default fish_greeting to nothing, otherwise it prints "Welcome to fish"
set -g fish_greeting

if status is-interactive
    # Load Caelestia color scheme into the shell's 16 colors
    cat ~/.local/state/caelestia/sequences.txt 2>/dev/null

    sleep 0.01 # the terminal width in call-fastfetch is calculated too early otherwise and is wrong
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

    # projectdo
    abbr b --function projectdo_build
    abbr r --function projectdo_run
    abbr t --function projectdo_test

    # Tools
    abbr lg lazygit
    abbr ld lazydocker
    abbr f fzf
    abbr v nvim
    abbr y yazi
    abbr c cd

    # Git
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

    abbr cs 'chezmoi status'
    abbr ca 'chezmoi apply'

    alias l="eza -1 --icons --git --group-directories-first --color-scale --mounts"
    alias ls="eza -a1 --icons --git --group-directories-first --color-scale --mounts"
    alias lsl="eza -la --icons --octal-permissions --group --git --header --group-directories-first --color-scale --created --mounts --modified"
    alias lsls="eza -la --icons --total-size --octal-permissions --group --git --header --group-directories-first --color-scale --created --mounts --modified"

    alias cat="bat"
    alias neo="neo-matrix --defaultbg --colormode=16"
    alias pkg="~/dotfiles/scripts/pkg.cs"
    alias google-drive-sync-now="systemctl --user start google-drive-sync"
    alias apply-system-configs="chezmoi apply --include=scripts"

    # fish calls this after loading the key binding preset, so these
    # survive any reload or switch of fish_key_bindings
    function fish_user_key_bindings
        # Vim mode clipboard
        bind -M default yy fish_clipboard_copy
        bind -M default Y fish_clipboard_copy
        bind -M default p fish_clipboard_paste
        bind -M visual -m default y 'fish_clipboard_copy; commandline -f end-selection repaint-mode'
        bind -M visual p 'commandline -f kill-selection; fish_clipboard_paste'

        # Empty enter
        bind -M default enter go-back-on-empty-enter-press
        bind -M insert enter go-back-on-empty-enter-press
    end

    function man --description 'tldr page, falling back to man'
        tldr $argv 2>/dev/null; or command man $argv
    end

    function mkcd --description 'create a directory and cd into it'
        mkdir -p $argv[1]; and cd $argv[1]
    end

    function copy --description 'copy file contents to clipboard'
        wl-copy <$argv[1]
        echo done
    end

    function auto_ls --on-variable PWD --description 'list directory contents after cd'
        l
    end
end

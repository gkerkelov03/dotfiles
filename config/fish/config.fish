if status is-interactive
    #Load Caelestia color scheme into the shell's 16 colors
    cat ~/.local/state/caelestia/sequences.txt 2>/dev/null

    atuin init fish --disable-up-arrow | source

    set -gx XDG_CONFIG_HOME $HOME/.config
    set -gx XDG_CACHE_HOME $HOME/.cache
    set -gx XDG_DATA_HOME $HOME/.local/share
    set -gx XDG_STATE_HOME $HOME/.local/state

    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -gx SUDO_EDITOR nvim
    set -gx BROWSER qutebrowser

    set -gx DOTNET_ROOT /usr/share/dotnet
    set -p PATH $HOME/.dotnet/tools

    set -U fish_key_bindings fish_vi_key_bindings
    set -U nvm_default_version lts

    set -U tide_character_icon \U000f016c
    set -U tide_character_vi_icon_default \U000f016c
    set -U tide_character_vi_icon_visual \U000f016c
    set -U tide_character_vi_icon_insert \U000f016c
    set -U tide_character_vi_icon_replace \U000f016d

    set -gx BAT_THEME ansi

    set -gx FZF_DEFAULT_OPTS "
      --color=16
      --color=fg:-1,bg:-1,hl:14,fg+:15,bg+:4,hl+:14
      --color=info:8,prompt:2,pointer:15,marker:13,spinner:11,header:6
      --layout=reverse
      --border=rounded
      --marker='✓'
      --height=100%
      --preview '~/dotfiles/scripts/fzf-preview.sh {}'
      --preview-window=right:60%
      --prompt='❯ '
    "
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

    abbr b --function projectdo_build
    abbr r --function projectdo_run
    abbr t --function projectdo_test

    abbr lg lazygit
    abbr f fzf
    abbr v nvim
    abbr gd 'git diff'
    abbr ga 'git add'
    abbr gaa 'git add -A'
    abbr gc --set-cursor 'git commit -m "%"'
    abbr gl 'git log'
    abbr gs git_status
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
    alias neo "neo-matrix --defaultbg --colormode=16"

    alias symlink-dotfiles="sh ~/dotfiles/scripts/symlink-dotfiles.sh"

    #Keybindigs for vim mode
    bind -M default yy fish_clipboard_copy
    bind -M default Y fish_clipboard_copy
    bind -M default p fish_clipboard_paste
    bind -M visual y 'fish_clipboard_copy; set fish_bind_mode default; commandline -f end-selection repaint-mode'
    bind -M visual p 'commandline -f kill-selection; fish_clipboard_paste'

    function man
        tldr $argv 2>/dev/null; or command man $argv
    end

    function mkcd
        mkdir -p $argv[1] && cd $argv[1]
    end

    function auto_ls --on-variable PWD
        l
    end
end

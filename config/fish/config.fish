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

    set -g fish_key_bindings fish_vi_key_bindings

    set -gx nvm_default_version lts

    set -gx BAT_THEME ansi

    set -gx FZF_DEFAULT_OPTS "
      --color=16
      --color=fg:-1,bg:-1,hl:14,fg+:15,bg+:4,hl+:14
      --color=info:8,prompt:2,pointer:15,marker:13,spinner:11,header:6
      --layout=reverse
      --border=rounded
      --margin=1
      --padding=1
      --height=40%
      --prompt='❯ '
    "
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

    abbr b --function projectdo_build
    abbr r --function projectdo_run
    abbr t --function projectdo_test

    alias l="eza -1 --icons --git --group-directories-first --color-scale --mounts"
    alias ls="eza -a1 --icons --git --group-directories-first --color-scale --mounts"
    alias lsl="eza -la --icons --octal-permissions --group --git --header --group-directories-first --color-scale --created --mounts --modified"
    alias lsls="eza -la --icons --total-size --octal-permissions --group --git --header --group-directories-first --color-scale --created --mounts --modified"

    alias vim="nvim"
    alias cat="bat"
    alias grep="rg"
    alias du="dust"
    alias df="duf"
    alias neo "neo --defaultbg --colormode=16"
    alias pipes "pipes.sh"

    bind yy fish_clipboard_copy
    bind Y fish_clipboard_copy
    bind p fish_clipboard_paste

    alias symlink-dotfiles="sh ~/dotfiles/scripts/symlink-dotfiles"

    function man
        tldr $argv 2>/dev/null; or command man $argv
    end

    function mkcd
        mkdir -p $argv[1] && cd $argv[1]
    end

    function mark_prompt_start --on-event fish_prompt
        echo -en "\e]133;A\e\\"
    end
end

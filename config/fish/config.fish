if status is-interactive
    #Load Caelestia color scheme into the shell's 16 colors
    cat ~/.local/state/caelestia/sequences.txt 2>/dev/null

    atuin init fish --disable-up-arrow | source

    set -g fish_key_bindings fish_vi_key_bindings
    set -gx FZF_DEFAULT_OPTS "
        --color=16
        --color=fg:-1,bg:-1,hl:5,fg+:15,bg+:8,hl+:5
        --color=info:4,prompt:2,pointer:12,marker:13,spinner:12,header:6
        --layout=reverse
        --border=rounded
        --margin=1
        --padding=1
        --height=40%
    "
    abbr -a b --function projectdo_build
    abbr -a r --function projectdo_run
    abbr -a t --function projectdo_test

    # For jumping between prompts in foot terminal
    function mark_prompt_start --on-event fish_prompt
        echo -en "\e]133;A\e\\"
    end
end

function call-fastfetch --description "Run fastfetch with a gap sized to the terminal"
    set -l logo_file ~/.config/fastfetch/pixel-art/konoha.txt

    set -l columns (string split ' ' (stty size </dev/tty))[2]
    set -l logo_width 26
    set -l info_width 37

    set -l right_margin 2
    set -l left_margin 2

    set -l gap (math "$columns - $logo_width - $info_width - $left_margin - $right_margin")

    if test $gap -ge 1
        fastfetch --logo-padding-left $left_margin --logo-padding-right $gap $argv
    else
        fastfetch --logo none $argv
    end
end

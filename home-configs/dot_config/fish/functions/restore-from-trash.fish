#-r or --root to see root's trash
function restore-from-trash --description 'restore trashed files, picked with television\'s trash channels'
    argparse r/root -- $argv; or return

    set -l su # empty normally, "sudo" in root mode
    set -l channel trash

    if set -q _flag_root
        sudo -v; or return 1 # ask for the password once, up front
        set su sudo
        set channel trash-root
    end

    set -l picks (tv $channel)
    test (count $picks) -gt 0; or return 1

    for pick in $picks
        set -l f (string split -m2 ' ' -- $pick)
        set -l when "$f[1] $f[2]"
        set -l orig $f[3]

        set -l idx
        for row in ($su trash-restore -- $orig </dev/null 2>/dev/null)
            set -l r (string split -m3 ' ' -- (string trim -- $row))
            if test (count $r) -eq 4; and test "$r[2] $r[3]" = "$when"; and test "$r[4]" = "$orig"
                set idx $r[1]
                break
            end
        end

        if test -n "$idx"
            echo $idx | $su trash-restore -- $orig >/dev/null 2>&1
            if $su test -e "$orig"
                echo "restored  $orig"
            else
                echo "restore-from-trash: failed to restore $orig" >&2
            end
        else
            echo "restore-from-trash: couldn't find '$orig' ($when) in trash" >&2
        end
    end
end

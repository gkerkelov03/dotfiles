function restore-from-trash --description 'restore trashed files, picked with television\'s trash channel'
    # Tab in tv to pick several, Enter to confirm
    set -l picks (tv trash)
    test (count $picks) -gt 0; or return 1

    for pick in $picks
        set -l f (string split -m2 ' ' -- $pick)
        set -l when "$f[1] $f[2]"
        set -l orig $f[3]
        set -l idx

        for row in (trash-restore -- $orig </dev/null 2>/dev/null)
            set -l r (string split -m3 ' ' -- (string trim -- $row))
            if test (count $r) -eq 4; and test "$r[2] $r[3]" = "$when"; and test "$r[4]" = "$orig"
                set idx $r[1]
                break
            end
        end

        if test -n "$idx"
            echo $idx | trash-restore -- $orig >/dev/null 2>&1
            if test -e "$orig"
                echo "restored  $orig"
            else
                echo "failed to restore $orig" >&2
            end
        else
            echo "couldn't find '$orig' ($when) in trash" >&2
        end
    end
end

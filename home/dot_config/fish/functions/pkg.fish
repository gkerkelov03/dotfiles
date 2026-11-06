function pkg --description 'Simple package manager wrapper that tracks a package list'
    # ============================================================
    #  Settings - edit these when you distro hop
    # ============================================================
    set -l add_cmd paru -S --needed --noconfirm
    set -l remove_cmd paru -Rns --noconfirm
    set -l update_cmd paru -Syu
    set -l clean_cmd paru -c # run after update (clean unneeded deps)
    set -l check_cmd paru -Qi

    set -l pkg_file ~/dotfiles/arch/packages.txt # your package list
    set -l unsorted_header '#Unsorted packages' # matched case-insensitively
    set -l comment_column 30 # column where the # comment starts
    # ============================================================

    set -l usage "Usage:
  pkg add|a <packages-list>
  pkg remove|r <packages-list>
  pkg update-all|u
  pkg check|c <packages-list>"

    if not command -q $add_cmd[1]
        echo "error: $add_cmd[1] is not installed or not in PATH" >&2
        return 1
    end

    if test (count $argv) -eq 0
        echo $usage
        return 1
    end

    set -l cmd $argv[1]
    set -l args $argv[2..-1]

    switch $cmd
        case add a
            set -l pkgs $args
            if test (count $pkgs) -eq 0
                echo "error: 'add' needs at least one package name" >&2
                return 1
            end

            # 1. install - stop here if it fails, so the list stays accurate
            $add_cmd $pkgs
            or return

            # 2. add each package that isn't already in the list
            if not test -e $pkg_file
                mkdir -p (path dirname $pkg_file)
                touch $pkg_file
            end

            for p in $pkgs
                # skip packages already listed in any section
                if env PKG=$p awk '$0 !~ /^[[:space:]]*#/ && $1 == ENVIRON["PKG"] { found = 1 } END { exit !found }' $pkg_file
                    continue
                end

                # description is mandatory - keep asking until one is given
                set -l desc
                while true
                    if not read -P "Description for $p: " desc
                        # read was cancelled (Ctrl+C / Ctrl+D)
                        echo "error: no description given, $p was installed but NOT added to $pkg_file" >&2
                        return 1
                    end
                    set desc (string trim -- "$desc")
                    test -n "$desc"; and break
                    echo "a description is required" >&2
                end

                set -l line (printf "%-*s #%s" (math $comment_column - 2) $p $desc)

                # insert at the end of the Unsorted section (created if missing)
                set -l tmp (mktemp)
                env HDR=$unsorted_header LINE=$line awk '
                    function trim(s) { sub(/[[:space:]]+$/, "", s); return s }
                    function blank(s) { return s ~ /^[[:space:]]*$/ }
                    { lines[NR] = $0 }
                    END {
                        hdr = ENVIRON["HDR"]; line = ENVIRON["LINE"]
                        n = NR
                        while (n > 0 && blank(lines[n])) n--          # drop trailing blank lines

                        h = 0
                        for (i = 1; i <= n; i++) if (tolower(trim(lines[i])) == tolower(hdr)) { h = i; break }

                        if (!h) {                                      # no Unsorted section yet
                            for (i = 1; i <= n; i++) print lines[i]
                            if (n > 0) print ""
                            print hdr
                            print line
                            exit
                        }

                        e = h                                          # last line of the section
                        for (i = h + 1; i <= n && !blank(lines[i]); i++) e = i
                        for (i = 1; i <= n; i++) {
                            print lines[i]
                            if (i == e) print line
                        }
                    }' $pkg_file >$tmp
                and cat $tmp >$pkg_file
                rm -f $tmp
                echo "added $p to $pkg_file"
            end

        case remove r
            if test (count $args) -eq 0
                echo "error: 'remove' needs at least one package name" >&2
                return 1
            end

            # 1. uninstall - stop here if it fails
            $remove_cmd $args
            or return

            test -e $pkg_file; or return 0

            # 2. find which of the removed packages are in the list (it's fine if none are)
            set -l listed
            for p in $args
                if env PKG=$p awk '$0 !~ /^[[:space:]]*#/ && $1 == ENVIRON["PKG"] { found = 1 } END { exit !found }' $pkg_file
                    set -a listed $p
                end
            end
            test (count $listed) -gt 0; or return 0

            # 3. delete the package lines and tidy the blank lines
            set -l tmp (mktemp)
            env PKGS="$listed" HDR=$unsorted_header awk '
                function trim(s) { sub(/[[:space:]]+$/, "", s); return s }
                function blank(s) { return s ~ /^[[:space:]]*$/ }
                BEGIN { n = split(ENVIRON["PKGS"], a, " "); for (i = 1; i <= n; i++) rm[a[i]] = 1 }
                $0 !~ /^[[:space:]]*#/ && ($1 in rm) { next }    # the package line itself
                { keep[++k] = $0 }
                END {
                    hdr = ENVIRON["HDR"]
                    # drop the Unsorted header if its section is now empty
                    for (i = 1; i <= k; i++)
                        if (tolower(trim(keep[i])) == tolower(hdr) && (i == k || blank(keep[i + 1]))) skip[i] = 1

                    # never two blank lines in a row, none at the start or end
                    m = 0
                    for (i = 1; i <= k; i++) {
                        if (skip[i]) continue
                        if (blank(keep[i]) && (m == 0 || blank(out[m]))) continue
                        out[++m] = keep[i]
                    }
                    while (m > 0 && blank(out[m])) m--
                    for (i = 1; i <= m; i++) print out[i]
                }' $pkg_file >$tmp
            and cat $tmp >$pkg_file
            rm -f $tmp
            echo "removed $listed from $pkg_file"

        case update-all u
            if test (count $args) -gt 0
                echo "error: 'update-all' takes no arguments" >&2
                return 1
            end
            $update_cmd; and $clean_cmd

        case check c
            if test (count $args) -eq 0
                echo "error: 'check' needs at least one package name" >&2
                return 1
            end
            $check_cmd $args

        case help
            echo $usage

        case '*'
            echo $usage >&2
            echo "error: unknown command: $cmd" >&2
            return 1
    end
end

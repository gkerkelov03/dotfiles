function git-status
    git status --porcelain -b | awk '
        function emit(group, line) { print group "\t" key "\t" line }

        BEGIN {
            green  = "\033[38;2;80;250;123m"
            yellow = "\033[38;2;241;250;140m"
            red    = "\033[38;2;255;85;85m"
            purple = "\033[38;2;189;147;249m"
            cyan   = "\033[38;2;139;233;253m"
            reset  = "\033[0m"
        }

        /^##/ { key = ""; emit(0, cyan $0 reset); next }

        {
            s = substr($0, 1, 2)
            file = substr($0, 4)
            key = file
            gsub(/"/, "", key)
        }

        s ~ /\?\?/ { emit(1, "  " purple "?? " reset file); next }
        s ~ /A/    { emit(2, "    " green "A " reset file); next }
        s ~ /M/    { emit(3, "      " yellow "M " reset file); next }
        s ~ /D/    { emit(4, "        " red "D " reset file); next }

        { emit(5, $0) }
    ' | LC_ALL=C sort -t \t -k1,1n -k2,2 | cut -f3-
end

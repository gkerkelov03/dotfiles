function git_status
    git status --porcelain -b | awk '
        BEGIN {
            green  = "\033[38;2;80;250;123m"
            yellow = "\033[38;2;241;250;140m"
            red    = "\033[38;2;255;85;85m"
            purple = "\033[38;2;189;147;249m"
            cyan   = "\033[38;2;139;233;253m"
            reset  = "\033[0m"
        }

        # 1. Handle the Branch Header
        /^##/ { print "0" cyan $0 reset; next }

        # 2. Extract status and filename
        {
            s = substr($0, 1, 2)
            file = substr($0, 4)
        }

        # 3. Categorize, Colorize, and Indent
        s ~ /A/    { print "1  " green "A " reset file; next }
        s ~ /M/    { print "2    " yellow "M " reset file; next }
        s ~ /D/    { print "3      " red "D " reset file; next }
        s ~ /\?\?/ { print "4        " purple "?? " reset file; next }

        # Fallback
        { print "5 " $0 }
    ' | sort -k1,1n | sed 's/^.//'
end

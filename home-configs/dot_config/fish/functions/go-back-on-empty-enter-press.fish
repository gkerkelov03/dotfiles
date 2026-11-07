function _parent_dirs --description "Print each parent of the current directory, nearest first"
    set -l dir $PWD
    while test "$dir" != /
        set dir (path dirname -- $dir)
        echo $dir
    end
end

function go-back-on-empty-enter-press --description "On an empty prompt, pick a parent directory with tv"
    if test -n "$(commandline | string trim)"
        commandline -f execute
        return
    end

    if test "$PWD" = /
        commandline -f repaint
        return
    end

    set -l target (_parent_dirs | tv --no-sort --preview-command "eza -1 --icons=always --color=always --group-directories-first '{}'")

    if test -n "$target"
        commandline -r -- "cd "(string escape -- $target)
        commandline -f suppress-autosuggestion
        commandline -f execute
    else
        commandline -r ""
        commandline -f repaint
    end
end

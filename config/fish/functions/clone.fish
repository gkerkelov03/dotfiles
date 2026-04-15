function clone --description 'Clone a git repo to a common location and cd into it'
    argparse h/help d/dir= -- $argv
    or return

    if set -q _flag_help
        echo "Usage: clone <git-url> [name] [-d/--dir <path>] [-h/--help]"
        return 0
    end

    if test (count $argv) -eq 0
        echo "Error: at least one argument required, use --help for command usage"
        return 1
    end

    set -l url $argv[1]
    set -l default_base (test -n "$clone_default_dir" && echo $clone_default_dir || echo ~/clones)
    set -l clone_base (test -n "$_flag_dir" && echo $_flag_dir || echo $default_base)
    set clone_base (string replace -r '/$' '' $clone_base)

    if not string match -qr '^(https?|git|ssh|git@).*\.git$|^(https?://|git@)[^/]+/[^/]+/?$' $url
        echo "Error: Invalid git URL: $url"
        return 1
    end

    if test (count $argv) -ge 2
        set -f name $argv[2]
    else
        set -f name (string match -r '([^/]+?)(?:\.git)?$' $url)[2]
    end

    if test -z "$name"
        echo "Error: Could not determine repository name"
        return 1
    end

    if not string match -qr '^[a-zA-Z0-9._-]+$' $name
        echo "Error: Invalid name '$name' - use only letters, numbers, dots, dashes, and underscores"
        return 1
    end

    set -l clone_dir $clone_base/$name

    if test -e $clone_dir
        set -l action

        if test -z "$clone_exists_action" -o "$clone_exists_action" = prompt
            echo "$clone_dir already exists. What would you like to do?"
            echo "  [s]kip    - Cancel clone operation"
            echo "  [r]ename  - Rename to .old"
            echo "  [d]elete  - Delete existing directory"
            read -l -n 1 -P "Choice [s/r/d]: " choice

            switch $choice
                case s S
                    set action skip
                case r R
                    set action rename
                case d D
                    set action delete
                case '*'
                    echo Cancelled
                    return 1
            end
        else
            set action $clone_exists_action
        end

        switch $action
            case skip
                echo "Clone operation cancelled"
                return 1

            case rename
                set -l backup_dir $clone_dir.old
                set -l counter 1
                while test -e $backup_dir
                    set backup_dir $clone_dir.old.$counter
                    set counter (math $counter + 1)
                end
                echo "Renaming existing directory to $backup_dir"
                mv $clone_dir $backup_dir

            case delete
                read -l -P "Delete $clone_dir and all its contents? [y/N] " confirm
                if string match -qi y $confirm
                    if test "$PWD" = (realpath $clone_dir)
                        cd $clone_base
                    end
                    rm -rf $clone_dir
                else
                    echo "Clone operation cancelled"
                    return 1
                end
        end
    end

    mkdir -p $clone_base

    if git clone $url $clone_dir
        cd $clone_dir
    else
        return 1
    end
end

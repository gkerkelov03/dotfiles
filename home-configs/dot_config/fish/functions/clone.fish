function clone --description 'git clone into ~/repos'
    if test (count $argv) -eq 0
        echo 'Usage: clone <url or user/repo> [git clone options]' >&2
        return 1
    end

    set -l repo $argv[1]
    if string match -rq '^[^/:@]+/[^/:@]+$' -- $repo
        set repo https://github.com/$repo
    end

    mkdir -p ~/repos
    and git -C ~/repos clone $repo $argv[2..]
end

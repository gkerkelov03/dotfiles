# clone <repo>
#
# <repo> can be any of:
#   https://github.com/owner/repo.git   full URL (any host)
#   git@github.com:owner/repo.git       SSH URL
#   owner/repo.git  or  owner/repo      short form, looked up on GitHub
#
# Clones a repo into ~/repos/<name>/ using the "bare repo + worktrees" layout:
#
#   ~/repos/<name>/.git/    all of git's data (history, branches, ...)
#   ~/repos/<name>/main/    the main branch, checked out and ready to work in
#
# Other branches go next to main/ with:
#   wt switch feat      existing remote branch -> ~/repos/<repo-name>/feat/
#   wt switch -c feat   brand-new branch based on the default branch -> ~/repos/<name>/feat/
function clone --description 'Clone a repo into ~/repos/<name>/ as bare repo + worktrees'
    set -l url $argv[1]

    # Short form (owner/repo) has no "://" and no "git@" -> turn it into a GitHub URL
    if not string match -q -r '://|^git@' -- $url
        set url https://github.com/$url
    end

    # Work out the repo name from the URL: .../caelestia.git -> caelestia
    set -l name (string replace -r '\.git$' '' -- (basename -- $url))
    set -l root ~/repos/$name

    # Stop if this repo is already cloned
    if test -e $root
        echo "clone: $root already exists" >&2
        return 1
    end

    # Download git's data into .git, with no files checked out (--bare).
    # --filter=blob:none = skip old versions of files; git fetches them later only if needed
    # --single-branch    = create a local branch only for main (others come from wt switch)
    git clone --bare --single-branch --filter=blob:none $url $root/.git; or return 1

    # Make `git fetch` download ALL branches from GitHub as origin/<branch>,
    # so `wt switch <branch>` can find them
    git -C $root config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
    git -C $root fetch origin

    # Find the default branch name (usually "main", sometimes "master")
    set -l main (git -C $root symbolic-ref --short HEAD)

    # Check out the default branch into its own folder: ~/repos/<name>/main/
    git -C $root worktree add $root/$main $main

    # Link local main to origin/main, so plain `git pull` and `git push` just work
    git -C $root/$main branch -u origin/$main

    echo "✓ cloned to $root/$main"
end

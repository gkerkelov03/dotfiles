eval "$(starship init zsh)"
eval "$(zoxide init zsh)"  

export STARSHIP_CONFIG=~/dotfiles/config/starship/starship.toml

setopt \
  INC_APPEND_HISTORY      # write commands to history immediately
  SHARE_HISTORY           # share history across all shells
  HIST_IGNORE_ALL_DUPS    # remove all duplicate entries (not just consecutive)
  HIST_FIND_NO_DUPS       # skip duplicates when searching history
  HIST_SAVE_NO_DUPS       # don't write duplicates to history file
  HIST_REDUCE_BLANKS      # clean up extra spaces in history

  AUTO_CD                 # cd by typing directory name
  AUTO_PUSHD              # push directories onto stack automatically
  PUSHD_IGNORE_DUPS       # avoid duplicate dirs in stack
  PUSHD_SILENT            # no output from pushd/popd

  EXTENDED_GLOB           # advanced globbing (power feature)
  GLOB_DOTS               # include hidden files in globbing
  NO_CASE_GLOB            # case-insensitive globbing
  NO_CASE_MATCH           # case-insensitive matching

  COMPLETE_IN_WORD        # tab completion inside words
  ALWAYS_TO_END           # move cursor to end after completion
  AUTO_MENU               # cycle completion menu on TAB

  INTERACTIVE_COMMENTS    # allow comments in command line
  MAGIC_EQUAL_SUBST       # expand paths in assignments (VAR=~/dir)

  CORRECT                 # suggest command corrections (optional but "modern")

  NOMATCH                 # fail fast if glob matches nothing (safety)

  NO_BEEP                 # disable terminal beeping
    
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit

alias ls='eza -G --icons --classify --color=always --group-directories-first'
alias la='eza -a --icons --color=always --group-directories-first'
alias ll='eza -lAh --icons --octal-permissions --no-user --group-directories-first --git --header --color=always'

alias vim="nvim"
alias cat="bat"
alias grep="rg"
alias du="dust"
alias df="duf"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias chrome="google-chrome &"
alias hms="home-manager switch --flake ~/.config/home-manager\#qwest"

man() { tldr "$@" 2>/dev/null && return command man "$@"directory }
gac() { git add . && git commit -m "$*" }

cd() { z "$@" && ll }
cdi() { zi "$@" && ll }
mkcd() { mkdir -p "$1" && cd "$1"; }

zjump() { cd "$(zoxide query -l | fzf)" || echo "Canceled" }
tree() { fd --type d . | sed 's|[^/]*/| |g' ; }

zip() { ouch compress "$@" "$@.zip"}
unzip() { ouch decompress "$@"}

fedit() {
    local file
    file=$(fd --type f . | fzf --preview 'bat --style=numbers --color=always {}' --height=50%)
    [ -n "$file" ] && nvim "$file"
}

fzfcd() {
    local dir
    dir=$(find . -type d | fzf --height 50% --reverse --prompt "Dir> ") && cd "$dir"
}



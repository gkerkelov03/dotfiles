eval "$(starship init zsh)"
eval "$(zoxide init zsh)"  

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY SHARE_HISTORY AUTO_CD PUSHD_IGNORE_DUPS EXTENDED_GLOB \
       CORRECT AUTO_MENU NOMATCH HIST_IGNORE_DUPS HIST_REDUCE_BLANKS NO_BEEP

autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit

alias ls='eza -G --icons --classify --color=always --group-directories-first'
alias la='eza -a --icons --color=always --group-directories-first'
alias ll='eza -lAh --icons --octal-permissions --no-user --group-directories-first --git --header --color=always'

alias vim="nvim"
alias cat="bat"
alias grep="rg"
alias curl="curlie"
alias du="dust"
alias df="duf"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias chrome="google-chrome &"
alias hms="home-manager switch --flake ~/.config/home-manager\#qwest"

cd() { z "$@" && ll }
cdi() { zi "$@" && ll }
mkcd() { mkdir -p "$1" && cd "$1"; }
zjump() { cd "$(zoxide query -l | fzf)" || echo "Canceled" }
man() { tldr "$@" 2>/dev/null && return command man "$@"directory }
tree() { fd --type d . | sed 's|[^/]*/| |g' ; }
gac() { git add . && git commit -m "$*" }

fedit() {
    local file
    file=$(fd --type f . | fzf --preview 'bat --style=numbers --color=always {}' --height=50%)
    [ -n "$file" ] && nvim "$file"
}

fzfcd() {
    local dir
    dir=$(find . -type d | fzf --height 50% --reverse --prompt "Dir> ") && cd "$dir"
}



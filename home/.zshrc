eval "$(starship init zsh)"
eval "$(zoxide init zsh)"  

export STARSHIP_CONFIG=~/dotfiles/config/starship/starship.toml

setopt \
    INC_APPEND_HISTORY    #add command to history immediately
    SHARE_HISTORY         #share history across all open shells
    AUTO_CD               #allow 'cd' by typing directory name only
    PUSHD_IGNORE_DUPS     #avoid duplicate entries in directory stack
    EXTENDED_GLOB         #enable advanced globbing patterns
    CORRECT               #suggest corrections for mistyped commands
    AUTO_MENU             #cycle through completion options with TAB
    NOMATCH               #zsh: no matches found: *.txt instead of error
    HIST_IGNORE_          #remove consecutive duplicate history entries
    HIST_REDUCE_BLANKS    #remove extra spaces before saving history
    NO_BEEP               #disable beep sound
    
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



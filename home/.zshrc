eval "$(starship init zsh)"
eval "$(zoxide init zsh)"  

# -----------------------------
# History & shell options
# -----------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY SHARE_HISTORY AUTO_CD PUSHD_IGNORE_DUPS EXTENDED_GLOB \
       CORRECT AUTO_MENU NOMATCH HIST_IGNORE_DUPS HIST_REDUCE_BLANKS NO_BEEP

# -----------------------------
# Completion
# -----------------------------
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit

# -----------------------------
# Aliases: modern replacements
# -----------------------------
alias l='eza -G --icons --classify --color=always --group-directories-first'
alias la='eza -a --icons --color=always --group-directories-first'
alias ll='eza -lAh --icons --octal-permissions --no-user --group-directories-first --git --header --color=always'

alias g='git'
alias gs='git s'     # Calls the 's' alias inside git config
alias gl='git lg'    # Calls the 'lg' alias inside git config
alias gd='git d'     # Calls the 'd' alias (Delta diff)
alias gp='git push'

alias v="nvim"
alias cat="bat"
alias grep="rg"
alias du="dust"
alias df="duf"

alias chrome="google-chrome &"

# -----------------------------
# Navigation helpers
# -----------------------------
# mkcd: make directory + enter it
mkcd() { mkdir -p "$1" && cd "$1"; }

#zoxide with fuzzy finder
zjump() {
  cd "$(zoxide query -l | fzf)" || echo "Canceled"
}

# -----------------------------
# TLDR wrapper: fallback to bat if page missing
# -----------------------------
tldr() { command tldr "$@" 2>/dev/null || bat "$@" ; }

# -----------------------------
# Fuzzy search & file edit
# -----------------------------
fedit() {
    local file
    file=$(fd --type f . | fzf --preview 'bat --style=numbers --color=always {}' --height=50%)
    [ -n "$file" ] && nvim "$file"
}

# -----------------------------
# Git helpers
# -----------------------------
lg() { lazygit "$@" }
ghs() { gh status "$@" }

# Git add/stage/commit shorthand
gac() { git add . && git commit -m "$*" }
gaa() { git add --all }
gco() { git checkout "$@" }

# -----------------------------
# Docker helpers
# -----------------------------
ld() { lazydocker "$@" }

# -----------------------------
# Fuzzy directory jumping
# -----------------------------
fzfcd() {
    local dir
    dir=$(find . -type d | fzf --height 50% --reverse --prompt "Dir> ") && cd "$dir"
}

# -----------------------------
# Misc handy shortcuts
# -----------------------------
# Quick tree view of current directory
tree() { fd --type d . | sed 's|[^/]*/| |g' ; }

# -----------------------------
# Go to previous directory quickly
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

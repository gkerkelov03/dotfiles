# -----------------------------
# Starship prompt
# -----------------------------
eval "$(starship init zsh)"

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
eval "$(zoxide init zsh)"  # fast directory jumping

# -----------------------------
# Aliases: modern replacements
# -----------------------------
alias l="eza -C -F --color=always"
alias ll='eza --long --all --human-readable --color=always'  
alias la='eza --all --color=always'  
alias l='eza --grid --classify --color=always'  

alias gs="git status"
alias gp="git push"
alias gl="git log --oneline --graph --decorate"
alias gd="git diff | delta"

alias vim="nvim"
alias top="btop"
alias cat="bat"
alias grep="rg"
alias du="dust"
alias df="duf"

alias chrome="google-chrome &"
alias update="sudo apt update && sudo apt upgrade -y"
alias c="clear"

# -----------------------------
# Navigation helpers
# -----------------------------
# mkcd: make directory + enter it
mkcd() { mkdir -p "$1" && cd "$1"; }

# cd with zoxide integration
z() { zoxide add "$PWD"; cd "$1"; } # automatically adds current dir before cd

#zoxide with fuzzy finder
zjump() {
  cd "$(zoxide query -l | fzf)" || echo "Canceled"
}

# go up N directories: e.g., up 3
up() { cd $(printf "%s/.." $(seq 1 $1)) }

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
# JSON helpers
# -----------------------------
jqr() { jq "$@" }
fxr() { fx "$@" }

# -----------------------------
# Interactive prompts with gum
# -----------------------------
ask() { gum input --prompt "$1: " }
confirm() { gum confirm "$1" }

# -----------------------------
# Quick project navigation
# -----------------------------
cdrepo() { cd ~/code/"$1" || echo "Project not found" }
# zoxide + fzf project jump
proj() { cd "$(ls -d ~/code/* | fzf)" || echo "Canceled" }

# -----------------------------
# Fun / info commands
# -----------------------------
matrix() { neo }
fetch() { fastfetch }

# -----------------------------
# Dotfiles management
# -----------------------------
stowrc() { stow -t ~ "$@" }

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
# Open editor in current directory
v() { nvim "$@" ; }

# Open bat preview in pager for any file
bp() { bat "$@" | less -R; }

# Quick tree view of current directory
tree() { fd --type d . | sed 's|[^/]*/| |g' ; }

# Quick search for text in current project
fs() { rg --color=always "$@" | fzf --ansi --preview 'bat --color=always {1}' ; }

# Clipboard helpers (if xclip installed)
copy() { xclip -selection clipboard <<< "$*" ; }
paste() { xclip -selection clipboard -o ; }

# -----------------------------
# Go to previous directory quickly
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

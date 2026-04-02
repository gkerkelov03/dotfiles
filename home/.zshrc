export STARSHIP_CONFIG=~/dotfiles/config/starship/starship.toml

#set default apps
export EDITOR="nvim"           #default editor
export VISUAL="nvim"           #used by interactive tools
export SUDO_EDITOR="nvim"      #ensures sudoedit uses nvim
export BROWSER="google-chrome" #default browser

#setup the zsh history file and in memory history each session
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=5000
export SAVEHIST=5000

# History behavior
setopt INC_APPEND_HISTORY      #immediately add command to history
setopt SHARE_HISTORY           #share history across sessions
setopt HIST_IGNORE_ALL_DUPS    #remove duplicate entries
setopt HIST_REDUCE_BLANKS      #remove extra spaces

# Directory stack behavior
setopt AUTO_PUSHD              #track directory stack
setopt PUSHD_IGNORE_DUPS       #no duplicate directories in stack
setopt PUSHD_SILENT            #do not print pushd/popd output

# Globbing & file matching
setopt EXTENDED_GLOB           #advanced globbing (**/*.txt, etc.)
setopt GLOB_DOTS               #include hidden files (.*)
setopt NO_CASE_GLOB            #globbing is case-insensitive
setopt NO_CASE_MATCH           #pattern matching is case-insensitive
setopt NOMATCH                 #fail with error message 

# Completion & command editing
setopt COMPLETE_IN_WORD        #completion works in middle of word
setopt ALWAYS_TO_END           #cursor goes to end after completion
setopt AUTO_MENU               #menu-based completion
setopt INTERACTIVE_COMMENTS    #allow comments in commands

# Convenience & usability
setopt MAGIC_EQUAL_SUBST       #expand paths in VAR=~/something
setopt AUTO_CD                 #type directory name instead of cd dir
setopt NO_BEEP                 #disable annoying bell




# --- Simple Dracula Completion ---
autoload -Uz compinit && compinit -C

# --- Clean Dracula Completion ---
export LS_COLORS="di=36:ln=35:ex=32:bd=34:cd=34"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Fixed Dracula Theme for FZF
export FZF_DEFAULT_OPTS='
  --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
  --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
  --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
  --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
  --reverse --height 40% --border'

# Apply the theme to fzf-tab
zstyle ':fzf-tab:*' fzf-flags '--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9,fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9'
zstyle ':fzf-tab:*' switch-group ',' '.'








#Setup ls to use eza
alias ls="eza -a1 --icons --git --group-directories-first --color-scale --mounts"
alias lsl="eza -la --icons --octal-permissions --group --git --header --group-directories-first --color-scale --created --mounts --modified"
alias lsls="eza -la --icons --total-size --octal-permissions --group --git --header --group-directories-first --color-scale --created --mounts --modified"

alias vim="nvim"
alias cat="bat"
alias grep="rg"
alias du="dust"
alias df="duf"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."


alias symlink-dotfiles="sh ~/dotfiles/scripts/symlink-dotfiles"
alias hms="home-manager switch --flake ~/.config/home-manager\#qwest"

man() { tldr "$@" 2>/dev/null || command man "$@" }
gac() { git add . && git commit -m "$*" }

cd() { z "$@" && ls }
cdi() { zi "$@" && ls }
mkcd() { mkdir -p "$1" && cd "$1"; }

zjump() { cd "$(zoxide query -l | fzf)" || echo "Canceled" }

zip() { ouch compress "$@" "${1:r}.zip" }
unzip() { ouch decompress "$@" }

plugins=(
    git                      # Git aliases
    sudo                     # Retypes command with sudo in front
    copypath                 # Copy pwd to clipboard
    copyfile                 # Copy file to clipboard
    copybuffer               # Ctrl+O to copy the current command to clipboard
    zsh-autosuggestions      # suggestions based on history
    zsh-syntax-highlighting  # Colorize commands
    fzf-tab
    zsh-autopair
    zsh-completions
    you-should-use

)

#start the necessary tools
eval "$(fzf --zsh)" 
eval "$(zoxide init zsh)"  
eval "$(atuin init zsh --disable-up-arrow)"
eval "$(sheldon source)"
eval "$(starship init zsh)"

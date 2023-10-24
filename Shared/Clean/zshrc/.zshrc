export ZSH="$HOME/.oh-my-zsh"

# For catac in fzf
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"


pokeget random

ZSH_THEME="robbyrussell"

plugins=(git archlinux aliases alias-finder colored-man-pages web-search copypath zsh-syntax-highlighting zsh-autocomplete)

source $ZSH/oh-my-zsh.sh

eval "$(zoxide init zsh --cmd cd)"

source $HOME/.local/share/Cryptomator/mnt/Nexus/Documents/Arch/.toks
alias hosts="nvim $HOME/.local/share/Cryptomator/mnt/Nexus/Documents/Arch/.toks"

# TODIST cml
source "/usr/share/todoist-cli/todoist_functions_fzf.sh"
alias tds="todoist-cli --color --header --indent list --filter '(today | overdue) & #Education'"
alias tdp="todoist-cli --color --header --indent list --filter '(today | overdue) & #Personal'"
alias tda="todoist-cli --color --header --indent list --filter '#Arch'"
alias tdtmr="todoist-cli --color --header --indent list --filter '(tomorrow)'"
alias td="todoist-cli --color --header --indent list --filter '(today | overdue)'"





# Alias

# ZSH grabbing
alias editzsh="nvim ~/.zshrc"
alias sourcezsh="source ~/.zshrc"


alias timer="termdown -c 60 -t 'DONE'"
alias cal="calcure"
alias top="bpytop"

# Ranger
alias rr='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

# Spotify-launcher
alias spotify="spotify_player"


# OpenAI
alias question="mods"
alias conversation="mods --continue-last"

# Virtmanager
alias gaming="sudo virsh start win11"
alias stopgaming="sudo virsh shutdown win11"
alias testing="sudo virsh start teleport-ubuntu22.04 && sleep 60 && sshfs testing@192.168.122.125:/home/testing/ /home/alex/Documents/devfolder/ && sleep 3 && cd $HOME/Documents/devfolder && nvim"
alias stoptesting="sudo virsh shutdown teleport-ubuntu22.04 && sleep 30 && fusermount -u $HOME/Documents/devfolder"


# Docker Compose
alias dcu="docker compose up -d"
alias dcd="docker compose down"

# Exa
alias ld='eza -lD'
alias lf='eza -lF --color=always | grep -v /'
alias lh='eza -dl .* --group-directories-first'
alias la='eza -al --group-directories-first'
alias ls='eza -alF --color=always --sort=size | grep -v /'
alias lt='eza -al --sort=modified'
alias ldt='eza -lDT'
alias lft='eza -lFT --color=always | grep -v /'
alias lht='eza -dlT .* --group-directories-first'
alias lat='eza -alT --group-directories-first'
alias lst='eza -alFT --color=always --sort=size | grep -v /'
alias ltt='eza -alT --sort=modified'
# Train
alias train='sl'
# Storage
alias storage="duf"
# Security
alias scan="arch-audit && sudo rkhunter --check"
# Files stuff
alias cat="bat"

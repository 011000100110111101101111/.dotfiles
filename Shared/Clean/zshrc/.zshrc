export ZSH="$HOME/.oh-my-zsh"

pokeget random

ZSH_THEME="robbyrussell"

plugins=(git archlinux aliases alias-finder colored-man-pages web-search copypath zsh-syntax-highlighting zsh-autocomplete)

source $ZSH/oh-my-zsh.sh

eval "$(zoxide init zsh --cmd cd)"

source $HOME/.local/share/Cryptomator/mnt/Nexus/Documents/Arch/.toks
alias hosts="nvim $HOME/.local/share/Cryptomator/mnt/Nexus/Documents/Arch/.toks"




# Alias

alias zshrc="nvim ~/.zshrc"
alias timer="termdown -c 60 -t 'DONE'"
alias cal="calcure"
alias top="bpytop"

alias gaming="sudo virsh start win11"
alias stopgaming="sudo virsh shutdown win11"

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

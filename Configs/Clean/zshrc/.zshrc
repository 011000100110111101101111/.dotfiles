export ZSH="$HOME/.oh-my-zsh"

pokeget random

ZSH_THEME="spaceship"

plugins=(
  git zsh-autocomplete zsh-syntax-highlighting
  kubectl aliases ansible
  colored-man-pages colorize command-not-found
  docker docker-compose emoji-clock
  firewalld git git-prompt
  helm history last-working-dir
  lxd nmap podman
  ripgrep systemd thefuck
  themes timer transfer
  ufw vault web-search
  vscode zsh-interactive-cd zoxide archlinux
  alias-finder
)
source $ZSH/oh-my-zsh.sh

eval "$(zoxide init zsh --cmd cd)"
eval "$(thefuck --alias redo)"

#source $HOME/.local/.temp
#alias hosts="nvim $HOME/.local/.temp"

# TODIST cml
#source "/usr/share/todoist-cli/todoist_functions_fzf.sh"
alias tds="todoist-cli --color --header --indent list --filter '(today | overdue) & #Education'"
alias tdp="todoist-cli --color --header --indent list --filter '(today | overdue) & #Personal'"
alias tda="todoist-cli --color --header --indent list --filter '#Arch'"
alias tdt="todoist-cli --color --header --indent list --filter '(tomorrow)'"
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


# OpenAI
alias question="mods"
alias conversation="mods --continue-last"

# Virtmanager
#alias gaming="sudo virsh start win11"
#alias stopgaming="sudo virsh shutdown win11"
#alias testing="sudo virsh start teleport-ubuntu22.04 && sleep 60 && sshfs testing@192.168.122.125:/home/testing/ /home/alex/Documents/devfolder/ && sleep 3 && cd $HOME/Documents/devfolder && nvim"
#alias stoptesting="sudo virsh shutdown teleport-ubuntu22.04 && sleep 30 && fusermount -u $HOME/Documents/devfolder"
#alias kubes="sudo virsh start LearningKubernettes && sudo virsh start WorkerNodeB && sudo virsh start WorkerNodeA"
#alias stopkubes="sudo virsh shutdown LearningKubernettes && sudo virsh shutdown WorkerNodeB && sudo virsh shutdown WorkerNodeA"

# Docker Compose
#alias dcu="docker compose up -d"
#alias dcd="docker compose down"


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

# Debugging hyprctl clients
alias hyprctlclients='watch -n 0.1 "cat "/tmp/hypr/$(echo $HYPRLAND_INSTANCE_SIGNATURE)/hyprland.log" | grep -v "efresh" | grep "rule" | tail -n 40"'



alias kpods='kubectl get pods -A --no-headers | awk "{print \$2, \$1}" | fzf --ansi --multi --preview "kubectl describe pod {1} -n {2}" | xargs -n 2 sh -c "kubectl describe pod \$0 -n \$1"'
alias kservices='kubectl get services -A --no-headers | awk "{print \$2, \$1}" | fzf --ansi --multi --preview "kubectl describe services {1} -n {2}" | xargs -n 2 sh -c "kubectl describe services \$0 -n \$1"'

alias kpodsshort='kubectl get pods -A --no-headers | awk "{print \$2, \$1}" | fzf --ansi --multi --preview "kubectl describe pod {1} -n {2} | awk '\''/^IP:/ {print \"IP: \" \$2} ; /^Name:/ {print \"Name: \" \$2} ; /^Namespace:/ {print \"Namespace: \" \$2} ; /^Node:/ {print \"Node: \" \$2} ; /^Status:/ {print \"Status: \" \$2} ; /^Service Account:/ {print \"Service Account: \" \$3} ; /^Image:/ {print \"Image: \" \$2} ; /^Ports:/ {print \"Ports: \" \$2} ; /^Host Ports:/ {print \"Host Ports: \" \$2} ; /^State:/ {print \"State: \" \$2} ; /^Ready:/ {print \"Ready: \" \$2}'\''" | xargs -n 2 sh -c "kubectl describe pod \$0 -n \$1"'

alias run-ansible='find ./ -type f -name "*.yml" -printf "%P\n" | fzf --multi --ansi --preview "cat {}" --preview-window=right:60%:wrap | awk "{print \$1}" | xargs -I {} sh -c '\''echo {} && find ./ -type f -name "*.ini" -printf "%P\n" | fzf --ansi --preview "cat {}" --preview-window=right:60%:wrap'\'' | xargs -n 2 sh -c "ansible-playbook \$0 -i \$1"'
# TODO: Create ansible parser with fuzzy menu, can let us choose the playbook and the inventory file


alias runocaml="eval $(opam env)"

#autoload -U +X bashcompinit && bashcompinit
#complete -o nospace -C /usr/bin/terraform terraform

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Zsh completions
# todo: need to refactor at next fresh install
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
autoload -Uz compinit
compinit
zmodload zsh/complist
setopt AUTO_CD

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# ================= User configuration ===============

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
set rtp+=/opt/homebrew/opt/fzf

############## MY_ALIASES ############## 

# export CLOUDFLARE_API_TOKEN=""
# https://developers.cloudflare.com/terraform/advanced-topics/provider-customization/#increase-the-frequency-of-api-requests
# export CLOUDFLARE_RPS=
# export CLOUDFLARE_API_CLIENT_LOGGING=true
# export CLOUDFLARE_MAX_BACKOFF=20

# general
alias pc='pwd | pbcopy'
alias c='pbcopy'
alias hi='history -i'
alias ll='ls -la'
alias l='ls -lah'

# nvim, IDE
alias n=nvim

# terraform
alias t=terraform
alias ti="t init -upgrade"
alias tv="t validate"
alias tp="t plan -lock=false"
alias ta="tv; t fmt; t apply"
alias td="t destroy"
alias to="t output"
alias tfu="t force-unlock -force"
alias tu="tftui"

# terraform modules fix
export TFENV_ARCH=amd64
export TENV_AUTO_INSTALL=true

# opentofu
alias ot=tofu
alias oti="ot init -upgrade"
alias otv="ot validate"
alias otp="otv; ot fmt; ot plan"
alias ota="otv; ot fmt; ot apply"
alias otd="ot destroy"
alias oto="ot output"

# helm
alias h=helm
export XDG_DATA_HOME=$HOME

alias p=/opt/homebrew/bin/python3.13
alias pip=pip3

# private-repo
#export GITHUB_USER=
#export GITHUB_TOKEN=''
#export GITHUB_PRIVATE_SIGN_TOKEN=''

# quay.io registry
#export QUAY_USERNAME=
#export QUAY_PASSWD_ENCRYPTED=''

# google
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
#alias g-creds="gcloud container clusters get-credentials $(t output -raw kubernetes_cluster_name) --region $(t output -raw region) --project $(t output -raw project)"


# Homebrew
export PATH=/opt/homebrew/Cellar/go/1.23.2/bin:$PATH:/opt/homebrew/bin:$HOME/opt/sbin/zmap:/opt/homebrew/Cellar/zmap/3.0.0/sbin:/opt/homebrew/bin

alias f=flux

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# ruby 
#export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

#export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
#export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"

#source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
#source /opt/homebrew/opt/chruby/share/chruby/auto.sh
#chruby ruby-3.1.3

# Docker
alias d=docker
#export DOCKER_USERNAME=
#export DOCKER_PASSWORD=

# myself funcs

# base64
b() { [[ $# -eq 0 ]] && base64 || printf %s "$*" | base64 }
bd() { [[ $# -eq 0 ]] && base64 -d || printf %s "$*" | base64 -d }

# Generate simple passwords
# pw() { LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c $1 ; echo '' }
pw() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: pw <password_length>"
    return 1
  fi

  password_length=$1

  LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c $password_length
}

# Generate file test.txt 
gen_file() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: gen_file <file_size_in_MB>"
    return 1
  fi

  file_size="${1}M"

  dd if=/dev/urandom of=test.txt bs=$file_size count=1
}

# GIT
alias g="pre-commit run --all-files; git"
alias gu="git pull"
alias gm="git checkout master --force && git reset --hard origin/master && git pull"
alias gma="git checkout main --force && git reset --hard origin/main && git pull"
alias gs="git status"
alias gb="git checkout -b"
alias gbl="git branch"
alias gbc="git checkout"

# git add && commit && push
gpa() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: gpa <commit message>"
    return 1
  fi

  commit_message="$*"
  commit_message=$(echo "$commit_message" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')
  git add . && git commit -am "$commit_message" && git push
}

# git add tag
gt() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: gt <TAG_NAME>"
    return 1
  fi

  git_tag=$1
  git tag $git_tag; git push origin $git_tag
}

# git delete tag
gtd() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: gtd <TAG_NAME>"
    return 1
  fi

  git_tag=$1
  git tag -d $git_tag; git push origin --delete $git_tag
}

# git `replace` tag
gtr() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: gtr <TAG_NAME>"
    return 1
  fi
  git_tag=$1
  gtd $git_tag 
  gt $git_tag 
}

gbq() {
    curr_branch=$(git rev-parse --abbrev-ref HEAD)
    git checkout master
    git pull
    git checkout -b "${curr_branch}-squashed"
    git merge --squash "${curr_branch}"
    git commit -m "${curr_branch} squashed into ${curr_branch}-squashed"
    git push
}

# Enable fingerprint scan for console sudo
alias fingerprinton="grep -qxF 'auth sufficient pam_tid.so' /etc/pam.d/sudo || echo 'auth sufficient pam_tid.so' | sudo tee -a /etc/pam.d/sudo > /dev/null"

# VM on multipass 
# ma() { multipass stop $(multipass list --format yaml | yq eval 'keys | .[]' -) }

alias vz="vim ~/.zshrc ; source ~/.zshrc"

export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="/opt/homebrew/Cellar/go/1.23.3/bin/:$PATH"
export GOPATH="/opt/homebrew/Cellar/go/1.23.3"

export PATH="/opt/homebrew/sbin:$PATH"
fpath+=${ZDOTDIR:-~}/.zsh_functions
export PATH=/opt/homebrew/opt/dotnet/bin/:$PATH
export PATH="$PATH:/Users/akrugliak/.dotnet/tools"

export XDG_CONFIG_HOME=$HOME
export CLOUDSDK_PYTHON=/opt/homebrew/bin/python3.12

export TERM=xterm-256color

# Kubenetes
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
source <(kubectl completion zsh)
alias k=kubectl
alias kg='k get'
alias kgp='kg po'
alias kgn='kg no'
alias kgd='kg deploy'
alias kgs='kg secret'
alias knx=kubectx
alias kns=kubens
alias 9=k9s
alias ka='k apply -f'
alias kd='k delete -f'

# AWS
#export AWS_PROFILE=
export AWS_REGION=eu-north-1


eval "$(starship init zsh)"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

export PATH=$PATH:/usr/local/opt/homebrew/bin

# zoxide init
eval "$(zoxide init zsh)"


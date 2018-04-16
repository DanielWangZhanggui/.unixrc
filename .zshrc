##-------------------------------------------------------------------------------
## Zsh configs
##-------------------------------------------------------------------------------
# Change to your oh-my-zsh configuration.
ZSH=$HOME/.unixrc/oh-my-zsh

# Set name of the theme to load. Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each time
# that oh-my-zsh is loaded.
ZSH_THEME="deyuan"

# Change to pkg download directory.
TOOLS=$HOME/.unixrc/tools

# Set to this to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting
# for completion.
COMPLETION_WAITING_DOTS="true"

# Disable beeping
setopt NO_BEEP

# Which plugins would you like to load? (plugins can be found in $ZSH/plugins/*)
# Custom plugins may be added to $ZSH/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git python go vagrant docker-docker)

##------------------------------------------------------------------------------
## Special configs
##------------------------------------------------------------------------------
if [[ `uname` == "Darwin" ]]; then
  # Homebrew requires /usr/local/bin and /usr/local/sbin, and /usr/local/bin
  # should to appear before /usr/bin.
  export PATH=/usr/local/sbin:$PATH
  export PATH=/usr/local/bin:$PATH
fi

##------------------------------------------------------------------------------
## General configs for all machines
##------------------------------------------------------------------------------
alias cp="cp -i"
alias lg="ll --group-directories-first"
alias mv="mv -i"
alias pc="proxychains4"
alias ppj="python -mjson.tool"             # Beautify json print
alias rm="rm -i"
alias sgrep="grep -rnI -C3 --color=always" # Colorful grep
alias drm="docker rm"
alias dps="docker ps"
alias cnpm="npm --registry=https://registry.npm.taobao.org \
--cache=$HOME/.npm/.cache/cnpm \
--disturl=https://npm.taobao.org/dist \
--userconfig=$HOME/.cnpmrc"
alias docker-ip='function _dip() { docker inspect --format "{{ .NetworkSettings.IPAddress }}" $1; };_dip'
alias docker-pid='function _dpid() { docker inspect --format "{{ .State.Pid }}" $1; };_dpid'

source $ZSH/oh-my-zsh.sh        # Re-exec shell script
source $TOOLS/z/z.sh            # Enable z.sh
bindkey -e                      # Bind keys

# Kubernetes environment.
if [ -d $HOME/code/workspace/src/k8s.io/kubernetes/_output/local/go/bin ]; then
  export PATH=$HOME/code/workspace/src/k8s.io/kubernetes/_output/local/go/bin:$PATH
  # This is effectively how kubectl plugin works; but since kubectl locates at
  # 'weird' location, don't use it directly.
  source <(kubectl completion zsh)
fi

# Cloud environment.
[[ -f "$HOME/code/source/google-cloud-sdk/path.zsh.inc" ]] && source "$HOME/code/source/google-cloud-sdk/path.zsh.inc"
[[ -f "$HOME/code/source/google-cloud-sdk/path.zsh.inc" ]] && source "$HOME/code/source/google-cloud-sdk/completion.zsh.inc"
[[ -f "$HOME/code/source/azure-cli/az.completion" ]] && source "/home/deyuan/code/source/azure-cli/az.completion"

# Go environment.
export GOPATH=$HOME/code/workspace
export CDPATH=$CDPATH:$GOPATH/src
if [[ `uname` != "Darwin" ]]; then
  # For non-Mac, set PATH for golang bin path. In mac, go is installed using
  # homebrew, which manages binaries under /usr/local/bin, so it's unnecessary
  # to set PATH here.
  export PATH=/usr/local/go/bin:$PATH
fi
export PATH=$GOPATH/bin:$PATH

# Ruby environment.
if [ -x $HOME/.rbenv/bin/rbenv ]; then
  export PATH=$PATH:$HOME/.rbenv/bin
  eval "$(rbenv init -)"
fi

# Add misc useful tools to PATH
export PATH=$PATH:$HOME/code/tool/scripts




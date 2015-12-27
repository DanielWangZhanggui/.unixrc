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
plugins=(git python go vagrant docker)


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
[[ -f "$HOME/code/source/google-cloud-sdk/path.zsh.inc" ]] && source "$HOME/code/source/google-cloud-sdk/path.zsh.inc"
[[ -f "$HOME/code/source/google-cloud-sdk/path.zsh.inc" ]] && source "$HOME/code/source/google-cloud-sdk/completion.zsh.inc"
export PATH=$HOME/code/source/go-workspace/src/k8s.io/kubernetes/_output/local/go/bin:$PATH

# Go environment.
export GOPATH=$HOME/code/source/go-workspace
export CDPATH=$CDPATH:$GOPATH/src
export PATH=/usr/local/go/bin:$PATH
export PATH=$HOME/code/source/go-workspace/bin:$PATH

# Ruby environment.
if type "rbenv" >/dev/null; then
  export PATH=$HOME/.rbenv/bin:$PATH
  eval "$(rbenv init -)"
fi

##-------------------------------------------------------------------------------
## Configs for Linux and Mac
##   chrome:  open file in new tab (chrome should already be opened)
##   emacs:   open file in new frame (GUI emacs should already be opened)
##   emacsnw: open terminal emacs
##   emacsserver: open emacs GUI
##-------------------------------------------------------------------------------
if [[ `uname` == "Darwin" ]]; then
  alias chrome="open -a Google\ Chrome"
  alias emacs="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -n"
  alias emacsnw="TERM=xterm-256color /Applications/Emacs.app/Contents/MacOS/Emacs -nw"
  alias emacsserver="/Applications/Emacs.app/Contents/MacOS/Emacs"
  # Docker is running in a VM, see code/tool/vagrant/ubuntu/Vagrantfile (docker-machine
  # is not stable). Note this only works in current shell session, i.e. if running a
  # script which has `docker` command, "-H" option won't take effect.
  alias docker="docker -H=192.168.33.33:2375"
  # Need full path for EDITOR variable in OSX.
  export EDITOR="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
  export HOMEBREW_TEMP=/usr/local/TEMP
  source `brew --prefix`/etc/profile.d/z.sh
elif [[ `uname` == "Linux" ]]; then
  alias chrome="google-chrome"
  alias emacs="/usr/local/bin/emacsclient -n"
  alias emacsnw="TERM=xterm-256color /usr/local/bin/emacs -nw"
  alias emacsserver="/usr/local/bin/emacs"
  export EDITOR="emacsclient"     # TODO: make sure emacs server started
fi


##-------------------------------------------------------------------------------
## Configs for different hosts
##-------------------------------------------------------------------------------
if [[ `hostname` == "Deyuans-Macbook-Air.local" ]]; then
  alias mysql=/usr/local/mysql/bin/mysql
  alias mysqladmin=/usr/local/mysql/bin/mysqladmin
  alias mysqld_safe=/usr/local/mysql/bin/mysqld_safe
elif [[ `hostname` == "Deyuans-Macbook-Pro.local" ]]; then
elif [[ `hostname` == "deyuan.pit.corp.google.com" ]]; then
  unsetopt correct_all          # Do not autocorrect
  export P4EDITOR="emacsclient"
  source /etc/bash_completion.d/g4d
elif [[ `hostname` == "deyuan-macbookpro.roam.corp.google.com" ]]; then
elif [[ `hostname` == "watermelon" ]]; then
  # eval `dircolors ~/.dir_colors` # do not using annoying background for 'ls'
fi

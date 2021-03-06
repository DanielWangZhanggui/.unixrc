#!/bin/bash
set +x

#
# Mac version
#
MAC_VERSION=10.8

#
# Package versions
# Package versions do not matter that much in Mac.
#
EMACS_VERSION="24.5"
GO_VERSION="1.4"


#
# DO NOT CHANGE (Assume Mac, rely on package naming convention).
#
EMACS_PACKAGE="emacs-${EMACS_VERSION}.tar.xz"
EMACS_DIR="emacs-${EMACS_VERSION}"
EMACS_URL="http://gnu.mirror.constant.com/emacs/emacs-${EMACS_VERSION}.tar.xz"
GO_PACKAGE="go${GO_VERSION}.darwin-amd64-osx${MAC_VERSION}.tar.gz"
GO_DIR="go"                     # package gets renamed after unzip.
GO_URL="http://golang.org/dl/$GO_PACKAGE"


#
# Entry point
# NOTE: the installation order matters.
#
function InstallAll() {

  if [[ $USER = "root" ]]; then
    echo "Do not run as root, configuration depends on user name."
    exit
  fi

  # Install system packages to /usr/.
  InstallSystemPkg

  # # Install packages to /usr/local/.
  git submodule init
  git submodule update
  InstallThirdPartyPkg
  InstallEmacs
  InstallGo
  InstallNodeJs
  InstallMongoDB

  # # Setup environment and clean up.
  SetupEnvironment
  CleanUp
}


function InstallSystemPkg() {
  # Install and/or update homebrew
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo "Updating homebrew..."
  brew update

  # Basic packages
  echo "Installing packages..."
  sudo brew install wget tree w3m pkg-config automake autoconf mercurial ghostscript

  # Resolve any conflict
  sudo brew link --overwrite node
}


function InstallThirdPartyPkg() {
  # Newer version of python, also install pip. But unless necessary, prefer
  # using default python.
  #   sudo brew install python
  sudo easy_install pip
  sudo pip install ipython --upgrade
  sudo pip install pylint --upgrade
  sudo pip install virtualenv --upgrade
  sudo pip install jedi --upgrade # For emacs jedi plugin
  sudo pip install epc --upgrade  # For emacs jedi plugin
}


function InstallEmacs() {
  if [[ ! -e ${EMACS_PACKAGE} ]]; then
    wget ${EMACS_URL}
  fi
  tar -xvf ${EMACS_PACKAGE}
  cd ${EMACS_DIR}
  ./autogen.sh
  ./configure --with-ns
  make
  sudo make install
  yes | cp -r nextstep/Emacs.app /Applications

  rm -rf ${EMACS_PACKAGE}
  rm -rf ${EMACS_DIR}
}


function InstallGo() {
  if [[ ! -e $GO_PACKAGE ]]; then
    wget $GO_URL
  fi
  # Keep it simple, force delete.
  sudo rm -rf /usr/local/go
  # Install Go to /usr/local/go/.
  sudo tar -C /usr/local -xvf $GO_PACKAGE
  # Go tools
  export GOPATH=$HOME/code/source/go-workspace
  go get github.com/nsf/gocode
  go get github.com/tools/godep
  go get github.com/rogpeppe/godef
  go get golang.org/x/tools/cmd/goimports
  sudo ln -sf /usr/local/go/bin/go /usr/bin/go
}


function InstallNodeJs() {
  sudo brew install node
  npm config set tmp /tmp
  sudo npm install -g express grunt grunt-cli bower
}


function InstallMongoDB() {
  sudo brew install mongodb
  if [[ ! -d /data/db ]]; then
    sudo mkdir -p /data/db
  fi
}


function SetupEnvironment() {
  # Use zsh
  sudo chsh -s /usr/bin/zsh $USER
  # Intall important links
  rm -rf ~/.emacs.d ~/.zshrc	# Force delete first
  sudo ln -sf ~/.unixrc/.emacs.d ~/.emacs.d
  sudo ln -sf ~/.unixrc/.zshrc ~/.zshrc
  # Set up z
  if [[ ! -e ~/.z ]]; then
    touch ~/.z
  fi
  # Set up git
  git config --global user.email "deyuan.deng@gmail.com"
  git config --global user.name "Deyuan Deng"
  git config --global push.default simple
  # Clone code
  if [[ ! -d ~/code ]]; then
    cd ~
    git clone https://github.com/ddysher/code.git
    cd -
  fi
}


function CleanUp() {
  sudo rm -rf $GO_PACKAGE
}

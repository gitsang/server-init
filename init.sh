#!/bin/bash

basic() {
    apt update
    apt upgrade -y
    apt install -y zip unzip wget curl
    apt install -y sysstat iotop iftop
    apt autoremove -y
}

install_node() {
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    apt install -y nodejs
    apt autoremove -y
}

install_git() {
    apt install -y git
    apt autoremove -y
    cp .gitconfig ~
    npm install -g git-split-diffs
}

install_vim() {
    apt install -y vim neovim python3-neovim
    apt autoremove -y
    mkdir -p ~/.config/nvim/
    cp init.vim ~/.config/nvim/
    cp coc-settings.json ~/.config/nvim/
}

install_zsh() {
    apt install -y zsh
    apt autoremove -y
    if [ ! -d "~/.zsh/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
    fi
    if [ ! -d "~/.zsh/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/plugins/zsh-syntax-highlighting
    fi
    cp .shrc ~
    cp .zshrc ~
    cp .bashrc ~
    cp .bash_aliases ~
    chsh -s $(which zsh)
}

install_fzf() {
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}

install_docker() {
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    mkdir -p ~/.zsh/completion
    curl \
        -L https://raw.githubusercontent.com/docker/compose/v2.5.0/contrib/completion/zsh/_docker-compose \
        -o ~/.zsh/completion/_docker-compose
    apt autoremove -y
}

install_go() {
    GO_VERSION=1.18.2
    TGZ_FILE=go${GO_VERSION}.linux-amd64.tar.gz
    wget https://go.dev/dl/${TGZ_FILE}
    tar -C /usr/local -xzvf ${TGZ_FILE}
    rm -fr ${TGZ_FILE}
}

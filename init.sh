#!/bin/bash

basic() {
    apt update
    apt upgrade -y
    apt install -y zip unzip wget curl
    apt install -y sysstat iotop iftop
    apt install -y ca-certificates gnupg lsb-release
    apt autoremove -y
}

install_node() {
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    apt install -y nodejs
    apt autoremove -y
}

install_git() {
    CONFIG_PATH=./git

    # install
    apt install -y git
    apt autoremove -y

    # configure
    cp ${CONFIG_PATH}/.gitconfig ~
    npm install -g git-split-diffs
}

install_nvim() {
    VERSION=v0.8.0
    CONFIG_PATH=./nvim

    # download and install
    wget -c https://github.com/neovim/neovim/releases/download/${VERSION}/nvim.appimage
    chmod u+x nvim.appimage
    mv nvim.appimage /usr/local/bin/nvim

    # confignure
    mkdir -p ~/.config/nvim/
    cp ${CONFIG_PATH}/init.vim ~/.config/nvim/
    cp ${CONFIG_PATH}/coc-settings.json ~/.config/nvim/

    # start
    /usr/local/bin/nvim
}

install_zsh() {
    CONFIG_PATH=./shell

    # install
    apt install -y zsh
    apt autoremove -y
    if [ ! -d "~/.zsh/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
    fi
    if [ ! -d "~/.zsh/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/plugins/zsh-syntax-highlighting
    fi

    # configure
    cp ${CONFIG_PATH}/.shrc ~
    cp ${CONFIG_PATH}/.zshrc ~
    cp ${CONFIG_PATH}/.bashrc ~
    cp ${CONFIG_PATH}/.bash_aliases ~
    chsh -s $(which zsh)
}

install_fzf() {
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}

install_docker() {
    # install
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh

    # configure
    mkdir -p ~/.zsh/completion
    curl \
        -L https://raw.githubusercontent.com/docker/compose/v2.5.0/contrib/completion/zsh/_docker-compose \
        -o ~/.zsh/completion/_docker-compose
}

install_docker-compose() {
    # Add Docker’s official GPG key
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # set up repository
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update

    # install
    apt install docker-compose-plugin
}

show_help() {
    # usage
    echo "Usage: ${0} Option"

    # options
    echo ""
    echo "Option:"
    grep -E '\s+[a-zA-Z_-]+\).*##' $0 | \
        sed -r 's/\s+([a-zA-Z_-]+)\).*## (.*)/\1|\2/g' | \
        awk -F '|' '{printf "\t\033[36m%-20s\033[0m %s\n", $1, $2}'

    # config
    echo ""
    echo "Config:"
    grep -E '^([0-9a-zA-Z_-]+)=\$\{\1:-.*\}' $0 | \
        sed -r 's/^([0-9a-zA-Z_-]+)=\$\{\1:-\"?([^\"]*)\"?\}/\1|\2/g' | \
        awk -F '|' '{printf "\t\033[33m%-16s\033[0m(default: %s)\n", $1, $2}'
}

case $1 in
    basic) ## install basic
        basic
        ;;
    node) ## install node
        install_node
        ;;
    git) ## install git
        install_git
        ;;
    nvim) ## install nvim using appimage
        install_nvim
        ;;
    zsh) ## install zsh
        install_zsh
        ;;
    fzf) ## install fzf
        install_fzf
        ;;
    docker) ## install docker
        install_docker
        ;;
    docker-compose) ## install docker-compose
        install_docker-compose
        ;;
    *)
        show_help
        ;;
esac

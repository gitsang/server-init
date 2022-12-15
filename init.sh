#!/bin/bash

# set -o errexit
# set -o nounset
# set -o pipefail
# set -x

OS=$(cat /etc/os-release  | grep '^ID=' | sed 's/^ID="\(.*\)"/\1/')

# ========================= basic ========================= #

install_basic_centos() {
    yum update -y
    yum install -y zip unzip wget curl
    yum install -y sysstat iotop iftop
    yum install -y python python3 python-devel python3-devel
    yum autoremove -y
}

install_basic_ubuntu() {
    apt update
    apt upgrade -y
    apt install -y zip unzip wget curl
    apt install -y sysstat iotop iftop
    apt install -y python python3 python-dev python3-dev
    apt install -y ca-certificates gnupg lsb-release
    apt autoremove -y
}

install_basic() {
    if [[ $OS -eq "centos" ]]; then
        install_basic_centos
    elif [[ $OS -eq "ubuntu" ]]; then
        install_basic_ubuntu
    fi
}

# ========================= node ========================= #

install_node_centos() {
    #curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo -E bash -
    sudo yum install -y nodejs npm
    sudo yum install -y gcc-c++ make
    sudo yum autoremove -y
    node --version
    npm --version
}

install_yarn_centos() {
    curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
    sudo yum install -y yarn
    yarn --version
}

install_node_ubuntu() {
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    apt -y install nodejs
    apt -y autoremove
}

install_node() {
    if [[ $OS -eq "centos" ]]; then
        install_node_centos
        install_yarn_centos
    elif [[ $OS -eq "ubuntu" ]]; then
        install_node_ubuntu
    fi
}

# ========================= git ========================= #

install_git_centos() {
    yum -y install https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64.rpm
    yum install -y git
    yum autoremove -y
}

install_git_ubuntu() {
    apt install -y git
    apt autoremove -y
}

install_git() {
    CONFIG_PATH=./git
    if [[ $OS -eq "centos" ]]; then
        install_git_centos
    elif [[ $OS -eq "ubuntu" ]]; then
        install_git_ubuntu
    fi

    # configure
    cp ${CONFIG_PATH}/.gitconfig ~
    npm install -g git-split-diffs
}

# ========================= nvim ========================= #

install_nvim() {
    CONFIG_PATH=./nvim

    # download and install
    if [ ! -f /usr/bin/nvim ]; then
        if [ ! -f nvim.appimage ]; then
            curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        fi
        chmod u+x nvim.appimage
        if [ ! -f /squashfs-root ]; then
            if [ ! -f ./squashfs-root ]; then
                ./nvim.appimage --appimage-extract
            fi
            ./squashfs-root/AppRun --version
            mv squashfs-root /
        fi
        ln -s /squashfs-root/AppRun /usr/bin/nvim
    fi

    # confignure
    if [ ! -f ~/.config/nvim ]; then
        mkdir -p ~/.config/nvim/
        cp ${CONFIG_PATH}/init.vim ~/.config/nvim/
        cp ${CONFIG_PATH}/coc-settings.json ~/.config/nvim/
    fi

    # python support
    if [[ $OS -eq "centos" ]]; then
        # yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
        # yum install -y python36-neovim
        echo skip
    elif [[ $OS -eq "ubuntu" ]]; then
        # apt install python3-neovim
        echo skip
    fi
}

# ========================= zsh ========================= #

install_zsh() {
    CONFIG_PATH=./shell

    # install
    if [[ $OS -eq "centos" ]]; then
        yum install -y zsh
        yum autoremove -y
    elif [[ $OS -eq "ubuntu" ]]; then
        apt install -y zsh
        apt autoremove -y
    fi
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

# ========================= fzf ========================= #

install_fzf() {
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}

# ========================= docker ========================= #

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

# ========================= help ========================= #

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
        install_basic
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
    *)
        show_help
        ;;
esac

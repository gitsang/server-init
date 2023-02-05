#!/bin/bash

# set -o errexit
# set -o nounset
# set -o pipefail
# set -x

OS=$(cat /etc/os-release | grep '^ID=' | sed 's/^ID=//')

# ========================= basic ========================= #

install_basic() {
    if [[ $OS == "centos" ]]; then
        sudo yum update -y
        sudo yum install -y \
            zip unzip wget curl \
            sysstat iotop iftop \
            make cmake cmake3
        sudo yum install -y python python3 python-devel python3-devel
        sudo yum autoremove -y
    elif [[ $OS == "ubuntu" || $OS == "debian" ]]; then
        sudo apt update
        sudo apt upgrade -y
        sudo apt install -y ca-certificates gnupg lsb-release
        sudo apt install -y \
            zip unzip wget curl \
            sysstat iotop iftop \
            make cmake cmake3
        sudo apt install -y python python3 python-dev python3-dev
        sudo apt autoremove -y
    fi
}

# ========================= node ========================= #

install_node() {
    # 1. install node from package
    if [[ $OS == "centos" ]]; then
        # node
        curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo -E bash -
        sudo yum install -y nodejs npm
    elif [[ $OS == "ubuntu" || $OS == "debian" ]]; then
        # node
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt install -y nodejs
    fi

    # 2. install yarn through npm
    npm install --global yarn
}

# ========================= git ========================= #

install_git() {
    # 1. install from package
    if [[ $OS == "centos" ]]; then
        sudo yum -y install https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64.rpm
        sudo yum install -y git
        sudo yum autoremove -y
    elif [[ $OS == "ubuntu" || $OS == "debian" ]]; then
        sudo apt install -y git
        sudo apt autoremove -y
    fi

    # 2. install plugin
    npm install -g git-split-diffs

    # 3. configure
    CONFIG_PATH=./git
    cp ${CONFIG_PATH}/.gitconfig ~
}

# ========================= nvim ========================= #

install_nvim() {
    # 1. install prerequisites
    if [[ $OS == "centos" ]]; then
        sudo yum install -y \
            ninja-build libtool \
            autoconf automake cmake gcc gcc-c++ make \
            pkgconfig unzip patch gettext curl
    elif [[ $OS == "ubuntu" || $OS == "debian" ]]; then
        sudo apt install -y \
            ninja-build gettext libtool libtool-bin \
            autoconf automake cmake g++ \
            pkg-config unzip curl doxygen
    fi

    # 2. clone source
    git clone https://github.com/neovim/neovim /usr/local/src/neovim
    cd /usr/local/src/neovim

    # 3. build
    git checkout stable
    make CMAKE_BUILD_TYPE=RelWithDebInfo

    # 4. install
    sudo make install

    # 5. change dir back
    cd -

    # 6. confignure
    CONFIG_PATH=./nvim
    if [ ! -d ~/.config/nvim ]; then
        mkdir -p ~/.config/nvim/
        cp ${CONFIG_PATH}/init.vim ~/.config/nvim/
        cp ${CONFIG_PATH}/coc-settings.json ~/.config/nvim/
    fi
}

# ========================= zsh ========================= #

install_zsh() {
    # 1. install from package
    if [[ $OS == "centos" ]]; then
        sudo yum install -y zsh
        sudo yum autoremove -y
    elif [[ $OS == "ubuntu" || $OS == "debian" ]]; then
        sudo apt install -y zsh
        sudo apt autoremove -y
    fi

    # 2. install plugin
    if [ ! -d ~/.zsh/plugins/zsh-autosuggestions ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions \
            ~/.zsh/plugins/zsh-autosuggestions
    fi
    if [ ! -d ~/.zsh/plugins/zsh-syntax-highlighting ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
            ~/.zsh/plugins/zsh-syntax-highlighting
    fi

    # 3. install completion
    mkdir -p ~/.zsh/completion
    if [ ! -f ~/.zsh/completion/_docker ]; then
        curl -fLo ~/.zsh/completion/_docker \
            https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
    fi
    if [ ! -f ~/.zsh/completion/_docker-machine ]; then
        curl -fLo ~/.zsh/completion/_docker-machine \
            https://raw.githubusercontent.com/docker/machine/v0.14.0/contrib/completion/zsh/_docker-machine
    fi
    if [ ! -f ~/.zsh/completion/_docker-compose ]; then
        curl -fLo ~/.zsh/completion/_docker-compose
            https://raw.githubusercontent.com/docker/compose/v2.5.0/contrib/completion/zsh/_docker-compose
    fi

    # 4. configure
    CONFIG_PATH=./shell
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
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh -x get-docker.sh
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

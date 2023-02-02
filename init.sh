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
    if [[ $OS == "centos" ]]; then
        # node
        curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo -E bash -
        sudo yum install -y nodejs npm
        sudo yum install -y gcc-c++ make
        sudo yum autoremove -y
        # yarn
        curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
        sudo yum update
        sudo yum install -y yarn
    elif [[ $OS == "ubuntu" || $OS == "debian" ]]; then
        # node
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt install -y nodejs
        sudo apt install -y gcc g++ make
        sudo apt autoremove -y
        # yarn
        curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
        echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
        sudo apt update
        sudo apt -y install yarn
    fi
    node --version
    npm --version
    yarn --version
}

# ========================= git ========================= #

install_git() {
    if [[ $OS == "centos" ]]; then
        sudo yum -y install https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64.rpm
        sudo yum install -y git
        sudo yum autoremove -y
    elif [[ $OS == "ubuntu" ]]; then
        sudo apt install -y git
        sudo apt autoremove -y
    fi

    # configure
    CONFIG_PATH=./git
    cp ${CONFIG_PATH}/.gitconfig ~
    npm install -g git-split-diffs
}

# ========================= nvim ========================= #

install_nvim_centos() {
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
}

install_nvim_ubuntu() {
    apt install neovim python3-neovim
}

install_nvim() {
    # download and install
    if [[ $OS == "centos" ]]; then
        install_nvim_centos
    elif [[ $OS == "ubuntu" ]]; then
        install_nvim_ubuntu
    fi

    # confignure
    CONFIG_PATH=./nvim
    if [ ! -d ~/.config/nvim ]; then
        mkdir -p ~/.config/nvim/
        cp ${CONFIG_PATH}/init.vim ~/.config/nvim/
        cp ${CONFIG_PATH}/coc-settings.json ~/.config/nvim/
    fi
}

# ========================= zsh ========================= #

install_zsh() {
    # install
    if [[ $OS == "centos" ]]; then
        sudo yum install -y zsh
        sudo yum autoremove -y
    elif [[ $OS == "ubuntu" || $OS == "debian" ]]; then
        sudo apt install -y zsh
        sudo apt autoremove -y
    fi

    # plugin
    if [ ! -d ~/.zsh/plugins/zsh-autosuggestions ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions \
            ~/.zsh/plugins/zsh-autosuggestions
    fi
    if [ ! -d ~/.zsh/plugins/zsh-syntax-highlighting ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
            ~/.zsh/plugins/zsh-syntax-highlighting
    fi

    # completion
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

    # configure
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

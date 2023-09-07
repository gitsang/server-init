#!/bin/bash

set -o errexit
set -o pipefail
# set -o nounset
# set -x

OS=$(cat /etc/os-release | grep '^ID=' | sed 's/^ID="*\([a-z]*\)"*/\1/')

# ========================= basic ========================= #

install_prerequisite() {
    mkdir -p ~/.local/src
    if [[ $OS == "centos" ]]; then
        sudo wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
        sudo yum makecache
        sudo yum update -y

        sudo yum install -y epel-release
        sudo yum install -y git
        sudo yum install -y zip unzip wget curl
        sudo yum install -y sysstat iotop iftop
        sudo yum install -y python python3 python-devel python3-devel
        sudo yum install -y autoconf automake make cmake cmake3
        sudo yum install -y pkgconfig patch gettext
        sudo yum install -y gcc gcc-c++
        sudo yum install -y ninja-build libtool
        sudo yum install -y libuv libuv-devel
        sudo yum install -y libatomic
        sudo yum install -y zlib-devel
        sudo yum install -y xmlto
        sudo yum install -y asciidoctor
        sudo yum install -y asciidoc

        sudo yum groupinstall -y "Development Tools"
        sudo yum install -y centos-release-scl
        sudo yum-config-manager --enable rhel-server-rhscl-7-rpms
        sudo yum install -y devtoolset-8
        scl enable devtoolset-8 bash

        sudo yum autoremove -y
    elif [[ $OS == "ubuntu" || $OS == "debian" ]]; then
        sudo apt update
        sudo apt upgrade -y
        sudo apt install -y ca-certificates gnupg lsb-release
        sudo apt install -y git
        sudo apt install -y zip unzip wget curl
        sudo apt install -y sysstat iotop iftop
        sudo apt install -y python python3 python-dev python3-dev
        sudo apt install -y autoconf automake make cmake cmake3
        sudo apt install -y ninja-build gettext libtool libtool-bin
        sudo apt install -y g++
        sudo apt install -y pkg-config doxygen
        sudo apt install -y zlib1g-dev
        sudo apt install -y asciidoc
        sudo apt install -y xmlto
        sudo apt autoremove -y
    elif [[ $OS == "kali" ]]; then
        sudo apt update
        sudo apt upgrade -y
        sudo apt install -y ca-certificates gnupg lsb-release
        sudo apt install -y git
        sudo apt install -y zip unzip wget curl
        sudo apt install -y sysstat iotop iftop
        sudo apt install -y python2-minimal python2 python-is-python3 2to3
        sudo apt install -y autoconf automake make cmake cmake3
        sudo apt install -y ninja-build gettext libtool libtool-bin
        sudo apt install -y g++
        sudo apt install -y pkg-config doxygen
        sudo apt install -y zlib1g-dev
        sudo apt install -y asciidoc
        sudo apt install -y xmlto
        sudo apt autoremove -y
    fi
}

# ========================= node ========================= #

install_node() {
    # 1. install node from package
    if [[ $OS == "centos" ]]; then
        curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo -E bash -
        sudo yum install -y nodejs npm
    elif [[ $OS == "ubuntu" || $OS == "debian" || $OS == "kali" ]]; then
        # node
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt install -y nodejs
    fi

    # 2. install yarn through npm
    sudo npm install --global yarn
}

# ========================= git ========================= #

install_git_from_source() {
    # 1. install from source
    pushd ~/.local/src
        if [[ ! -f "v2.40.1.tar.gz" ]]; then
            wget https://github.com/git/git/archive/refs/tags/v2.40.1.tar.gz
        fi
        if [[ ! -d "git-2.40.1" ]]; then
            tar -zxf v2.40.1.tar.gz
        fi
        cd git-2.40.1
        make configure
        ./configure --prefix=/usr
        make all doc info
        sudo make install install-doc install-html install-info
    popd

    # 2. install plugin
    sudo npm install -g git-split-diffs

    # 3. configure
    CONFIG_PATH=./git
    cp ${CONFIG_PATH}/.gitconfig ~
}

# ========================= nvim ========================= #

install_nvim_from_source() {
    # install from source
    pushd ~/.local/src
        if [ ! -d neovim ]; then
            git clone https://github.com/neovim/neovim
        fi
        cd neovim

        git clean -xdf
        git checkout master
        git pull

        sudo make clean
        sudo make CMAKE_BUILD_TYPE=Release
        sudo make install
    popd

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
    # 1. install from package
    if [[ $OS == "centos" ]]; then
        sudo yum install -y zsh
        sudo yum autoremove -y
    elif [[ $OS == "ubuntu" || $OS == "debian" || $OS == "kali" ]]; then
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

    # 4. configure
    CONFIG_PATH=./shell
    cp ${CONFIG_PATH}/.shrc ~
    cp ${CONFIG_PATH}/.zshrc ~
    cp ${CONFIG_PATH}/.bashrc ~
    cp ${CONFIG_PATH}/.bash_aliases ~
    chsh -s $(which zsh)
}

# ========================= fzf ========================= #

install_fzf_from_source() {
    if [ ! -d ~/.fzf ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    fi
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
    prerequisite) ## install prerequisite
        install_prerequisite
        ;;
    node) ## install node
        install_node
        ;;
    git) ## install git from source
        install_git_from_source
        ;;
    nvim) ## install nvim from source
        install_nvim_from_source
        ;;
    zsh) ## install zsh
        install_zsh
        ;;
    fzf) ## install fzf from source
        install_fzf_from_source
        ;;
    docker) ## install docker
        install_docker
        ;;
    *)
        show_help
        ;;
esac

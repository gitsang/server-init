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
        sudo yum install -y docbook2X

        sudo yum groupinstall -y "Development Tools"
        sudo yum install -y centos-release-scl
        sudo yum-config-manager --enable rhel-server-rhscl-7-rpms
        sudo yum install -y devtoolset-8
        scl enable devtoolset-8 bash

        sudo yum autoremove -y
    elif [[ $OS == "ubuntu" || $OS == "debian" || $OS == "kali" ]]; then
        sudo apt update
        sudo apt upgrade -y

        sudo apt install -y ca-certificates gnupg lsb-release
        sudo apt install -y git
        sudo apt install -y zip unzip wget curl
        sudo apt install -y sysstat iotop iftop
        sudo apt install -y autoconf automake make cmake
        sudo apt install -y ninja-build gettext libtool libtool-bin
        sudo apt install -y g++
        sudo apt install -y pkg-config doxygen
        sudo apt install -y zlib1g-dev
        sudo apt install -y asciidoc
        sudo apt install -y xmlto

        sudo apt autoremove -y
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

install_fzf() {
    if [ ! -d ~/.fzf ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    fi
    ~/.fzf/install
}

# ========================= node ========================= #

install_node() {
    node_version=v18.18.2

    # 0. check version
    if command -v node >/dev/null 2>&1; then
        node_current_version=$(command node --version 2>/dev/null)
    fi
    if [[ ${node_current_version} == ${node_version} ]]; then
        exit
    fi

    # 1. install from pre-build
    node_prebuild_txz=node-${node_version}-linux-x64.tar.xz
    node_prebuild_url=https://nodejs.org/dist/${node_version}/${node_prebuild_txz}
    node_dist=/usr/local/lib
    node_folder=node-${node_version}-linux-x64
    pushd ~/.local/src
        # download
        rm -fr ${node_prebuild_txz}
        curl -C - -LO ${node_prebuild_url}
        # install
        sudo rm -fr ${node_dist}/${node_folder}
        sudo tar -C ${node_dist} -xvf ${node_prebuild_txz}
        # link
        sudo rm -fr ${node_dist}/nodejs
        sudo ln -s ${node_dist}/node-${node_version}-linux-x64 ${node_dist}/nodejs
    popd
}

install_yarn() {
    sudo npm install --global yarn
}

# ========================= git ========================= #

install_git() {
    # 1. install from source
    git_version=2.42.0
    git_source_tgz=v${git_version}.tar.gz
    git_source_dir=git-${git_version}
    git_source_url=https://github.com/git/git/archive/refs/tags/${git_source_tgz}
    pushd ~/.local/src
        # download
        if [[ ! -f "${git_source_tgz}" ]]; then
            curl -LO ${git_source_url}
        fi
        # build
        if [[ ! -d "${git_source_dir}" ]]; then
            tar -zxvf ${git_source_tgz}
        fi
        cd ${git_source_dir}
        make configure
        ./configure --prefix=/usr
        make all doc info
        # install
        sudo make install install-doc install-html install-info
    popd

    # 2. install plugin
    sudo npm install -g git-split-diffs

    # 3. configure
    git_config_path=./git
    cp ${git_config_path}/.gitconfig ~
}

# ========================= nvim ========================= #

install_nvim() {
    # install from source
    pushd ~/.local/src
        if [ ! -d neovim ]; then
            git clone https://github.com/neovim/neovim
        fi
        cd neovim

        git clean -xdf
        git checkout master
        git pull

        make clean
        make CMAKE_BUILD_TYPE=Release
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
    zsh) ## install zsh
        install_zsh
        ;;
    fzf) ## install fzf from source
        install_fzf
        ;;
    node) ## install node
        install_node
        ;;
    git) ## install git from source
        install_git
        ;;
    nvim) ## install nvim from source
        install_nvim
        ;;
    docker) ## install docker
        install_docker
        ;;
    *)
        show_help
        ;;
esac

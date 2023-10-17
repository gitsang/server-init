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
        sudo apt install -y libcurl4-openssl-dev libcurl4-gnutls-dev

        sudo apt autoremove -y
    fi
}

# ========================= zsh ========================= #

install_zsh() {
    # install from package management tool
    if [[ $OS == "centos" ]]; then
        sudo yum install -y zsh
        sudo yum autoremove -y
    elif [[ $OS == "ubuntu" || $OS == "debian" || $OS == "kali" ]]; then
        sudo apt install -y zsh
        sudo apt autoremove -y
    fi
}

configure_zsh() {
    # configure
    shell_config_path=./shell
    cp ${shell_config_path}/.shrc ~
    cp ${shell_config_path}/.zshrc ~
    cp ${shell_config_path}/.bashrc ~
    cp ${shell_config_path}/.bash_aliases ~
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

    # check version
    if command -v node >/dev/null 2>&1; then
        node_current_version=$(command node --version 2>/dev/null)
    fi
    if [[ ${node_current_version} == ${node_version} ]]; then
        exit
    fi

    # install from pre-build
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

configure_node() {
    keep_path=":/usr/local/lib/nodejs/bin"
    if ! sudo grep "secure_path" /etc/sudoers | grep -q "${keep_path}"; then
        sudo sed -i "s|secure_path=\"\([^\"].*\)\"|secure_path=\"\1${keep_path}\"|" /etc/sudoers
    fi
}

install_yarn() {
    sudo npm install --global yarn
}

# ========================= git ========================= #

install_git() {
    git_version=2.42.0

    # check version
    if command -v git >/dev/null 2>&1; then
        git_current_version=$(command git --version 2>/dev/null | awk '{print $3}')
    fi
    if [[ ${git_current_version} == ${git_version} ]]; then
        exit
    fi

    # install from source
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
        make clean
        make configure
        ./configure --prefix=/usr
        make -j$(grep -c '^processor' /proc/cpuinfo) all doc

        # install
        sudo make -j$(grep -c '^processor' /proc/cpuinfo) install install-doc install-html
    popd
}

configure_git() {
    # configure
    git_config_path=./git
    cp ${git_config_path}/.gitconfig ~

    # install plugin
    sudo npm install -g git-split-diffs
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
        make -j$(grep -c '^processor' /proc/cpuinfo) CMAKE_BUILD_TYPE=Release
        sudo make -j$(grep -c '^processor' /proc/cpuinfo) install
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

configure_docker() {
    sudo usermod -aG docker $(id -u -n)
    sudo chmod a+rw /var/run/docker.sock
    sudo systemctl restart docker
}

# ========================= help ========================= #

show_help() {
    # usage
    echo "Usage: ${0} Module [Option]"

    # module
    echo ""
    echo "Module:"
    grep -E '\s+\([a-zA-Z_-]+\).*##' $0 | \
        sed -r 's/\s+\(([a-zA-Z_-]+)\).*## (.*)/\1|\2/g' | \
        awk -F '|' '{printf "    \033[36m%-20s\033[0m %s\n", $1, $2}'

    # option
    echo ""
    echo "Option:"
    echo "    install    install module (default)"
    echo "    configure  configure module"

    # config
    echo ""
    echo "Config:"
    grep -E '^([0-9a-zA-Z_-]+)=\$\{\1:-.*\}' $0 | \
        sed -r 's/^([0-9a-zA-Z_-]+)=\$\{\1:-\"?([^\"]*)\"?\}/\1|\2/g' | \
        awk -F '|' '{printf "\t\033[33m%-16s\033[0m(default: %s)\n", $1, $2}'
}

case $1 in
    (prerequisite) ## install prerequisite
        case $2 in
            (install)
                install_prerequisite
                ;;
            (configure)
                ;;
            (*)
                install_prerequisite
                ;;
        esac
        ;;
    (zsh) ## install zsh
        case $2 in
            (install)
                install_zsh
                ;;
            (configure)
                configure_zsh
                ;;
            (*)
                install_zsh
                configure_zsh
                ;;
        esac
        ;;
    (fzf) ## install fzf
        case $2 in
            (install)
                install_fzf
                ;;
            (configure)
                ;;
            (*)
                install_fzf
                ;;
        esac
        ;;
    (node) ## install node
        case $2 in
            (install)
                install_node
                ;;
            (configure)
                configure_node
                ;;
            (*)
                install_node
                configure_node
                ;;
        esac
        ;;
    (yarn) ## install yarn
        case $2 in
            (install)
                install_yarn
                ;;
            (configure)
                ;;
            (*)
                install_yarn
                ;;
        esac
        ;;
    (git) ## install git
        case $2 in
            (install)
                install_git
                ;;
            (configure)
                configure_git
                ;;
            (*)
                install_git
                configure_git
                ;;
        esac
        ;;
    (nvim) ## install nvim
        case $2 in
            (install)
                install_nvim
                ;;
            (configure)
                ;;
            (*)
                install_nvim
                ;;
        esac
        ;;
    (docker) ## install docker
        case $2 in
            (install)
                install_docker
                ;;
            (configure)
                configure_docker
                ;;
            (*)
                install_docker
                configure_docker
                ;;
        esac
        ;;
    (*)
        show_help
        ;;
esac

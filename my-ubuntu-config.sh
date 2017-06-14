#!/bin/bash

dir=`pwd`

function rootness {
    if [[ $EUID -ne 0 ]]
    then
        echo "Error:This script must be run as root" 1>&2
        exit 1
    fi
}

function apt_conf {
    apt-get clean
    apt-get autoclean
    apt-get update
    apt-get -y upgrade
    apt-get -y dist-upgrade
}

function beautify_conf {
    # clean software
    apt-get remove unity-webapps-common
    apt-get remove thunderbird totem rhythmbox empathy brasero simple-scan
    apt-get remove gnome-mahjongg aisleriot gnome-mines cheese
    apt-get remove transmission-common gnome-orca webbrowser-app gnome-sudoku
    apt-get remove landscape-client-ui-install onboard deja-dup

    # install theme
    apt-get install unity-tweak-tool
    add-apt-repository ppa:noobslab/themes
    apt-get update
    apt-get install flatabulous-theme

    # install icon
    add-apt-repository ppa:numix/ppa
    apt-get update
    apt-get install numix-icon-theme-circle
}

function git_conf {
    apt-get -y install git

    git_filename = `find $dir -name "gitconfig"`
    if [ -z git_filename ]
    then
        wget https://github.com/m75n/my-ubuntu-config/blob/master/conf/gitconfig -P $dir/conf
    fi
    cp $dir/conf/gitconfig ~/.gitconfig
}

function vim_conf {
    apt-get -y install curl wget
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    vim_filename = `find $dir -name "vimrc"`
    if [ -z vim_filename ]
    then
        wget https://github.com/m75n/my-ubuntu-config/blob/master/conf/vimrc -P $dir/conf
    fi
    cp $dir/conf/vimrc ~/.vimrc
}

function tmux_conf {
    apt-get -y install tmux wget

    tmux_filename = `find $dir -name "tmux.conf"`
    if [ -z tmux_filename ]
    then
        wget https://github.com/m75n/my-ubuntu-config/blob/master/conf/tmux.conf -P $dir
    fi
    cp $dir/tmux.conf ~/.tmux.conf
}

# typewriting
function sogou_conf {
    apt-get -y install wget
    wget http://pinyin.sogou.com/linux/download.php?f=linux&bit=64 -P $dir
    sogou_filename = `find $dir -name "sogou*.deb"`
    dpkg -i sogou_filename
}

function zsh_conf {
    apt-get -y install zsh wget
    chsh -s /bin/zsh
    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
}

function docker_conf {
    apt-get -y install apt-transport-https ca-certificates curl
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
    apt-get update

    apt-get -y install docker-ce
}

# blog
function hexo_conf {
    apt-get install nodejs
    apt-get install npm

    npm install hexo-cli -g
}

# markdown editor
function typora_conf {
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA300B7755AFCFAE

    add-apt-repository 'deb https://typora.io ./linux/'
    apt-get update

    apt-get -y install typora
}

function leetcode_conf {
    apt-get install nodejs
    apt-get install npm

    npm install leetcode-cli -g
}

function print_info {
    cat << "EOF"
============================================================
                             _                 _         
 _ __ ___  _   _       _   _| |__  _   _ _ __ | |_ _   _ 
| '_ ` _ \| | | |_____| | | | '_ \| | | | '_ \| __| | | |
| | | | | | |_| |_____| |_| | |_) | |_| | | | | |_| |_| |
|_| |_| |_|\__, |      \__,_|_.__/ \__,_|_| |_|\__|\__,_|
           |___/                                         

Author  : m75n
Project : https://github.com/m75n/my-ubuntu-config.git
============================================================
EOF
}

function show_help {
    print_info

    cat << "EOF"

SYNOPSIS
    my-ubuntu-config.sh [OPTION]

DESCRIPTION
Default options are --apt --beautify --git --vim --tmux --sogou --zsh --typora

    --apt           apt update
    --beautify      clean system and install theme
    --git           install git
    --vim           install vim and vimrc
    --tmux          install tmux and tmux.conf
    --sogou         install sogoupinyin
    --zsh           install zsh and oh-my-zsh
    --docker        install docker
    --hexo          install hexo
    --typora        install typora (markdown editor)
    --leetcode      install leetcode-cli

    --help, -h
    -clean          clean download files
EOF
}

function clean {
    rm -r `ls $dir | grep -v "my-ubuntu-config.sh"`
}

rootness

if [ -z "$1" ]
then
    apt_conf
    beautify_conf
    git_conf
    vim_conf
    tmux_conf
    sogou_conf
    zsh_conf
    typora_conf

    echo "Please reboot the computer."
fi

while [ -n "$1" ]
do
    case "$1" in
        --apt) apt_conf ;;
        --beautify) beautify_conf ;;
        --git) git_conf ;;
        --vim) vim_conf ;;
        --tmux) tmux_conf ;;
        --sogou) tmux_conf ;;
        --zsh) zsh_conf ;;
        --docker) docker_conf ;;
        --hexo) hexo_conf ;;
        --typora) typora_conf ;;
        --leetcode) leetcode_conf ;;

        --help) show_help ;;
        -h) show_help ;;

        -clean) clean ;;

        --) shift
            break ;;
        *) echo "$1 is not a option" ;;
    esac
    shift
done

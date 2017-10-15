#!/bin/bash

dir=`pwd`

if [[ $EUID -ne 0 ]]
then
    echo "Error:This script must be run as root" 1>&2
    exit 1
fi

# Update
apt-get update
apt-get -y upgrade

# Install theme
apt-get -y install unity-tweak-tool
add-apt-repository -y ppa:noobslab/themes
apt-get update
apt-get -y install flatabulous-theme

# Install icon
add-apt-repository -y ppa:numix/ppa
apt-get update
apt-get -y install numix-icon-theme-circle

# Install wget curl
apt-get -y wget curl

# Install git
apt-get -y install git

# Install vim and plug
apt-get -y install vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install tmux
apt-get -y install tmux

# Install zsh and oh-my-zsh
apt-get -y install zsh
chsh -s /bin/zsh
wget \
https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh \
-O $dir/oh-my-zsh-install.sh
sed -i '/env\ zsh/d' $dir/oh-my-zsh-install.sh
chmod +x $dir/oh-my-zsh-install.sh
sh -c "$dir/oh-my-zsh-install.sh"
rm $dir/oh-my-zsh-install.sh

# Install typewriting (check fcitx before)
#bits=`uname --m`
#if [ "x86_64" = "$bits" ]
#then
#    wget 'http://pinyin.sogou.com/linux/download.php?f=linux&bit=64' -O \
#    $dir/conf/sogoupinyin.deb
#else
#    wget 'http://pinyin.sogou.com/linux/download.php?f=linux&bit=32' -O \
#    $dir/conf/sogoupinyin.deb
#fi
#dpkg -i conf/sogoupinyin.deb
#rm $dir/conf/sogoupinyin.deb

# Install docker
apt-get -y install apt-transport-https ca-certificates
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository -y \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
apt-get update
apt-get -y install docker-ce

# Install leetcode-cli
#apt-get -y install nodejs
#apt-get -y install npm
#npm install leetcode-cli -g

echo "\nPlease reboot the computer and chose theme and icon in unity-tweak-tool."

#!/usr/bin/env bash

REPO_DIR="$HOME/repos"
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    if command -v yum 1>/dev/null; then
        yum update && yum -y install zsh tmux python3
        git clone https://github.com/vim/vim.git $REPO_DIR
        cd $REPO_DIR/vim
        make -j8
        make install
        cp src/vim /usr/bin
    else
        apt update && apt install software-properties-common
        add-apt-repository ppa:jonathonf/vim
        apt update && apt install zsh vim python3 tmux
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"  # install brew
    brew install zsh wget vim tmux
else
    echo `Not supported OS $OSTYPE`
fi

## Oh my zsh
chsh -s $(command -v zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

## scd
cd $HOME
mkdir -p $REPO_DIR
git clone https://github.com/pavoljuhas/smart-change-directory.git $REPO_DIR
cp $REPO_DIR/smart-change-directory/bin/scd /usr/local/bin
chmod +x /usr/local/bin/scd
echo "source $REPO_DIR/smart-change-directory/shellrcfiles/zshrc_scd" >> $HOME/.zshrc

## Zsh autosuggestion
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sed -i -E "s/plugins=\(([~\)]+)\)/plugins=\(\1 zsh-autosuggestions\)" $HOME/.zshrc

## Ultimate vimrc
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

## Oh my tmux
cd
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .

## Git alias 
cd "$(dirname "$0")"
cp gitconfig $HOME/.gitconfig
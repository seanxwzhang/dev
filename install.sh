#!/usr/bin/env bash

REPO_DIR="$HOME/repos"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# if [ "$(id -u)" != "0" ]; then
#    echo "This script must be run as root" 1>&2
#    exit 1
# fi

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    if command -v yum 1>/dev/null; then
        sudo yum update && sudo yum -y install zsh tmux python3
        git clone https://github.com/vim/vim.git $REPO_DIR
        cd $REPO_DIR/vim
        make -j8
        sudo make install
        cp src/vim /usr/bin
    else
        sudo apt update && sudo apt install software-properties-common
        sudo add-apt-repository ppa:jonathonf/vim
        sudo apt update && sudo apt install zsh vim python3 tmux fzf
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
git clone https://github.com/pavoljuhas/smart-change-directory.git $REPO_DIR/smart-change-directory
sudo cp $REPO_DIR/smart-change-directory/bin/scd /usr/local/bin
sudo chmod +x /usr/local/bin/scd
echo "source $REPO_DIR/smart-change-directory/shellrcfiles/zshrc_scd" >> $HOME/.zshrc

## Zsh autosuggestion
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sed -i -E "s/plugins=\((.+)\)/plugins=\(\1 zsh-autosuggestions\)/g" $HOME/.zshrc

## Ultimate vimrc
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

## Oh my tmux
cd
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .

## fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

## Git alias
cd $DIR
cp ./gitalias.txt $HOME/gitalias.txt
cp ./gitconfig $HOME/.gitconfig
git config --global core.editor "vim"

## shell alias
echo "alias g=\"git\"" >> $HOME/.zshrc
echo "alias gs=\"git status\"" >> $HOME/.zshrc
echo "alias st=\"git status\"" >> $HOME/.zshrc
echo "alias pull=\"git pull\"" >> $HOME/.zshrc
echo "alias am=\"git ca\"" >> $HOME/.zshrc
echo "alias co=\"git checkout\"" >> $HOME/.zshrc
echo "alias gl=\"git lg\"" >> $HOME/.zshrc
echo "alias cm=\"git commit\"" >> $HOME/.zshrc
echo "alias push=\"git push -u origin HEAD\"" >> $HOME/.zshrc
echo "alias cc=\"git diff master..HEAD\"" >> $HOME/.zshrc
echo "alias cf=\"git diff master..HEAD --name-only\"" >> $HOME/.zshrc
echo "alias bd=\"git branch -D\"" >> $HOME/.zshrc
echo "alias cob=\"git checkout -b\"" >> $HOME/.zshrc

## git open and git recent
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
nvm install stable
npm install --global git-open
npm install --global git-recent

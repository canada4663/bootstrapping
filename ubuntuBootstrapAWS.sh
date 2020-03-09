DISTRO=$(lsb_release -i | cut -f 2-)
PIP=$(which pip)

#Enable EC2 Hibernation
sudo apt-get upgdate -y
sudo apt-get upgrade -y
#sudo apt dist-upgrade -y
sudo apt install ec2-hibinit-agent -y

#Core User Environment
cd $HOME
sudo apt-get install vim zsh git -y   ## yum ok
sudo apt-get install cmake -y ## yum ok
sudo apt-get install python3 -y
sudo apt-get install python3-pip -y
sudo apt-get install python3-virtualenv -y
sudo apt-get install python3-dev -y
sudo apt-get install python-pip -y ## yum OK
sudo apt-get install python-virtualenv -y ## yum = python27-virtualenv
sudo apt-get install python-dev -y ## yum = python27-devel
sudo apt-get install virtualenvwrapper -y ## sudo $PIP install virtualenvwrapper
sudo apt-get install awscli -y ## yum = aws-cli.noarch
sudo apt-get install powerline fonts-powerline -y ## sudo $PIP install powerline-status
sudo apt-get install golang -y
sudo apt-get install docker docker-compose -y
sudo groupadd docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

sudo update-alternatives --remove python /usr/bin/python2
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1



## Fonts: http://powerline.readthedocs.io/en/master/installation/linux.html ???
sudo apt-get install tmux -y ## yum OK
sudo pip install tmuxp ## yum OK
sudo pip install black ## yum OK
git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
## backup existing dotfiles to preserve
homeshick --batch clone https://github.com/canada4663/dotfiles.git ## auto-respond yes?
homeshick link --force
sudo chsh --shell $(which zsh) $USER
cd $HOME
git clone https://github.com/zsh-users/antigen.git
mkdir .antigen
mv antigen/* .antigen/
rm -Rf antigen
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cd $HOME/.vim/bundle
git clone https://github.com/Valloric/YouCompleteMe.git
cd YouCompleteMe
git submodule update --init --recursive
./install.py --all
vim +PluginInstall +qall    ## solarized / powerline fix (local powerline install)
cd $HOME
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cd $HOME

sudo reboot

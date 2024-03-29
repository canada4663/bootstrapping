
# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

#Presetup Tasks
touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
softwareupdate -i -a
rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress


#Install Homebrew
if ! command -v brew > /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  export PATH="/usr/local/bin:$PATH"
  printf "export PATH=\"/usr/local/bin:$PATH\"\n" >> $HOME/.bash_profile
fi

#Install Brewfile
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
curl -o $HOME/Brewfile https://raw.githubusercontent.com/canada4663/bootstrapping/master/Brewfile
brew bundle --file=$HOME/Brewfile
rm -f Brewfile
#sudo echo $(which zsh) >> /etc/shells
read "Homebrew and Brewfile Installed, Please Authenticate odrive so sync Can Begin - Press enter to continue"

#Set PATH to include homebrew binaries prior to full sourcing of .zshrc
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
export PATH=/usr/local/opt/python/libexec/bin:$PATH

#Post Brew Isntall for User Environment
gpip(){
       PIP_REQUIRE_VIRTUALENV="" pip "$@"
}
#sudo xcodebuild -license accept
gpip install powerline-status
gpip install psutil
gpip install virtualenvwrapper
gpip install tmuxp
cd $HOME
git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
homeshick --batch clone https://github.com/canada4663/dotfiles.git
homeshick link --force
chsh -s $(which zsh) 
#Not Needed for Brew installed antigen
# cd $HOME
# git clone https://github.com/zsh-users/antigen.git
# mkdir .antigen
# mv antigen/* .antigen/
# rm -Rf antigen
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
read "Environment Customizations Complete - Press enter ONLY when odrive has finished sync to continue"
mackup restore


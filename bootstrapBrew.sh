#Presetup Tasks
sudo softwareupdate -i -a
xcode-select --install

#Install Homebrew
if ! command -v brew > /dev/null; then
  ruby -e "$(curl --location --fail --silent --show-error https://raw.githubusercontent.com/Homebrew/install/master/install)"
  export PATH="/usr/local/bin:$PATH"
  printf "export PATH=\"/usr/local/bin:$PATH\"\n" >> $HOME/.bash_profile
fi

#Install Brewfile
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
brew bundle --file=$HOME/bootstrapping/Brewfile
sudo echo $(which zsh) >> /etc/shells

#Set PATH to include homebrew binaries prior to full sourcing of .zshrc
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
export PATH=/usr/local/opt/python/libexec/bin:$PATH

#Post Brew Isntall for User Environment
gpip(){
       PIP_REQUIRE_VIRTUALENV="" pip "$@"
}
sudo xcodebuild -license accept
gpip install powerline-status
gpip install virtualenvwrapper
cd $HOME
git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
homeshick --batch clone https://github.com/canada4663/dotfiles.git
homeshick link --force
chsh -s $(which zsh) 
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




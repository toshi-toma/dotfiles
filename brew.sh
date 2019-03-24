#!/bin/sh -xe

echo "installing homebrew..."
which brew >/dev/null 2>&1 || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "run brew doctor..."
which brew >/dev/null 2>&1 && brew doctor

echo "run brew update..."
which brew >/dev/null 2>&1 && brew update

echo "ok. run brew upgrade..."

brew upgrade

formulas=(
    git
    wget
    curl
    screen
    tree
    openssl
    colordiff
    vim
    zsh
    zsh-completions
    peco
    ghq
    tmux
    hub
    tig
    ricty
    diff-so-fancy
)

echo "start brew install apps..."
for formula in "${formulas[@]}"; do
    brew install $formula || brew upgrade $formula
done

brew tap caskroom/cask

casks=(
    dropbox
    evernote
    google-chrome
    firefox
    google-japanese-ime
    slack
    docker
    alfred
    notion
    iterm2
    visual-studio-code
    intellij-idea
    1password
    shiftit
    funter
    spark
)

echo "start brew cask install apps..."
for cask in "${casks[@]}"; do
    brew cask install $cask
done

brew cleanup
brew cask cleanup

cat << END

**************************************************
HOMEBREW INSTALLED! bye.
**************************************************

END
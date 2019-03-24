# dotfiles
Dotfiles.

```bash
$ git clone https://github.com/toshi-toma/dotfiles.git
$ cd dotfiles
$ chmod +x brew.sh
$ sh brew.sh
$ chmod +x install.sh
$ sh install.sh
$ chmod +x vscode.sh
$ sh vscode.sh
```

# iTerm2
## Native full screen windows
[iTerm2のおすすめ設定〜ターミナル作業を効率化する〜](https://qiita.com/ruwatana/items/8d9c174250061721ad11)  
を設定すると、どの画面上でもショートカットキー(option + Space)でフルスクリーン表示ができるようになる。

## font
[Ricty Diminished](http://www.rs.tus.ac.jp/yyusa/ricty_diminished.html)    
からダウンロード。
「font」はFamilyは「Ricty Diminished」を選択して、TypeFaceは「Bold」でSizeは「14」。

## Colors
[colorschemes](http://iterm2colorschemes.com/)からcolor schemeをダウンロードして  
Color Presetsは「Cobalt2」を指定。

## 日本語表記ゆれを防ぐ
「Profiles」→「Text」→「Treat ambiguous-width characters as double-width」にチェック

## Shell(zsh)
「General」→「Command」→「/bin/zsh」を指定。

# .gitconfig/.gitignore
[.gitignore](https://github.com/10shi10ma/dotfiles/blob/master/.gitignore) 
[.gitconfig](https://github.com/10shi10ma/dotfiles/blob/master/.gitconfig)  
gitの設定ファイル

# .zshrc
[.zshrc](https://github.com/10shi10ma/dotfiles/blob/master/.zshrc)  
zshの設定ファイル

# peco
[pecoのインストール](https://qiita.com/tmsanrinsha/items/72cebab6cd448704e366)

```
$ brew install peco
```
[.zshrc](https://github.com/10shi10ma/dotfiles/blob/master/.zshrc)

# .vimrc
TBD

# Mac App
[toshi-toma/mac-apps](https://github.com/toshi-toma/mac-apps/blob/master/README.md)

# VSCode
## Shell Command
1. Visual Studio Codeを起動
2. コマンドパレットを開く(cmd+shift+p)
3. "Shell Command: Install 'code' command in PATH"を選択

## Install extensions

```
cat .vscode/extensions.txt | xargs -n 1 code --install-extension
```

## Save extensions

```
code --list-extensions > .vscode/extensions.txt
```

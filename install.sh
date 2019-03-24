#!/bin/sh -xe

# 実行場所のディレクトリを取得
THIS_DIR=$(cd $(dirname $0); pwd)

cd $THIS_DIR

echo "\033[0;32mstart setup... \033[0;39m"

echo "setup symbolic link..."

# dotfileのシンボリックリンク作成
for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue
    ln -snfv ~/dotfiles/"$f" ~/
done

echo "finish"

source ~/.zshrc

echo "setup nodebrew and node"
if !(type "nodebrew" > /dev/null 2>&1); then
    curl -L git.io/nodebrew | perl - setup
    nodebrew install-binary stable
    nodebrew use stable
fi
echo "finish"

echo "\033[0;32mAll Finish!!! \033[0;39m"

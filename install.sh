#!/bin/sh -xe

# 実行場所のディレクトリを取得
THIS_DIR=$(cd $(dirname $0); pwd)

cd $THIS_DIR

echo "\033[0;32mstart setup... \033[0;39m"

# dotfileのシンボリックリンク作成
for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue
    ln -snfv ~/dotfiles/"$f" ~/
done

echo "\033[0;32mFinish!!! \033[0;39m"

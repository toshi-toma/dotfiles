#!/bin/sh -xe

SRC_DIR="${HOME}/dotfiles/.vscode/"
DEST_CODE_DIR="${HOME}/Library/Application Support/Code/User/"

echo "既存のファイルを削除"
rm "${DEST_CODE_DIR}keybindings.json"
rm "${DEST_CODE_DIR}settings.json"
echo "Done..."

echo "シンボリックリンク作成"
ln -s "${SRC_DIR}keybindings.json" "${DEST_CODE_DIR}keybindings.json"
ln -s "${SRC_DIR}settings.json" "${DEST_CODE_DIR}settings.json"
echo "Done..."

cat << END

**************************************************
Add Code PATH
1. Visual Studio Codeを起動
2. コマンドパレットを開く(cmd+shift+p)
3. "Shell Command: Install 'code' command in PATH"を選択

Install extensions

cat .vscode/extensions.txt | xargs -n 1 code --install-extension

**************************************************

END
# 環境変数
export LANG=ja_JP.UTF-8
export PATH="/bin:/usr/bin:/usr/local/bin:/Users/toshihisa/.homebrew/bin:$HOME/.nodebrew/current/bin:${PATH}"

# Node
export NODEBREW_ROOT=$HOME/.nodebrew

# 色を使用出来るようにする
autoload -Uz colors
colors

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# gitの情報を取得
autoload -Uz vcs_info
setopt PROMPT_SUBST
zstyle ':vcs_info:git:*' check-for-changes true #formats 設定項目で %c,%u が使用可
zstyle ':vcs_info:git:*' stagedstr "%F{green}!" #commit されていないファイルがある
zstyle ':vcs_info:git:*' unstagedstr "%F{magenta}+" #add されていないファイルがある
zstyle ':vcs_info:*' formats "%F{cyan}%c%u(%b)%f" #通常
zstyle ':vcs_info:*' actionformats '[%b|%a]' #rebase 途中,merge コンフリクト等 formats 外の表示
precmd () { vcs_info }

# プロンプト左
PROMPT="%{${fg[green]}%}[%n]%{${reset_color}%} %~
%{$fg[red]%} ➜  %{$reset_color%}"
# プロンプト右
RPROMPT='${vcs_info_msg_0_} %{${fg[red]}%}%}%b%{${reset_color}%}'

# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# 候補を表示する
setopt auto_list

# 標準エディタを設定する
export EDITOR=vim

# 補間
autoload -U compinit
compinit

# proxy

# peco
# コマンド履歴
function peco-select-history() {
    # historyを番号なし、逆順、最初から表示。
    # 順番を保持して重複を削除。
    # カーソルの左側の文字列をクエリにしてpecoを起動
    # \nを改行に変換
    BUFFER="$(history -nr 1 | awk '!a[$0]++' | peco --query "$LBUFFER" | sed 's/\\n/\n/')"
    CURSOR=$#BUFFER             # カーソルを文末に移動
    zle -R -c                   # refresh
}
zle -N peco-select-history
bindkey '^R' peco-select-history

# ディレクト移動
function find_cd() {
    cd "$(find . -type d | peco)"
}
alias fd="find_cd"

# ls
alias lsp='ls -l | peco'

# vim
alias vi='vim'


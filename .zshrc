#---------------------------------------------------------------------------
# General
#---------------------------------------------------------------------------

# 環境変数
export LANG=ja_JP.UTF-8
export PATH="/bin:/usr/bin:/usr/local/bin:/Users/toshihisa/.homebrew/bin:$HOME/.nodebrew/current/bin:${PATH}"

# Node
export NODEBREW_ROOT=$HOME/.nodebrew

# ビープ音を鳴らさないようにする
setopt no_beep

# 色を使用出来るようにする
autoload -Uz colors
colors

# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# '#' 以降をコメントとして扱う
setopt interactive_comments

# 標準エディタを設定する
export EDITOR=vim

# ls時のカラー表記
export LSCOLORS=gxfxcxdxbxegedabagacad
# ファイルリスト補完時、ディレクトリをシアン
zstyle ':completion:*' list-colors 'di=36;49'

# alias
source $HOME/.aliases

#---------------------------------------------------------------------------
# History
#---------------------------------------------------------------------------
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
## 同時に起動したzshの間でヒストリを共有する
setopt share_history
## 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

#---------------------------------------------------------------------------
# VCS
#---------------------------------------------------------------------------

# gitの情報を取得
autoload -Uz vcs_info
setopt PROMPT_SUBST
zstyle ':vcs_info:git:*' check-for-changes true #formats 設定項目で %c,%u が使用可
zstyle ':vcs_info:git:*' stagedstr "%F{green}!" #commit されていないファイルがある
zstyle ':vcs_info:git:*' unstagedstr "%F{magenta}+" #add されていないファイルがある
zstyle ':vcs_info:*' formats "%F{cyan}%c%u(%b)%f" #通常
zstyle ':vcs_info:*' actionformats '[%b|%a]' #rebase 途中,merge コンフリクト等 formats 外の表示
precmd () { vcs_info }

#---------------------------------------------------------------------------
# PROMPT
#---------------------------------------------------------------------------

# プロンプト左
PROMPT="%{${fg[green]}%}[%n]%{${reset_color}%} %~
%{$fg[red]%} ➜  %{$reset_color%}"
# プロンプト右
RPROMPT='${vcs_info_msg_0_} %{${fg[red]}%}%}%b%{${reset_color}%}'

#---------------------------------------------------------------------------
# Complement
#---------------------------------------------------------------------------

# zsh-completions
fpath=(/path/to/homebrew/share/zsh-completions $fpath)
# 補完機能を有効にする
autoload -Uz compinit
compinit
## 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## 自動修正
setopt correct
setopt correct_all
## 補完時にヒストリを自動的に展開する
setopt hist_expand
## 補完候補一覧でファイルの種別を識別マーク表示
setopt list_types
## 候補を表示する
setopt auto_list
## 補完キー（Tab, Ctrl+I) を連打するだけで順に補完候補を自動で補完
setopt auto_menu
## ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash


#---------------------------------------------------------------------------
# cd
#---------------------------------------------------------------------------

## cdのタイミングで自動的にpushd
setopt auto_pushd
setopt pushd_ignore_dups
## ディレクトリ名だけでcdする
setopt auto_cd

# proxy


#---------------------------------------------------------------------------
# Function
#---------------------------------------------------------------------------

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

# cd後、自動的にls
function chpwd() { ls }

function get_target_repo() {
  if [ $# -eq 1 ]; then
    echo $1
  else
    echo $(repos)
  fi
}

function coderepo() {
  open -a Visual\ Studio\ Code $(get_target_repo $1)
}
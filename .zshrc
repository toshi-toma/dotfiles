#---------------------------------------------------------------------------
# General
#---------------------------------------------------------------------------

# 環境変数
export LANG=ja_JP.UTF-8
export PATH="/bin:/usr/bin:/usr/local/bin:/Users/toshihisa/.homebrew/bin:$HOME/.nodebrew/current/bin:${PATH}"

# Node
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

# Go
export GOPATH=$HOME/go
export PATH=/usr/local/go/bin:$GOPATH/bin:$PATH

# fzf
export FZF_DEFAULT_OPTS='--height 40% --reverse --color fg:-1,bg:-1,hl:230,fg+:3,bg+:233,hl+:229 --color info:150,prompt:110,spinner:150,pointer:167,marker:174'

# Hyper

# Override auto-title when static titles are desired ($ title My new title)
title() { export TITLE_OVERRIDDEN=1; echo -en "\e]0;$*\a"}
# Turn off static titles ($ autotitle)
autotitle() { export TITLE_OVERRIDDEN=0 }; autotitle
# Condition checking if title is overridden
overridden() { [[ $TITLE_OVERRIDDEN == 1 ]]; }
# Echo asterisk if git state is dirty
gitDirty() { [[ $(git status 2> /dev/null | grep -o '\w\+' | tail -n1) != ("clean"|"") ]] && echo "*" }

# Show cwd when shell prompts for input.
precmd() {
   if overridden; then return; fi
   cwd=${$(pwd)##*/} # Extract current working dir only
   print -Pn "\e]0;$cwd$(gitDirty)\a" # Replace with $pwd to show full path
}

# Prepend command (w/o arguments) to cwd while waiting for command to complete.
preexec() {
   if overridden; then return; fi
   printf "\033]0;%s\a" "${1%% *} | $cwd$(gitDirty)" # Omit construct from $1 to show args
}

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

# binding
bindkey -v

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
## npmのコマンド中ではcorrectしない
alias npm='nocorrect npm'

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
function fzf-select-history() {
    # historyを番号なし、逆順、最初から表示。
    # 順番を保持して重複を削除。
    # カーソルの左側の文字列をクエリにしてfzfを起動
    # \nを改行に変換
    BUFFER="$(history -nr 1 | awk '!a[$0]++' | fzf --query "$LBUFFER" | sed 's/\\n/\n/')"
    CURSOR=$#BUFFER             # カーソルを文末に移動
    zle -R -c                   # refresh
}
zle -N fzf-select-history
bindkey '^R' fzf-select-history

# cd後、自動的にls
function chpwd() { ls }

# ghqのリポジトリからVSCodeを起動
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

# git repoのルートに移動
cdgit () {
    git rev-parse --is-inside-work-tree > /dev/null
    if [ $? = 0 ];
    then
        cd `git rev-parse --show-toplevel`
    fi
}

# git branch checkout
gch() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship

###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -n : -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${words[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
    if type __ltrim_colon_completions &>/dev/null; then
      __ltrim_colon_completions "${words[cword]}"
    fi
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###

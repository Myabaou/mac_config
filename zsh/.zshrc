# Git
 
fpath=(~/.zsh $fpath)
 
if [ -f ${HOME}/.zsh/git-completion.zsh ]; then
        zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.zsh
fi
 
if [ -f ${HOME}/.zsh/git-prompt.sh ]; then
        source ${HOME}/.zsh/git-prompt.sh
fi
 
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto

# Git関連(pull-request)
#eval "$(hub alias -s)"

function aws_prof {
  local profile="${AWS_PROFILE:=default}"
  #profile="${AWS_PROFILE}"
  echo "%{$fg_bold[blue]%}:(%{$fg[yellow]%}${profile}%{$fg_bold[blue]%})%{$reset_color%}"
  #echo "%{$fg_bold[blue]%}:(%{$fg[yellow]%}${profile}%{$fg_bold[blue]%})"
 }



#色付け
autoload -Uz colors
colors

#プロンプト
#PROMPT="%{$fg[red]%}%{$fg[white]%}:%{$fg[green]%}%n%{$fg[white]%}:%{$fg[blue]%}%~%{$fg[white]%}$%{$reset_color%} "

autoload -U compinit
compinit

export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

alias ls="ls -GF"
alias gls="gls --color"
#alias awsp="source _awsp"
function awsp() {
  if [ $# -ge 1 ]; then
    export AWS_PROFILE="$1"
    echo "Set AWS_PROFILE=$AWS_PROFILE."
  else
    source _awsp
  fi
  export AWS_DEFAULT_PROFILE=$AWS_PROFILE
}

#setopt PROMPT_SUBST ; PS1='[%n@%m %c$(__git_ps1 " (%s)")]\$ '
setopt PROMPT_SUBST
#export PROMPT="[${USER} %1~\$(__git_ps1)]%(!.#.$) "
#export PROMPT="%10F%B%r@%1~%b%f:\$(__git_ps1)]%(!.#.$) 
# カレントディレクトリバージョン
#export PROMPT='%B%*%b$(aws_prof)%10F%B%r%1~%b%f:$(__git_ps1)  
#export PROMPT='%B%*%b$(aws_prof)%10F%B%r%~%b%f:%F{red}$(__git_ps1 "%s")%f 
export PROMPT='%B%*%b$(aws_prof)%10F%B%r%~%b%f:%F{red}$(__git_ps1 "%s")%f 
〉'


############### ターミナルのコマンド受付状態の表示変更
# \u ユーザ名
# \h ホスト名
# \W カレントディレクトリ
# \w カレントディレクトリのパス
# \n 改行
# \d 日付
# \[ 表示させない文字列の開始
# \] 表示させない文字列の終了
# \$ $
#export PS1='\[\033[1;32m\]\u\[\033[00m\]:\[\033[1;34m\]\W\[\033[1;31m\]$(__git_ps1)\[\033[00m\] \$'
#PROMPT="%10F%B%n@[%*]%b%f:%12F%B%~%b%f%# "
##############

# Chrome
alias gchrome='open -a /Applications/Google\ Chrome.app'
# Vivaldi
alias vivaldi='open -a /Applications/Vivaldi.app'

# --------------------------------------
# Google search from terminal
# --------------------------------------
google(){
    if [ $(echo $1 | egrep "^-[cfs]$") ]; then
        local opt="$1"
        shift
    fi
    local url="https://www.google.co.jp/search?q=${*// /+}"
    local app="/Applications"
    local g="${app}/Google Chrome.app"
    local s="${app}/Safari.app"
    local v="${app}/Vivaldi.app"
    case ${opt} in
        "-g")   open "${url}" -a "$g";;
        "-s")   open "${url}" -a "$s";;
        "-v")   open "${url}" -a "$v";;
        *)      open "${url}";;
    esac
}

plugin_cache_dir="$HOME/.terraform.d/plugin-cache"
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"


# Python
#eval "$(pyenv init -)"


# Date
#alias fdate=$(date +%Y-%m-%d-%H%M%S | tr -d '\n' | pbcopy)


# EPARK-NEW-PROXY設定
#export HTTPS_PROXY=http://epark-sre:epark-sre@54.248.23.202:8080
autoload bashcompinit && bashcompinit
complete -C '/usr/local/bin/aws_completer' aws
export PATH=$PATH:$HOME/.nodebrew/current/bin


# Chage bitbucket Work Directory
alias cd_bitbucket='cd ~/w/bB'

# brew path
eval $(/opt/homebrew/bin/brew shellenv)

# zsh-syntax-highlighting
source ${HOME}//Work/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# 存在するパスのハイライト
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'

#Make terraform
alias stgmake='make _ENV=stg'



# peco settings
# 過去に実行したコマンドを選択。ctrl-rにバインド
function peco-select-history() {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# search a destination from cdr list
function peco-get-destination-from-cdr() {
  cdr -l | \
  sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  peco --query "$LBUFFER"
}


### 過去に移動したことのあるディレクトリを選択。ctrl-uにバインド
function peco-cdr() {
  local destination="$(peco-get-destination-from-cdr)"
  if [ -n "$destination" ]; then
    BUFFER="cd $destination"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N peco-cdr
bindkey '^u' peco-cdr


# ブランチを簡単切り替え。git checkout lbで実行できる
alias -g lb='`git branch | peco --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g"`'


# dockerコンテナに入る。deで実行できる
alias de='docker exec -it $(docker ps | peco | cut -d " " -f 1) /bin/bash'

# IPアドレス
alias ipinfo='curl inet-ip.info'
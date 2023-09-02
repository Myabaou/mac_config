# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
#export PROMPT='%B%*%b$(aws_prof)%10F%B%r%~%b%f: %F{red}$(__git_ps1 "%s")%f 


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
source ${HOME}/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
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


# あまりいけてない設定
#source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


###############
# git ブランチ名を色付きで表示させるメソッド
function rprompt-git-current-branch {
  local branch_name st branch_status

  branch='\ue0a0'
  color='%{\e[38;5;' #  文字色を設定
  green='114m%}'
  red='001m%}'
  yellow='227m%}'
  blue='033m%}'
  purple='125m%}'  # 追加: プッシュされていないブランチ用の色
  orange='208m%}'  # 差分があるブランチ用の色
  reset='%{\e[0m%}'   # reset

  color='%{\e[38;5;' #  文字色を設定
  green='114m%}'

  # ブランチマーク
#  if [ ! -e  ".git" ]; then
#    # git 管理されていないディレクトリは何も返さない
#    return
#  fi
    branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
    st=`git status 2> /dev/null`

# アップストリームが設定されているかをチェック
  local has_upstream=$(git for-each-ref --format '%(upstream:short)' $(git symbolic-ref -q HEAD) 2> /dev/null)

  # ローカルブランチがリモートにプッシュされていないかをチェック
  local is_unpushed=""
  if [[ -n "$has_upstream" ]]; then
    is_unpushed=$(git log @{u}.. 2> /dev/null)
  else
    is_unpushed="no_upstream"  # アップストリームがない場合はこの値を設定
  fi



    # ローカルとリモートの差分をチェック
    local has_diff=$(git diff @{u} 2> /dev/null)

  if [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    # git 管理されていないファイルがある状態
    branch_status="${color}${red}${branch}?"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    # git add されていないファイルがある状態
    branch_status="${color}${red}${branch}+"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    # git commit されていないファイルがある状態
    branch_status="${color}${yellow}${branch}!"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    # コンフリクトが起こった状態
    echo "${color}${red}${branch}!(no branch)${reset}"
    return

  elif [[ -n "$is_unpushed" ]]; then
    branch_status="${color}${purple}${branch}^"  # ^ はプッシュされていないことを示す
  elif [[ -n "$has_diff" ]]; then
    branch_status="${color}${orange}${branch}~"  # ~ は差分があることを示す
  elif [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    # 全て commit されてクリーンな状態
    branch_status="${color}${green}${branch}"
   else
    # 上記以外の状態の場合
    branch_status="${color}${blue}${branch}"
  fi

  # ブランチ名を色付きで表示する
  echo "${branch_status} $branch_name${reset}"
  #echo " ${branch_name} ${branch_status}${reset}"
}

function custom_git_stash_prompt() {
  local stash_count=$(git stash list 2> /dev/null | wc -l | tr -d ' ')  # 空白を削除
  local output=""

  if [[ $stash_count -gt 0 ]]; then
    output+="%{\e[34m%}(stash:$stash_count)%{\e[0m%}"  # 34は青色のANSIコードです
  fi

  echo "$output"
}




# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst




# プロンプトの右側にメソッドの結果を表示させる
#RPROMPT='`rprompt-git-current-branch`'
#export PROMPT='%B%*%b$(aws_prof)%10F%B%r%~%b%f: `rprompt-git-current-branch` 
#〉'



#export PROMPT='%B%*%b$(aws_prof)%10K{blue}%r%~%k:%F{red}$(__git_ps1 "(%s)")%f
#%F{green}〉%f'

#export PROMPT='%B%*%b$(aws_prof)%10K{blue}%r%~%k:`rprompt-git-current-branch`
#%F{green}〉%f'


export PROMPT='%B%*%b$(aws_prof)%10K{blue}%r%~%k:`rprompt-git-current-branch` $(custom_git_stash_prompt)
%F{green}〉%f'



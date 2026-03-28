# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"
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
  local profile="${AWS_PROFILE:=it-sandbox}"
  # Powerline style: yellow bg, black text, then arrow transition to next segment
  echo "%K{yellow}%F{blue}\ue0b0%f%F{black} ${profile} %f%k"
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

# AWS Profile を peco で切り替え (ctrl+p)
function peco-awsp() {
  local selected_profile=$(grep '^\[profile ' ~/.aws/config | sed 's/\[profile \(.*\)\]/\1/' | peco --prompt "AWS PROFILE>" --query "$LBUFFER")
  if [ -n "$selected_profile" ]; then
    export AWS_PROFILE="$selected_profile"
    export AWS_DEFAULT_PROFILE="$selected_profile"
    zle reset-prompt
    zle -M "Set AWS_PROFILE=$selected_profile"
  fi
}
zle -N peco-awsp
bindkey '^p' peco-awsp

# AWS OneLogin assume role with current or specified profile
# Usage: awsassume [profile-name]
# If no profile is specified, uses current AWS_PROFILE environment variable
# Password is stored in macOS Keychain
# Setup: security add-generic-password -s 'onelogin-aws' -a "$USER" -w
function awsassume() {
  local profile="${1:-${AWS_PROFILE}}"

  if [[ -z "$profile" ]]; then
    echo "Error: No AWS profile specified and AWS_PROFILE is not set."
    echo "Usage: awsassume [profile-name] or set AWS_PROFILE environment variable"
    return 1
  fi

  # Retrieve password from macOS Keychain
  local password=$(security find-generic-password -s "onelogin-aws" -w 2>/dev/null)

  if [[ -z "$password" ]]; then
    echo "Error: Password not found in keychain."
    echo "Please run: security add-generic-password -s 'onelogin-aws' -a '$USER' -w"
    return 1
  fi

  echo "Running OneLogin AWS assume role for profile: $profile"
  echo "$password" | docker run -i  -v ~/.aws:/root/.aws awsaccess:latest onelogin-aws-assume-role --profile "$profile"
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


autoload bashcompinit && bashcompinit
#complete -C '/usr/local/bin/aws_completer' aws
complete -C '/opt/homebrew/bin/aws_completer' aws
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

# ghq + peco でリポジトリ間を素早く移動
function peco-ghq() {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-ghq
bindkey '^g' peco-ghq

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

# Gitリポジトリかどうかを確認
  git rev-parse --is-inside-work-tree &> /dev/null || return

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

  local bg_color status_symbol

  if [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    bg_color="red"; status_symbol="+"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    bg_color="red"; status_symbol="+"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    bg_color="yellow"; status_symbol="!"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    echo "%K{red}%F{yellow}\ue0b0%f%F{black} ${branch}!(no branch) %f%k%F{red}\ue0b0%f"
    return
  elif [[ -n "$is_unpushed" ]]; then
    bg_color="magenta"; status_symbol="^"
  elif [[ -n "$has_diff" ]]; then
    bg_color="yellow"; status_symbol="~"
  elif [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    bg_color="green"; status_symbol=""
  else
    bg_color="blue"; status_symbol=""
  fi

  # Powerline style: bg color matches status, branch name + icon + status symbol at end
  # aws(黄)→git(状態色)の遷移: の前景=黄, 背景=状態色
  echo "%K{${bg_color}}%F{yellow}\ue0b0%f%F{black} ${branch_name} ${branch}${status_symbol} %f%k%F{${bg_color}}\ue0b0%f"
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


#export PROMPT='%B%*%b$(aws_prof)%10K{blue}%r%~%k:`rprompt-git-current-branch` $(custom_git_stash_prompt)
#%F{green}〉%f'

#export PROMPT='%S%B%*%b$(aws_prof)%10K{blue}%r%~%k:`rprompt-git-current-branch` $(custom_git_stash_prompt)%F{green} 
#〉%f'




#export PROMPT='%S%B%*%b %F{blue}%K{white}%r%~%k  %f%k$(aws_prof)`rprompt-git-current-branch` $(custom_git_stash_prompt)%F{green} 
#〉%f'

# Powerline-style prompt
# 時刻(黒) → ディレクトリ(青) → AWS(黄) → Git(状態色) →
export PROMPT='%K{black}%F{white} %* %f%k%F{black}%K{blue}'$'\ue0b0''%f%F{black} %~ %f%k%F{blue}$(aws_prof)`rprompt-git-current-branch` $(custom_git_stash_prompt)%{$reset_color%}
%F{green}〉%f'



alias docker=podman
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="/opt/homebrew/opt/asdf/bin:$PATH"
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# Backlog API (stored in macOS Keychain)
# Setup: security add-generic-password -s 'backlog-api' -a "$USER" -w
export BACKLOG_API_KEY="$(security find-generic-password -s 'backlog-api' -w 2>/dev/null)"


[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"

# タブ・ウィンドウタイトルにカレントディレクトリ(%~)を表示する設定
precmd() {
  print -Pn "\e]0;%~\a"
}

# infra/main.ts

alias samllogin='saml2aws login -a ${AWS_PROFILE} --skip-prompt'

# Copilot CLI: OpenAI API非互換のMCPサーバーを除外
alias copilot='copilot --disable-mcp-server aws-knowledge'

# Ghosttyターミナル開発レイアウト
# 使い方: tcode [ディレクトリ]
# 左上: yazi, 左下: keifu, 右: claude-code
tcode() {
    local target_dir="${1:-$(pwd)}"

    local cmd_yazi="cd ${target_dir} && yazi"
    local cmd_keifu="cd ${target_dir} && keifu"
    local cmd_claude="cd ${target_dir} && claude"

    osascript \
        -e 'on run argv' \
        -e '    set cmd_yazi to item 1 of argv' \
        -e '    set cmd_keifu to item 2 of argv' \
        -e '    set cmd_claude to item 3 of argv' \
        -e '    tell application "Ghostty" to activate' \
        -e '    tell application "System Events"' \
        -e '        tell process "Ghostty"' \
        -e '            keystroke "d" using command down' \
        -e '            delay 0.25' \
        -e '            key code 4 using {control down, option down}' \
        -e '            delay 0.1' \
        -e '            set the clipboard to cmd_yazi' \
        -e '            keystroke "v" using command down' \
        -e '            keystroke return' \
        -e '            delay 0.4' \
        -e '            keystroke "d" using {command down, shift down}' \
        -e '            delay 0.25' \
        -e '            set the clipboard to cmd_keifu' \
        -e '            keystroke "v" using command down' \
        -e '            keystroke return' \
        -e '            delay 0.15' \
        -e '            key code 37 using {control down, option down}' \
        -e '            delay 0.1' \
        -e '            set the clipboard to cmd_claude' \
        -e '            keystroke "v" using command down' \
        -e '            keystroke return' \
        -e '            delay 0.2' \
        -e '            -- 左ペインを狭くする' \
        -e '            key code 4 using {control down, option down}' \
        -e '            repeat 25 times' \
        -e '                key code 123 using {command down, control down}' \
        -e '            end repeat' \
        -e '            -- 左上を大きくする' \
        -e '            key code 40 using {control down, shift down}' \
        -e '            repeat 8 times' \
        -e '                key code 125 using {command down, control down}' \
        -e '            end repeat' \
        -e '            -- 右ペインに戻る' \
        -e '            key code 37 using {control down, option down}' \
        -e '        end tell' \
        -e '    end tell' \
        -e 'end run' \
        -- "${cmd_yazi}" "${cmd_keifu}" "${cmd_claude}"
}

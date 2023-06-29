#!/bin/zsh
#
# =============== aliases =============== #

source ~/.shrc
alias sss='source ~/.shrc'

# =============== history =============== #

export HISTFILE=~/.zsh_history
export HISTSIZE=10000000
export SAVEHIST=$HISTSIZE
export HISTFILESIZE=$HISTSIZE
export HISTTIMEFORMAT="[%F %T] "
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# =============== fzf =============== #

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# =============== Plugin =============== #

fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i

# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/plugins/zsh-syntax-highlighting
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# curl -fLo ~/.zsh/completion/_docker https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
# curl -fLo ~/.zsh/completion/_docker-machine https://raw.githubusercontent.com/docker/machine/v0.14.0/contrib/completion/zsh/_docker-machine

# =============== Prompt Option =============== #

# color
autoload -U colors && colors

# prompt
setopt prompt_subst
NEWLINE=$'\n'
PROMPT_HOSTNAME='%F{123}%n%F{220}@%M%f'
PROMPT_DATE='%F{111}⏱️ $(date "+%Y-%m-%d %H:%M:%S %Z")%f'
PROMPT_WORKDIR='%F{yellow}➤  %~ %f'
PROMPT_GITBRANCH='%F{cyan}$(git branch --show-current 2&> /dev/null | xargs -I branch echo " branch")%f'
PROMPT_CMDLINE='${NEWLINE} %# '
PROMPT="%B${NEWLINE}${PROMPT_HOSTNAME} ${PROMPT_DATE} ${PROMPT_WORKDIR} ${PROMPT_GITBRANCH} ${PROMPT_CMDLINE}%b"

PROMPT_ENV_ANSIBLE_DEPLOY_ENV='❰ANSIBLE_DEPLOY_ENV: ${ANSIBLE_DEPLOY_ENV}❱'
PROMPT_ENV_HTTPS_PROXY='❰HTTPS_PROXY: ${HTTPS_PROXY}❱'
PROMPT_ENV="%F{245} ${PROMPT_ENV_ANSIBLE_DEPLOY_ENV} ${PROMPT_ENV_HTTPS_PROXY} %f"
PROMPT_RET='[%{$fg_bold[yellow]%}%?%{$reset_color%}]'
RPROMPT="${PROMPT_ENV} ${PROMPT_RET}"

#DISABLE_AUTO_TITLE="true"
set-window-title() {
    #pwd_short=$(sed 's:\([^/]\)[^/]*/:\1/:g' <<< $PWD)
    #title="$(hostname -s):${pwd_short}"
    pwd_base=$(basename $PWD)
    title="${USER}@$(hostname -s) : ${pwd_base}"

    git rev-parse --show-toplevel > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        gitbase=$(basename $(git rev-parse --show-toplevel))
        title="${title} 『${gitbase}』"
    fi

    window_title="\e]0;${title}\a"
    echo -ne "$window_title"
}
set-window-title
add-zsh-hook precmd set-window-title

# =============== Extra =============== #

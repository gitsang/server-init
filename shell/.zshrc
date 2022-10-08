
source ~/.shrc
alias sss='source ~/.zshrc'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# =============== Plugin =============== #

# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/plugins/zsh-syntax-highlighting
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i

# =============== Prompt Option =============== #

# color
autoload -U colors && colors

# prompt
setopt prompt_subst
NEWLINE=$'\n'
PROMPT_HOSTNAME='%{$fg[green]%}%n%{$reset_color%}@%m'
PROMPT_PROXY='%B%{$fg[red]%}❰$(proxy --show)❱%{$reset_color%}%b'
PROMPT_DATE='$(date)'
PROMPT_GITBRANCH='%{$fg[blue]%}$(git branch --show-current 2&> /dev/null | xargs -I branch echo "(branch)")%{$reset_color%}'
PROMPT_WORKDIR='%{$fg[yellow]%}%~%{$reset_color%}'
PROMPT_CMDLINE='${NEWLINE} %# '
PROMPT="${NEWLINE}${PROMPT_HOSTNAME} ${PROMPT_PROXY} ${PROMPT_DATE} ${PROMPT_WORKDIR} ${PROMPT_GITBRANCH} ${PROMPT_CMDLINE}"
RPROMPT='[%{$fg_bold[yellow]%}%?%{$reset_color%}]'

#DISABLE_AUTO_TITLE="true"
set-window-title() {
    title="$(hostname -s):$(sed 's:\([^/]\)[^/]*/:\1/:g' <<< $PWD)"

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

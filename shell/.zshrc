#!/bin/zsh

# =============== aliases =============== #

source ~/.shrc
alias sss='source ~/.zshrc'

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

# =============== prompt option =============== #

# color
autoload -U colors && colors

# prompt
setopt prompt_subst
prompt_print() {
    prompt_triangle=$'\uE0B0'
    prompt_bg=${prompt_bg:-223}
    prompt_fg=${prompt_fg:-16}
    prompt_next_bg=${prompt_next_bg:-16}
    prompt_data=${prompt_data}
    echo -n "%K{${prompt_bg}}%F{${prompt_fg}} ${prompt_data} %f%k%K{${prompt_next_bg}}%F{${prompt_bg}}${prompt_triangle}%f%k"
}
prompt() {
    ret=$?
    prompt_configs=()
    if [[ $ret -ne 0 ]]; then
        prompt_configs+=("${ret}" "16" "%?")
    else
        prompt_configs+=("223" "16" "%?")
    fi
    prompt_configs+=("114" "16" "%n")
    prompt_configs+=("142" "16" "%M")
    prompt_configs+=("42"  "16" "$(date "+%Y-%m-%d")")
    prompt_configs+=("36"  "16" "$(date "+%H:%M:%S")")
    prompt_configs+=("29"  "16" "$(date "+%Z")")
    prompt_configs+=("223" "16" "%~")
    prompt_configs+=("38"  "16" "$(go version | cut -d " " -f 3)")
    prompt_configs+=("68"  "16" "$(git branch --show-current 2&> /dev/null | xargs -I branch echo " branch")")
    echo "%B"
    for (( i=1; i<${#prompt_configs[@]}; i+=3 )); do
        prompt_bg=${prompt_configs[i]}
        prompt_fg=${prompt_configs[i+1]}
        prompt_data=${prompt_configs[i+2]}
        if [ $i -eq $((${#prompt_configs[@]}-3)) ]; then
            prompt_next_bg=16
        else
            prompt_next_bg=${prompt_configs[i+3]}
        fi
        prompt_print
    done
    echo "%b"
    echo "%F{117} ➤  %f"
}
PROMPT='$(prompt)'

# =============== fzf =============== #

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# =============== plugin =============== #

if [[ ${plugin_loaded} != "true" ]]; then
    echo "loading plugin..."

    plugins=(docker docker-compose)
    fpath=(~/.zsh/completion $fpath)
    autoload -Uz compinit && compinit -i

    if [[ ! -d ~/.zsh/plugins/zsh-autosuggestions ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
    fi
    source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

    if [[ ! -d ~/.zsh/plugins/zsh-syntax-highlighting ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/plugins/zsh-syntax-highlighting
    fi
    source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    plugin_loaded="true"
fi

# =============== window title =============== #

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

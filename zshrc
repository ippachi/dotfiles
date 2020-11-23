# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZDOTDIR=$HOME/.zsh

[ -f $ZDOTDIR/zshrc_`uname` ] && source $ZDOTDIR/zshrc_`uname`

zplug romkatv/powerlevel10k, as:theme, depth:1
zplug zsh-users/zsh-autosuggestions
zplug zsh-users/zsh-syntax-highlighting
zplug load

# zsh history
export HISTFILE=~/.zsh_history
export SAVEHIST=1000000000
export HISTSIZE=1000000000

setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS

export EDITOR=vim

export PATH=$HOME/go/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# asdf
if [[ -f $HOME/.asdf/asdf.sh ]]; then
  export PATH=$HOME/.asdf/bin:$PATH
  source $HOME/.asdf/asdf.sh
fi

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export GOPATH="$HOME/go"

function ghq-fzf() {
  local src=$(ghq list | fzf --height 20 --reverse)
  if [ -n "$src" ]; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  fi
  zle -R -c
}
zle -N ghq-fzf
bindkey '^g' ghq-fzf

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

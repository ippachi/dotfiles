# p10k start config {{{
# eNABLE pOWERLEVEL10K INSTANT PROMPT. sHOULD STAY CLOSE TO THE TOP OF ~/.ZSHRC.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


bindkey -e
# local file setting {{{1
export ZDOTDIR=$HOME/.zsh
[ -f $ZDOTDIR/zshrc_`uname` ] && source $ZDOTDIR/zshrc_`uname`

# plugins {{{1
zplug romkatv/powerlevel10k, as:theme, depth:1
zplug zsh-users/zsh-autosuggestions
zplug zsh-users/zsh-syntax-highlighting
zplug olets/zsh-abbr
zplug zsh-users/zsh-completions
zplug load

# zsh history {{{1
export HISTFILE=~/.zsh_history
export SAVEHIST=1000000000
export HISTSIZE=1000000000

setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS

export EDITOR=vim

# asdf {{{1
if [[ -f $HOME/.asdf/asdf.sh ]]; then
  export PATH=$HOME/.asdf/bin:$PATH
  source $HOME/.asdf/asdf.sh
fi

# fzf {{{1
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ghq {{{1
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

# abbr {{{1
abbr --quiet be="bundle exec"
abbr --quiet mux="tmuxinator"
# p10k finish config {{{1
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


autoload -U compinit
compinit


LS_COLORS='no=00;37:fi=00:di=00;33:ln=04;36:pi=40;33:so=01;35:bd=40;33;01:'
export LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

alias ls="lsd"

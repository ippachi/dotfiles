bindkey -e

# local file setting {{{1
[ -f $HOME/.dotfiles/zsh/zshrc_`uname` ] && source $HOME/.dotfiles/zsh/zshrc_`uname`

# plugins {{{1
zplug zsh-users/zsh-autosuggestions
zplug zsh-users/zsh-syntax-highlighting
zplug olets/zsh-abbr
zplug zsh-users/zsh-completions
zplug load

# zsh history {{{1
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
abbr --quiet dc="sudo docker-compose"
abbr --quiet lg="lazygit"

eval "$(gh completion -s zsh)"

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

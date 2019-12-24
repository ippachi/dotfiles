# # Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

source /usr/share/zsh/scripts/zplug/init.zsh


export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"

export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export LANG=en_US.UTF-8

export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000

export FZF_DEFAULT_COMMAND='fd --type f'

setopt share_history
setopt hist_reduce_blanks
setopt hist_ignore_all_dups

zplug "zsh-users/zsh-syntax-highlighting"
zplug "chriskempson/base16-shell"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh
zplug "momo-lab/zsh-abbrev-alias"

zplug load --verbose

eval "$(rbenv init -)"
eval "$(starship init zsh)"

alias ls="exa"
alias lg="lazygit"
alias rm="trash-put"
alias ll="exa -l"
alias la="exa -a"
alias lla="exa -la"
alias cat="bat"
alias t="trans"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

neofetch

# Customize to your needs...
source /usr/share/nvm/init-nvm.sh

function fzf-ghq() {
  local dir
  dir="$(ghq root)/$(ghq list | fzf --height 40% --reverse)"
  BUFFER="$BUFFER$dir"
  CURSOR+=${#dir}
  zle redisplay
}
zle -N fzf-ghq
bindkey "^g" fzf-ghq

abbrev-alias -g dc="docker-compose"
abbrev-alias -g be="bundle exec"
abbrev-alias -g tns="tmux new-session -s"
abbrev-alias -g berd="bundle exec rails db"
abbrev-alias -g berc="bundle exec rails console"
abbrev-alias -g bers="bundle exec rails server"
abbrev-alias -g gst="git status"
abbrev-alias -g gbr="git branch"
abbrev-alias -g gco="git checkout"
abbrev-alias -g gci="git commit"
abbrev-alias -g gfe="git fetch"

#!/bin/bash

eval "$(starship init bash)"

export EDITOR=nvim
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='--exact'

export HISTSIZE=-1
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
export PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

[[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
[[ -r "$HOMEBREW_PREFIX/etc/bash_completion.d/git-completion.bash" ]] && . "$HOMEBREW_PREFIX/etc/bash_completion.d/git-completion.bash"
[[ -r "$HOME/.asdf/completions/asdf.bash" ]] && . $HOME/.asdf/completions/asdf.bash

[ -f ~/.fzf.bash ] && source "$HOME/.fzf.bash"

_cdg () {
  cd "$(ghq list --full-path | fzf)" || exit
}

bind -x '"\C-g": _cdg'

alias be="bundle exec"
alias ls="exa"
alias cat="bat"
alias lg="lazygit"

alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"

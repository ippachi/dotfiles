set -x PATH $HOME/.rbenv/bin $PATH

rbenv init - | source

set -x PATH $HOME/.rbenv/plugins/ruby-build/bin $PATH

alias be='bundle exec'
alias bers='bundle exec rails s -b 0.0.0.0'
alias nvimg='nvim (git ls-files | fzf)'
alias bet='env RAILS_ENV=test bundle exec'
alias ch='cd $PROJECT_HOME'

set -x PYENV_ROOT $HOME/.pyenv
set -x PATH $PYENV_ROOT/bin $PATH

if command -v pyenv 1>/dev/null 2>&1;
  pyenv init - | source
end

status --is-interactive; and source (pyenv virtualenv-init -|psub)

set -x FZF_DEFAULT_OPTS '--height 40% --reverse --border'
set -x FZF_ALT_C_OPTS "--preview 'tree -C {} | head -200'"

set -x EDITOR nvim

direnv hook fish | source

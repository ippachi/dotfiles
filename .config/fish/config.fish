set -x PATH $HOME/.rbenv/bin $PATH

rbenv init - | source

set -x PATH $HOME/.rbenv/plugins/ruby-build/bin $PATH

alias be='bundle exec'
alias bers='bundle exec rails s -b 0.0.0.0'
alias behs='bundle exec hanami s --host 0.0.0.0 --port 3000'
alias bet='env RAILS_ENV=test bundle exec'
alias ch='cd $PROJECT_HOME'
alias dc='docker-compose'
alias ce='composer exec'
alias nvimf='nvim (fzf)'
alias chc='sudo sysctl -w vm.drop_caches=3'
alias lbe='env BUNDLE_GEMFILE="Gemfile.local" bundle exec'
alias pyvir='status --is-interactive; and source (pyenv virtualenv-init -|psub)'
alias nvimdf='~/squashfs-root/usr/bin/nvim (fzf)'

set -x PYENV_ROOT $HOME/.pyenv
set -x PATH $PYENV_ROOT/bin $PATH

set -x PATH /usr/local/go/bin $PATH
set -x GOPATH $HOME/go
set -x PATH $GOPATH/bin $PATH


set -x PATH $HOME/.fzf/bin $PATH
set -x FZF_DEFAULT_COMMAND 'fd --type f'
set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -x FZF_DEFAULT_OPTS '--height 40% --reverse --border'
set -x FZF_ALT_C_OPTS "--preview 'tree -C {} | head -200'"

if command -v pyenv 1>/dev/null 2>&1;
  pyenv init - --no-rehash | source
end

set -x EDITOR nvim

# direnv hook fish | source

[ -f ~/.zshrc_local  ] && . ~/.zshrc_local

source /usr/share/zsh/scripts/zplug/init.zsh

case $OSTYPE in
  linux*)
    source $HOME/.asdf/asdf.sh
    source /usr/share/fzf/key-bindings.zsh
    ;;
  darwin*)
    export ZPLUG_HOME=/usr/local/opt/zplug
    source $ZPLUG_HOME/init.zsh
    ;;
esac

zplug "zsh-users/zsh-completions"
zplug "momo-lab/zsh-abbrev-alias"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "mollifier/cd-gitroot"

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose

export HISTSIZE=10000
export SAVEHIST=1000000
export EDITOR=nvim

export PATH=$HOME/go/bin:$PATH

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export GOPATH="$HOME/go"

setopt hist_ignore_dups

abbrev-alias -g be="bundle exec"
abbrev-alias -g ber="bundle exec rails"

abbrev-alias -g dc="sudo docker-compose"
abbrev-alias -g dcu="sudo docker-compose up"
abbrev-alias -g dcd="sudo docker-compose down"

abbrev-alias -g mux="tmuxinator"
abbrev-alias -g lg="lazygit"

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

eval "$(starship init zsh)"

autoload -Uz edit-command-line

zle -N edit-command-line
bindkey '^xe' edit-command-line

autoload -Uz compinit && compinit

neofetch

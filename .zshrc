# Created by newuser for 5.5.1

source /home/vagrant/.zprezto/init.zsh
source /usr/share/zsh/scripts/zplug/init.zsh

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"

export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000

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
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

neofetch

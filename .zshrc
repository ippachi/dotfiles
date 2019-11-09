# Created by newuser for 5.5.1

source /home/vagrant/.zprezto/init.zsh

source ~/.zplug/init.zsh

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/.local/bin"
export export HISTSIZE=10000
export export HISTSIZE=1000000

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

lsof -i:55100 > /dev/null
if [ $status -eq 1 ]; then
  google-ime-skk > /dev/null 2>&1 &
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

neofetch

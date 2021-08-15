### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zstyle ':prezto:module:autosuggestions' color 'yes'
zstyle ':prezto:module:syntax-highlighting' color 'yes'
zstyle ':prezto:module:syntax-highlighting' highlighters \
  'main' \
  'brackets' \
  'pattern' \
  'line' \
  'root'
zstyle ':prezto:module:utility:ls' color 'yes'
zstyle ':prezto:module:utility:ls' dirs-first 'yes'
zstyle ':prezto:module:utility:grep' color 'yes'
zstyle ':prezto:module:utility:diff' color 'yes'
zstyle ':prezto:module:ssh:load' identities 'id_ed25519'

zinit light zinit-zsh/z-a-submods

zinit snippet PZTM::helper
zinit snippet PZTM::completion
zinit snippet PZTM::utility
zinit snippet PZTM::ssh
zinit snippet PZTM::history

zinit ice submods'zsh-users/zsh-autosuggestions -> external'
zinit snippet PZTM::autosuggestions

zinit ice submods'zsh-users/zsh-syntax-highlighting -> external'
zinit snippet PZTM::syntax-highlighting

zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light olets/zsh-abbr
zinit light migutw42/zsh-fzf-ghq

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Customize to your needs...
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval $(/opt/homebrew/bin/brew shellenv)
elif [[ -f /usr/local/bin/brew ]]; then
  eval $(/usr/local/bin/brew shellenv)
fi

. $HOMEBREW_PREFIX/opt/asdf/asdf.sh

export PATH=~/bin:$PATH

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

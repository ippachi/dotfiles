if [ -f /opt/homebrew/bin/brew ]; then
  HOMEBREW_PREFIX=/opt/homebrew
elif [ -f /usr/local/bin/brew ]; then
  HOMEBREW_PREFIX=/usr/local
fi

eval $($HOMEBREW_PREFIX/bin/brew shellenv 2>/dev/null)
export PATH=$HOMEBREW_PREFIX/share/git-core/contrib/diff-highlight:$PATH
export PATH=$HOME/local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"

export LANG=en_US.UTF-8

. $HOMEBREW_PREFIX/opt/asdf/asdf.sh

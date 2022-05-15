if [ -f /usr/local/bin/brew ]; then
  eval $(/usr/local/bin/brew shellenv)
fi

if [ -f /opt/homebrew/bin/brew ]; then
  eval $(/opt/homebrew/bin/brew shellenv)
  export PATH=/opt/homebrew/bin:$PATH
  export PATH=/opt/homebrew/opt/openssl@3/bin:$PATH
  export PATH=/opt/homebrew/share/git-core/contrib/diff-highlight:$PATH
elif [ -f /usr/local/bin/brew ]; then
  eval $(/usr/local/bin/brew shellenv)
  export PATH=/usr/local/share/git-core/contrib/diff-highlight:$PATH
fi

export PATH=$HOME/local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"

export LANG=en_US.UTF-8

. $HOMEBREW_PREFIX/opt/asdf/asdf.sh

#!/bin/sh

if [ -f /opt/homebrew/bin/brew ]; then
  HOMEBREW_PREFIX=/opt/homebrew
elif [ -f /usr/local/bin/brew ]; then
  HOMEBREW_PREFIX=/usr/local
fi

if [ -n "$HOMEBREW_PREFIX" ]; then
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv 2>/dev/null)"
  . $HOMEBREW_PREFIX/opt/asdf/asdf.sh

  export PATH="$HOMEBREW_PREFIX/share/git-core/contrib/diff-highlight:$PATH"
  export PATH="$HOMEBREW_PREFIX/opt/grep/libexec/gnubin:$PATH"
  export PATH="$HOMEBREW_PREFIX/opt/openssl@3/bin:$PATH"
fi

export PATH="$HOME/local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

export LANG=en_US.UTF-8

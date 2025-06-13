if status is-interactive
  set -x EDITOR nvim

  # Commands to run in interactive sessions can go here
  /opt/homebrew/bin/brew shellenv | source
end

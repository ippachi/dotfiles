if status is-interactive
  set -x EDITOR nvim

  # Commands to run in interactive sessions can go here
  /opt/homebrew/bin/brew shellenv | source

  # fish-done
  set -U __done_notification_command "echo -e \"\033]777;notify;\$title;\$message\007\""
end

#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash ssh-to-age gnugrep coreutils openssh age

mkdir -p ~/.config/sops

if [ -f ~/.config/sops/age.key ]; then
  # nix-shell -p hyperfine age ssh-to-age \
  #   --run 'hyperfine "age-keygen -y /home/rithvij/.config/sops/age.key" "ssh-to-age < /home/rithvij/.ssh/id_ed25519.pub" -N'

  age-keygen -y ~/.config/sops/age.key
  #ssh-to-age < ~/.ssh/id_ed25519.pub
  exit 0
fi

if [ -f ~/.ssh/id_ed25519 ]; then
  ssh-to-age -private-key -i ~/.ssh/id_ed25519 >~/.config/sops/age.key
else
  ssh-keygen -t ed25519
  ssh-to-age -private-key -i ~/.ssh/id_ed25519 >~/.config/sops/age.key
fi

{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "fzfalias" ''
      fzf --height 60% --layout=reverse \
        --cycle --keep-right --padding=1,0,0,0 \
        --color=label:bold --tabstop=1 --border=sharp \
        --border-label="  $1  " \
        "''${@:2}"
    '')
    (pkgs.writeShellScriptBin "lazygit_fzf" ''
      repo=$(yq ".recentrepos | @tsv" ~/.config/lazygit/state.yml | sed -e "s/\"//g" -e "s/\\\\t/\n/g" | fzfalias "lazygit-repos")
      if [ -n "$repo" ]; then
         pushd "$repo" || exit 1
         lazygit
         popd || exit 1
      fi
    '')
  ];
}

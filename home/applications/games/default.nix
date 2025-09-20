{ pkgs, ... }:
{
  imports = [
    ./minecraft.nix
  ];

  /*
    https://github.com/search?q=lang%3ANix+ludusavi&type=code
    https://github.com/foo-dogsquared/nixos-config/blob/master/modules/home-manager/services/ludusavi.nix
    https://github.com/Saghen/nixfiles/blob/main/nixos/base/backups.nix
    https://github.com/P1n3appl3/config/blob/main/mixins/home/graphical/games.nix
    https://github.com/Plamper/nixos-config/blob/master/nixos/common/optional/gaming.nix
    https://github.com/thilobillerbeck/dotfiles/blob/32815180d12079a6a9ab7263d70411008ac1e093/home-manager/modules/packages.nix#L123-L138
  */
  home.packages = with pkgs; [
    # TODO antimicrox
    # TODO bottles
    # TODO lutris
    # TODO mangohud, gamemode
    lazyPkgs.heroic # TODO backups for wine etc.
    lazyPkgs.gamescope # TODO what is this?

    lazyPkgs.ludusavi # TODO service w/ rclone?

    # TODO download scripts and rclone backup
    # TODO tui?
    lazyPkgs.lgogdownloader

    lazyPkgs.a-keys-path # gmtk2020 winner
    lazyPkgs.honey-home # ld38 winner
    lazyPkgs.oh-my-git
  ];
}

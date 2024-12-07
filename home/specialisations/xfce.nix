{ config, ... }:
let
  repoDir = "/shed/Projects/system";
  symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [ ./config/xfconf.nix ];

  # TODO
  # docklike plugin config
  #   - [ ] track with yadm?
  #         or home-manager with read/write to allow visual modification
  #         mkOutOfStoreSymlink and hm.dag.entryAfter with stow?

  # to keep it consistent https://gitlab.xfce.org/panel-plugins/xfce4-docklike-plugin/-/blob/master/src/Settings.cpp#L56
  # g_key_file_save_to_file -> overwrite fails?
  home.file.".config/xfce4/panel/docklike.rc".source =
    symlink "${repoDir}/home/specialisations/config/docklike.rc";
}

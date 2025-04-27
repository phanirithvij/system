{
  username,
  hostname,
  ...
}:
let
  #configDir = "${config.home.homeDirectory}/Projects/system"; # TODO impure??
  hostvars = import ../../hosts/${hostname}/variables.nix;
  configDir = hostvars.SYSTEM_DIR;
in
{
  programs.topgrade = {
    enable = true;
    # https://github.com/topgrade-rs/topgrade/blob/1e9de5832d977f8f89596253f2880760533ec5f5/config.example.toml
    settings = {
      misc = {
        assume_yes = true;
        disable = [ "bun" ];
        set_title = false;
        cleanup = true;
        run_in_tmux = true;
        skip_notify = true;
      };
      linux = {
        nix_arguments =
          if (hostname == null) then "--flake ${configDir}" else "--flake ${configDir}#${hostname}";
        home_manager_arguments = [
          "--flake"
          (if (hostname == null) then "${configDir}#${username}" else "${configDir}#${username}@${hostname}")
        ];
      };
    };
  };
}

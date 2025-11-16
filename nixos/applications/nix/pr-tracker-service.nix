{
  hostname,
  config,
  lib,
  pkgs,
  ...
}:
let
  # TODO remove once I can use cloned nixpkgs in pr-tracker without systemd timer pull
  # TODO ensure dataDir is owned by pr-tracker grp
  # in the upstream PR
  # writeable by the grp
  # and git safe dir because initially it was owned by other user/grp
  hostvars = import ../../../hosts/${hostname}/variables.nix;
  dataDir = hostvars.NixpkgsHome;
  nixpkgsDir = "${dataDir}/nixpkgs";
  cfg = config.services.pr-tracker.enable;
in
{
  options.services.pr-tracker.enable = lib.mkEnableOption "pr-tracker";
  config = lib.mkIf cfg {
    users.users = {
      pr-tracker = {
        group = "users";
        home = dataDir;
        isSystemUser = true;
      };
    };
    sops.secrets.gh_t_pr_tracker = { };
    systemd.services.pr-tracker = {
      path = [ pkgs.git ];
      enable = true;
      serviceConfig = {
        #Type = "simple";
        User = "pr-tracker";
        Group = "users";
        EnvironmentFile = config.sops.secrets.gh_t_pr_tracker.path;
        ExecStartPre = ''
          ${pkgs.git}/bin/git config --global --add safe.directory ${nixpkgsDir}
        '';
        ExecStart = ''
          ${pkgs.nurPkgs.pr-tracker}/bin/pr-tracker \
          --remote origin --mount pr-tracker \
          --path ${nixpkgsDir} \
          --user-agent 'pr-tracker (alyssais)' \
          --source-url https://git.qyliss.net/pr-tracker
        '';
      };
      #wantedBy = [ "multi-user.target" ];
      #requires = [ "pr-tracker.socket" ];
    };
    systemd.sockets.pr-tracker = {
      description = "pr tracker socket";
      wantedBy = [ "sockets.target" ];
      listenStreams = [ "0.0.0.0:8123" ];
      #socketConfig.Accept = true;
      #socketConfig.Service = "pr-tracker.service";
    };
  };
}

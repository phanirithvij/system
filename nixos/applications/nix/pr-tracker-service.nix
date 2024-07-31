{
  config,
  lib,
  pkgs,
  ...
}:
let
  pr-tracker = import ../../../pkgs/pr-tracker.nix {
    inherit (pkgs)
      rustPlatform
      lib
      fetchzip
      openssl
      pkg-config
      systemd
      ;
  };
  dataDir = "/shed/Projects/nixer";
  nixpkgsDir = "${dataDir}/nixpkgs";
  cfg = config.services.pr-tracker.enable;
in
{
  options.services.pr-tracker.enable = lib.mkEnableOption "pr-tracker";
  config = lib.mkIf cfg {
    users.users = {
      pr-tracker = {
        group = "pr-tracker";
        home = dataDir;
        isSystemUser = true;
      };
    };
    users.groups = {
      pr-tracker = { };
    };
    systemd.services.pr-tracker = {
      path = [ pkgs.git ];
      enable = true;
      serviceConfig = {
        #Type = "simple";
        User = "pr-tracker";
        Group = "pr-tracker";
        Environment = "PR_TRACKER_GITHUB_TOKEN=${gh_token}";
        #ExecStartPre = "${pkgs.git}/bin/git config --system --add safe.directory ${nixpkgsDir}";
        ExecStart = ''
          ${pr-tracker}/bin/pr-tracker \
          --remote origin \
          --mount pr-tracker \
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
      listenStreams = [ "0.0.0.0:8000" ];
      #socketConfig.Accept = true;
      #socketConfig.Service = "pr-tracker.service";
    };
  };
}

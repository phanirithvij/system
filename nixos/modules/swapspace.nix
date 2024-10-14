{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.swapspace;
  inherit (lib)
    types
    mkOption
    mkPackageOption
    mkEnableOption
    ;
  configFile = pkgs.writeText "swapspace.conf" (
    lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: "${n}=${toString v}") cfg.settings)
  );
in
{
  options.services.swapspace = {
    enable = mkEnableOption "Swapspace, a dynamic swap space manager";
    package = mkPackageOption pkgs "swapspace" { };
    settings = mkOption {
      type = types.submodule {
        options = {
          swappath = mkOption {
            type = types.str;
            default = "/var/lib/swapspace";
            description = "Location where swapspace may create and delete swapfiles";
          };
          lower_freelimit = mkOption {
            type = types.ints.between 0 100;
            default = 20;
            description = "Lower free-space threshold: if the percentage of free space drops below this number, additional swapspace is allocated";
          };
          upper_freelimit = mkOption {
            type = types.ints.between 0 100;
            default = 60;
            description = "Upper free-space threshold: if the percentage of free space exceeds this number, swapspace will attempt to free up swapspace";
          };
          freetarget = mkOption {
            type = types.ints.between 0 100;
            default = 30;
            description = ''
              Percentage of free space swapspace should aim for when adding swapspace.
              This should fall somewhere between lower_freelimit and upper_freelimit.
            '';
          };
          min_swapsize = mkOption {
            type = types.str;
            default = "4m";
            description = "Smallest allowed size for individual swapfiles.";
          };
          max_swapsize = mkOption {
            type = types.str;
            default = "2t";
            description = "Greatest allowed size for individual swapfiles.";
          };
          cooldown = mkOption {
            type = types.ints.unsigned;
            default = 600;
            description = ''
              Duration (roughly in seconds) of the moratorium on swap allocation that is instated if disk space runs out, or the cooldown time after a new swapfile is successfully allocated before swapspace will consider deallocating swap space again.
              The default cooldown period is about 10 minutes.
            '';
          };
        };
      };
      default = { };
      description = ''
        Config file for swapspace.
        See the options here: <https://github.com/Tookmund/Swapspace/blob/master/swapspace.conf>
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.services.swapspace = {
      after = [
        "local-fs.target"
        "swap.target"
      ];
      requires = [
        "local-fs.target"
        "swap.target"
      ];
      wantedBy = [ "multi-user.target" ];
      documentation = [ "man:swapspace(8)" ];
      description = "Swapspace, a dynamic swap space manager";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} -c ${configFile}";
        Restart = "always";
        RestartSec = 30;
        StateDirectory = lib.mkIf (cfg.settings.swappath == "/var/lib/swapspace") "swapspace";
        StateDirectoryMode = "0700";
        WorkingDirectory = cfg.settings.swappath;
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ phanirithvij ];
  };

  # in flake.nix export as nixosModules.swapspace?
  # [ ] nixpkgs pr
  # blog post tagged nix, linux, swap, zram
  # - note that comparision and benchmarks is not the goal just discoverability
  # - swapspace limitations (readme mentions some)
}

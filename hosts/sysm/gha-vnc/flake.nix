{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-system-graphics = {
      url = "github:soupglasses/nix-system-graphics";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    systemConfigs.default = inputs.system-manager.lib.makeSystemConfig {
      modules = [
        inputs.nix-system-graphics.systemModules.default
        ../modules/vnc-fluxbox.nix
        {
          config = {
            nixpkgs.hostPlatform = builtins.currentSystem; # And thus --impure is required
            system-manager.allowAnyDistro = true;
            system-graphics.enable = true;
          };
        }
        {
          config = {
            nix.settings = {
              system-features = [ "uid-range" ];
              experimental-features = "nix-command flakes ca-derivations";
              allowed-users = [ "*" ];
              trusted-users = [ "runner" ];
              build-users-group = "nixbld";
              max-jobs = "auto";
              cores = 0;
              auto-optimise-store = false;
              require-sigs = true; # TODO may need to disable for magic-nix-cache? because there could be no signing key
              sandbox = true;
              show-trace = true;
              always-allow-substitutes = true;
              substituters = [ ]; # TODO may need to add magic-nix-cache
              trusted-public-keys = [ ]; # TODO may need to add magic-nix-cache
              access-tokens = "github.com=${builtins.getEnv "ENV_GITHUB_TOKEN"}"; # And thus --impure is required
            };
          };
        }
      ];
    };
  };
}

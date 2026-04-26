{
  inputs = {
    # THIS is dumb unless nixpkgs is based on nixos-unstable
    # TODO checkout https://github.com/blitz/hydrasect
    # useful for git bisecting, use path:/abs/path instead for the same
    #nixpkgs.url = "git+file:///shed/Projects/nixhome/nixpkgs/nixos-unstable?shallow=1";
    nixpkgs.url = "github:phanirithvij/nixpkgs/nixos-patched-bisect"; # managed via nix-patcher
    nixpkgs-upstream.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-patcher.url = "github:phanirithvij/nixpkgs-patcher/main";

    #nur-pkgs.url = "git+file:///shed/Projects/nur-packages";
    nur-pkgs.url = "github:phanirithvij/nur-packages/master";
    nur-pkgs.inputs.nixpkgs.follows = "nixpkgs";
    nur-pkgs.inputs.nix-update.follows = "nix-update";
    # TODO in nur-pkgs gha we build for nixos-unstable and nixpkgs-unstable
    # but what if nur-pkgs.flake.inputs.nixpkgs is outdated? does cache still work?

    home-manager.url = "github:phanirithvij/home-manager/patched";
    home-manager-upstream.url = "github:nix-community/home-manager/master";
    home-manager-upstream.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    system-manager = {
      #url = "git+file:///shed/Projects/nixer/community-projects/numtide/system-manager";
      url = "github:numtide/system-manager/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/master";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixdroidpkgs.url = "github:horriblename/nixdroidpkgs/main";
    nixdroidpkgs.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #nimi.url = "github:phanirithvij/nimi/fix-hm-class";
    nimi.url = "github:weyl-ai/nimi/master";
    nimi.inputs.nixpkgs.follows = "nixpkgs";

    wrapper-manager.url = "github:viperML/wrapper-manager/master";

    # lazy-apps.url = "sourcehut:~rycee/lazy-apps"; # upstream
    lazy-apps.url = "git+file:///shed/Projects/nixer/core/lazy-apps?shallow=1";
    # lazy-apps.url = "github:phanirithvij/lazy-apps/master"; # hard fork
    lazy-apps.inputs.nixpkgs.follows = "nixpkgs";
    lazy-apps.inputs.pre-commit-hooks.follows = "git-hooks";

    sops-nix.url = "github:Mic92/sops-nix/master";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    #gowt.url = "git+file:///shed/Projects/own/ownix/go-wt";
    gowt.url = "github:phanirithvij/gowt";
    gowt.inputs.flake-utils.follows = "flake-utils";
    gowt.inputs.nixpkgs.follows = "nixpkgs";

    oranc.url = "github:linyinfeng/oranc/main";
    oranc.inputs.flake-parts.follows = "flake-parts";
    oranc.inputs.nixpkgs.follows = "nixpkgs";
    oranc.inputs.treefmt-nix.follows = "treefmt-nix";
    oranc.inputs.crane.follows = "crane";

    devshell.url = "github:numtide/devshell/main";
    devshell.inputs.nixpkgs.follows = "nixpkgs";

    #devshell-lib.url = "path:/shed/Projects/own/ownix/nix-shell-templates";
    devshell-lib.url = "github:phanirithvij/nix-shell-templates/main";
    devshell-lib.flake = false;

    treefmt-nix.url = "github:numtide/treefmt-nix/main";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    git-hooks.url = "github:cachix/git-hooks.nix/master";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks.inputs.flake-compat.follows = "flake-compat";

    navi_config.url = "github:phanirithvij/navi/main";
    navi_config.flake = false;

    # idea from gh:heywoodlh/nixos-configs
    ssh-keys.url = "https://github.com/phanirithvij.keys";
    ssh-keys.flake = false;

    nix-index-database.url = "github:nix-community/nix-index-database/main";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    #nix-patcher.url = "path:/shed/Projects/others/nixpkgs-maintain/nix-patcher";
    nix-patcher.url = "github:phanirithvij/nix-patcher/main"; # to manage own nixpkgs fork
    nix-patcher.inputs.nixpkgs.follows = "nixpkgs";
    # it can also manage other flake inputs forks

    home-manager-patch-10.url = ./home/patches/docs-manpages-parallel.patch;
    home-manager-patch-10.flake = false;

    # dotfiles relocator kernel module
    # maintain own fork without any changes, because author's selfhosted repo can go down (from my experience)
    modetc.url = "github:phanirithvij/modetc-fork/master";
    modetc.flake = false;

    # nix client with schema support: see https://github.com/NixOS/nix/pull/8892
    flake-schemas.url = "github:DeterminateSystems/flake-schemas/main";

    # https://github.com/hyprwm/Hyprland/issues/9314#issuecomment-2634051281
    hyprland.url = "https://github.com/hyprwm/Hyprland.git";
    hyprland.type = "git";
    hyprland.submodules = true;
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.inputs.pre-commit-hooks.follows = "git-hooks";

    niri.url = "github:sodiboo/niri-flake/main";
    niri.inputs.nixpkgs.follows = "nixpkgs";
    niri.inputs.nixpkgs-stable.follows = "nixpkgs-stable";

    # Indirect dependencies, dedup
    systems.url = "github:nix-systems/default-linux/main";

    crane.url = "github:ipetkov/crane/master";

    flake-parts.url = "github:hercules-ci/flake-parts/main";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils/main";
    flake-utils.inputs.systems.follows = "systems";

    flake-compat.url = "github:edolstra/flake-compat/master";
    flake-compat.flake = false;

    rust-overlay.url = "github:oxalica/rust-overlay/master";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    cargo2nix = {
      url = "github:cargo2nix/cargo2nix/release-0.12";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    nix-update.url = "github:Mic92/nix-update/main";
    nix-update.inputs.flake-parts.follows = "flake-parts";
    nix-update.inputs.nixpkgs.follows = "nixpkgs";
    nix-update.inputs.treefmt-nix.follows = "treefmt-nix";
  };

  outputs =
    inputs:
    let
      allSystemsJar = inputs.flake-utils.lib.eachDefaultSystem (
        system:
        let
          # so nixpkgs-patcher
          patched = inputs.nixpkgs-patcher.lib {
            nixpkgsPatcher.inputs = inputs;
            nixpkgsPatcher.patchInputRegex = ".*-nixpkgs-patch$"; # default: "^nixpkgs-patch-.*"
            modules = [ { nixpkgs.hostPlatform = system; } ]; # without this, impure will be required
          };

          lib = import (patched.nixpkgs' + "/lib");

          pkgs = import patched.nixpkgs' {
            inherit system overlays;
            config = {
              nvidia.acceptLicense = true;
              allowUnfreePredicate =
                pkg:
                let
                  pname = lib.getName pkg;
                  byName = builtins.elem pname [
                    "spotify" # in lazyapps used in home-manager
                    "hplip" # printer
                    "cloudflare-warp"
                    "nvidia-persistenced"
                    "plexmediaserver"
                    "p7zip"
                    "steam"
                    "steam-unwrapped"
                    "honey-home"
                    "discord"
                    "zoom"
                    "nvidia-x11"
                    "nvidia-settings"
                  ];
                in
                if byName then lib.warn "Allowing unfree package: ${pname}" true else false;
              allowInsecurePredicate =
                pkg:
                let
                  name = "${lib.getName pkg}-${lib.getVersion pkg}";
                  byName = builtins.elem name [
                    "beekeeper-studio-5.5.7" # Electron version 32 is EOL, hm
                  ];
                in
                if byName then lib.warn "Allowing insecure package: ${name}" true else false;
            };
          };

          args = {
            inherit pkgs system lib;
            flake-inputs = inputs // {
              inherit (patched) nixpkgs';
            };
          };
          wrappedPkgs = import ./pkgs/wrapped-pkgs args;
          binaryPkgs = import ./pkgs/binary args;
          boxxyPkgs = import ./pkgs/boxxy args;
          lazyPkgs = import ./pkgs/lazy args;
          nurPkgs = import ./pkgs/nurpkgs.nix args;
          nvidia-offload = import ./pkgs/nvidia-offload.nix args;

          overlays =
            (import ./lib/overlays {
              inherit system;
              flake-inputs = inputs // {
                inherit (patched) nixpkgs';
              };
            })
            ++ [ inputs.niri.overlays.niri ]
            ++ [
              (_: _: {
                gwt = inputs.gowt.packages.${system}.default;
              })
            ]
            ++ (builtins.attrValues
              (import "${inputs.nur-pkgs}" { }).overlays
            )
            ++ [
              (final: prev: {
                inherit
                  wrappedPkgs
                  lazyPkgs
                  nurPkgs
                  boxxyPkgs
                  binaryPkgs
                  nvidia-offload
                  ;
                lib = prev.lib // {
                  mine = {
                    unNestAttrs = import ./lib/unnest.nix { inherit pkgs; };
                    GPUOffloadApp = final.callPackage ./lib/gpu-offload.nix { };
                  };
                };
              })
            ];

          hmlib = pkgs.lib.extend (_: _: inputs.home-manager.lib // { inherit (pkgs.lib) mine; });

          treefmtCfg =
            (inputs.treefmt-nix.lib.evalModule pkgs (import ./treefmt.nix { inherit pkgs; })).config.build;
          hm = inputs.home-manager.packages.${system}.default;
          nixp = inputs.nix-patcher.packages.${system}.nix-patcher;
          nh' = nurPkgs.nh;
          nom' = nurPkgs.flakePkgs.nix-output-monitor;

          lazyApps = lib.mine.unNestAttrs lazyPkgs;
        in
        {
          inherit
            pkgs
            overlays
            wrappedPkgs
            binaryPkgs
            boxxyPkgs
            lazyPkgs
            nurPkgs
            nvidia-offload
            lazyApps
            hmlib
            treefmtCfg
            hm
            nixp
            nh'
            nom'
            ;
          inherit (patched) nixpkgs' args';
        }
      );
    in
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        inherit (allSystemsJar.${system})
          pkgs
          lazyApps
          wrappedPkgs
          boxxyPkgs
          binaryPkgs
          nurPkgs
          nvidia-offload
          treefmtCfg
          hm
          nixp
          nh'
          nom'
          ;
        inherit (pkgs) lib;
      in
      {
        inherit
          pkgs
          lazyApps
          wrappedPkgs
          boxxyPkgs
          binaryPkgs
          nurPkgs
          nvidia-offload
          ;
        inherit (allSystemsJar.${system})
          overlays
          nixpkgs'
          args'
          hmlib
          ;

        packages =
          let
            _pkgs = {
              navi-master = pkgs.navi;
              home-manager = hm;
              nix-patcher = nixp;
              nvidia-offload = nvidia-offload;
            }
            // lazyApps
            // wrappedPkgs
            // boxxyPkgs
            // binaryPkgs
            // (lib.filterAttrs (_: v: lib.isDerivation v && !(v ? meta && v.meta.broken)) (
              lib.mine.unNestAttrs nurPkgs
            ));
          in
          _pkgs;

        checks = {
          formatting = treefmtCfg.check inputs.self;
          git-hooks-check = inputs.git-hooks.lib.${system}.run {
            src = lib.cleanSource ./.;
            hooks = {
              treefmt = {
                enable = true;
                stages = [ "pre-push" ];
                package = treefmtCfg.wrapper;
              };
              skip-ci-check = {
                enable = true;
                always_run = true;
                stages = [ "prepare-commit-msg" ];
                entry = builtins.toString (
                  pkgs.writeShellScript "skip-ci-md" ''
                    COMMIT_MSG_FILE=$1
                    STAGED_FILES=$(git diff --cached --name-only)
                    if [ -z "$STAGED_FILES" ] || ! echo "$STAGED_FILES" | grep -qE '\.md$'; then
                      exit 0
                    fi
                    if grep -q "\[skip ci\]" "$COMMIT_MSG_FILE"; then
                      exit 0
                    fi
                    echo "[skip ci]" >> "$COMMIT_MSG_FILE"
                  ''
                );
              };
            };
          };
        };

        devShells.default =
          (import (inputs.devshell-lib + "/lib/devshells.nix") {
            name = "system";
            inherit pkgs treefmtCfg;
            enableTreefmt = true;
            tools = with pkgs; [
              nixp
              nh'
              nom'
              cachix
              xc
            ];
            packages = inputs.self.checks.${system}.git-hooks-check.enabledPackages;
            extraCommands = [ ];
            devshell = import inputs.devshell { nixpkgs = pkgs; };
          }).shell.overrideAttrs (prev: {
            name = "system";
            shellHook = prev.shellHook + inputs.self.checks.${system}.git-hooks-check.shellHook;
          });
      }
    )
    // (
      let
        system = "x86_64-linux";

        user = "rithvij";
        uzer = "rithviz";
        droid = "nix-on-droid";
        liveuser = "nixos";

        linuxhost = "iron";
        hostdroid = "localhost";
        livehost = "nixos";

        pkgs = allSystemsJar.${system}.pkgs;
        nixpkgs' = allSystemsJar.${system}.nixpkgs';
        args' = allSystemsJar.${system}.args';

        nixosSystem = import (nixpkgs' + "/nixos/lib/eval-config.nix");

        getFlakeInputs = system: inputs // { nixpkgs' = allSystemsJar.${system}.nixpkgs'; };

        hmAliasModules = (import ./home/applications/alias-groups.nix { inherit pkgs; }).aliasModules;
        homeConfig =
          {
            username,
            hostname ? null,
            modules ? [ ],
            system ? "x86_64-linux",
          }:
          inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = allSystemsJar.${system}.pkgs;
            modules = [ ./home/users/${username} ] ++ modules ++ hmAliasModules;
            extraSpecialArgs = {
              flake-inputs = getFlakeInputs system;
              lib = allSystemsJar.${system}.hmlib;
              inherit system;
              inherit username;
              inherit hostname;
            };
          };
        nix-index-hm-modules = [
          inputs.nix-index-database.homeModules.nix-index
          { programs.nix-index-database.comma.enable = true; }
        ];
        common-hm-modules = [
          inputs.sops-nix.homeManagerModules.sops
          inputs.lazy-apps.homeModules.default
        ];
        hm = inputs.home-manager.packages.${system}.default;
        toolsModule = {
          environment.systemPackages = [
            hm
          ];
        };
        overlayModule = {
          nixpkgs.overlays = allSystemsJar.${system}.overlays;
        };
        versionModule = {
          system.nixos.revision = inputs.nixpkgs.rev or inputs.nixpkgs.shortRev;
          system.configurationRevision = inputs.self.rev or "dirty";
        };
      in
      {
        schemas = inputs.flake-schemas.schemas // {
          lazyApps = inputs.flake-schemas.schemas.packages;
          systemConfigs = {
            version = 1;
            doc = ''
              The `systemConfigs` flake output defines [system-manager configurations](https://github.com/numtide/system-manager).
            '';
            inventory =
              output:
              inputs.flake-schemas.lib.mkChildren (
                builtins.mapAttrs (configName: this: {
                  what = "system-manager configuration ${configName}";
                  derivation = this;
                  forSystems = [ this.system ];
                }) output
              );
          };
          nixOnDroidConfigurations = {
            version = 1;
            doc = ''
              The `nixOnDroidConfigurations` flake output defines [nix-on-droid configurations](https://github.com/nix-community/nix-on-droid).
            '';
            inventory =
              output:
              inputs.flake-schemas.lib.mkChildren (
                builtins.mapAttrs (configName: this: {
                  what = "nix-on-droid configuration ${configName}";
                  derivation = this.activationPackage;
                  forSystems = [ this.activationPackage.system ];
                }) output
              );
          };
        };
        systemConfigs = {
          gha = inputs.system-manager.lib.makeSystemConfig {
            modules = [ ./hosts/sysm/gha/configuration.nix ];
            overlays = allSystemsJar.${system}.overlays;
            extraSpecialArgs = {
              inherit (pkgs) lib;
            };
          };
          vps = inputs.system-manager.lib.makeSystemConfig {
            modules = [ ./hosts/sysm/vps/configuration.nix ];
            overlays = allSystemsJar.${system}.overlays;
            extraSpecialArgs = {
              inherit (pkgs) lib;
            };
          };
        };
        homeConfigurations = {
          ${user} = homeConfig {
            username = user;
            hostname = linuxhost;
            modules = nix-index-hm-modules ++ common-hm-modules;
            inherit system;
          };
          ${uzer} = homeConfig {
            username = uzer;
            hostname = linuxhost;
            modules = nix-index-hm-modules ++ common-hm-modules;
            inherit system;
          };
          "${droid}@${hostdroid}" = homeConfig {
            username = droid;
            hostname = "nod";
            modules = common-hm-modules;
            system = "aarch64-linux";
          };
          "${liveuser}@${livehost}" = homeConfig {
            username = liveuser;
            hostname = livehost;
            modules = common-hm-modules;
            inherit system;
          };
          runner = homeConfig {
            username = "runner";
            hostname = "unknown";
            modules = nix-index-hm-modules ++ common-hm-modules;
            inherit system;
          };
        };
        nixosConfigurations = {
          defaultIso = nixosSystem {
            inherit (pkgs) lib;
            inherit system pkgs;
            specialArgs = {
              flake-inputs = getFlakeInputs system;
              inherit (pkgs) lib;
            };
            modules = [
              versionModule
              toolsModule
              overlayModule
              inputs.sops-nix.nixosModules.sops
              inputs.home-manager.nixosModules.home-manager
              inputs.lazy-apps.nixosModules.default
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.nixos = ./home/users/nixos;
                  extraSpecialArgs = {
                    lib = allSystemsJar.${system}.hmlib;
                    flake-inputs = getFlakeInputs system;
                    username = liveuser;
                    hostname = livehost;
                    inherit system;
                  };
                  sharedModules = common-hm-modules ++ hmAliasModules;
                };
              }
              ./hosts/nixos/iso.nix
            ]
            ++ args'.modules;
          };
          ${linuxhost} = nixosSystem {
            inherit (pkgs) lib;
            inherit system pkgs;
            trackDependencies = true;
            modules = [
              versionModule
              toolsModule
              overlayModule
              inputs.sops-nix.nixosModules.sops
              inputs.niri.nixosModules.niri
              ./hosts/${linuxhost}/configuration.nix
              ./nixos/modules/rustical.nix
              inputs.lazy-apps.nixosModules.default
              {
                system.extraDependencies = [ nixpkgs' ];
              }
            ]
            ++ args'.modules;
            specialArgs = {
              inherit (pkgs) lib;
              flake-inputs = getFlakeInputs system;
              inherit system;
              username = user;
              hostname = linuxhost;
            };
          };
          wsl = nixosSystem {
            inherit system pkgs;
            inherit (pkgs) lib;
            modules = [
              versionModule
              toolsModule
              overlayModule
              inputs.sops-nix.nixosModules.sops
              inputs.nixos-wsl.nixosModules.default
              ./hosts/wsl/configuration.nix
              inputs.home-manager.nixosModules.home-manager
              inputs.lazy-apps.nixosModules.default
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.nixos = ./home/users/nixos;
                  extraSpecialArgs = {
                    lib = allSystemsJar.${system}.hmlib;
                    flake-inputs = getFlakeInputs system;
                    username = liveuser;
                    hostname = livehost;
                    inherit system;
                  };
                  sharedModules = common-hm-modules ++ hmAliasModules;
                };
              }
            ]
            ++ args'.modules;
            specialArgs = {
              inherit (pkgs) lib;
              flake-inputs = getFlakeInputs system;
              inherit system;
              username = "nixos";
              hostname = "nixos";
            };
          };
        };
        nixOnDroidConfigurations =
          let
            system = "aarch64-linux";
            mdroid = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
              pkgs = allSystemsJar.${system}.pkgs;
              extraSpecialArgs = {
                flake-inputs = getFlakeInputs system;
                hmSharedModules = hmAliasModules;
              };
              modules = [ ./hosts/nod ];
            };
          in
          {
            inherit mdroid;
            default = mdroid;
          };
      }
    );
}

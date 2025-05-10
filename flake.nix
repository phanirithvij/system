{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    nur-pkgs.url = "github:phanirithvij/nur-packages/master";
    nur-pkgs.inputs.nix-update.follows = "nix-update";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    system-manager = {
      url = "github:numtide/system-manager/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrapper-manager.url = "github:viperML/wrapper-manager/master";
    wrapper-manager.inputs.nixpkgs.follows = "nixpkgs";

    lazy-apps.url = "github:phanirithvij/lazy-apps/master";
    lazy-apps.inputs.nixpkgs.follows = "nixpkgs";
    lazy-apps.inputs.pre-commit-hooks.follows = "git-hooks";

    
    git-repo-manager = {
      url = "github:hakoerber/git-repo-manager/develop";
      inputs.crane.follows = "crane";
      inputs.flake-utils.follows = "flake-utils";
      inputs.rust-overlay.follows = "rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/master";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    flake-schemas.url = "github:DeterminateSystems/flake-schemas/main";

    sops-nix.url = "github:Mic92/sops-nix/master";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    navi_config.url = "github:phanirithvij/navi/main";
    navi_config.flake = false;

    nix-index-database.url = "github:nix-community/nix-index-database/main";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&ref=main";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.inputs.pre-commit-hooks.follows = "git-hooks";

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";
    niri.inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    niri.inputs.niri-unstable.follows = "niri-unstable-overview";
    
    niri-unstable-overview.url = "github:phanirithvij/niri?ref=overview";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks.inputs.flake-compat.follows = "flake-compat";
    
    yaml2nix.url = "github:euank/yaml2nix";    
    yaml2nix.inputs.nixpkgs.follows = "nixpkgs";
    yaml2nix.inputs.cargo2nix.follows = "cargo2nix";
    yaml2nix.inputs.flake-utils.follows = "flake-utils";
    
    bzmenu = {
      url = "github:e-tho/bzmenu";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
      inputs.flake-utils.follows = "flake-utils";
    };

    systems.url = "github:nix-systems/default";

    crane.url = "github:ipetkov/crane";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    cargo2nix = {
      url = "github:cargo2nix/cargo2nix/release-0.11.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    nix-update.url = "github:Mic92/nix-update";
    nix-update.inputs.nixpkgs.follows = "nixpkgs";
    nix-update.inputs.treefmt-nix.follows = "treefmt-nix";
  };

  outputs =
    { self, ... }@inputs:
    let
      allSystemsJar = inputs.flake-utils.lib.eachDefaultSystem (
        system:
        let
          args = {
            inherit pkgs system;
            flake-inputs = inputs;
          };
          boxxyPkgs = import ./pkgs/boxxy args;
          lazyPkgs = import ./pkgs/lazy args;
          wrappedPkgs = import ./pkgs/wrapped-pkgs args;
          legacyPackages = inputs.nixpkgs.legacyPackages.${system};
          inherit (legacyPackages) lib;
          
          nixpkgs' = legacyPackages.applyPatches {
            name = "nixpkgs-patched";
            src = inputs.nixpkgs;
            patches =
              builtins.map legacyPackages.fetchpatch2 [
                {
                  url = "https://github.com/NixOS/nixpkgs/pull/405151.diff?full_index=1";
                  hash = "sha256-NlG1ZSvi2U9yqj/U/Lmh2FWNLorZvGHih1Pb2v8DXQs=";
                }
              ]
              ++ [
                ./opengist-module.patch
              ];
          };
          pkgs = import (if (system == "x86_64-linux") then nixpkgs' else inputs.nixpkgs) {
            inherit overlays system;
            config = {
              nvidia.acceptLicense = true;
              allowUnfreePredicate =
                pkg:
                let
                  pname = lib.getName pkg;
                  byName = builtins.elem pname [
                    "spotify" 
                    "hplip"
                    "nvidia-x11"
                    "cloudflare-warp"
                    "nvidia-persistenced"
                    "plexmediaserver"
                    "p7zip"
                    "steam"
                    "steam-unwrapped"
                    "nvidia-settings"
                  ];
                in
                if byName then lib.warn "Allowing unfree package: ${pname}" true else false;
              allowInsecurePredicate =
                pkg:
                let
                  pname = lib.getName pkg;
                  byName = builtins.elem pname [
                    "beekeeper-studio" 
                  ];
                in
                if byName then lib.warn "Allowing insecure package: ${pname}" true else false;
              packageOverrides = _: { };
            };
          };
          overlays =
            (import ./lib/overlays {
              inherit system;
              flake-inputs = inputs;
            })
            ++ [ inputs.niri.overlays.niri ]
            ++ (builtins.attrValues
              (import "${inputs.nur-pkgs}" {
              }).overlays
            )
            ++ [
              (_: _: {
                inherit wrappedPkgs;
                inherit lazyPkgs;
                inherit boxxyPkgs;
              })
            ];
        in
        {
          inherit
            lib
            pkgs
            overlays
            nixpkgs'
            wrappedPkgs
            lazyPkgs
            boxxyPkgs
            ;
        }
      );
    in
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = allSystemsJar.pkgs.${system};
        treefmtCfg =
          (inputs.treefmt-nix.lib.evalModule pkgs (import ./treefmt.nix { inherit pkgs; })).config.build;
        grm = inputs.git-repo-manager.packages.${system}.default;
        hm = inputs.home-manager.packages.${system}.default;
        sysm = inputs.system-manager.packages.${system}.default;
        unNestAttrs = import ./lib/unnest.nix { inherit pkgs; };
      in
      {
        lazyApps = unNestAttrs allSystemsJar.lazyPkgs.${system};
        apps = { };
        packages =
          let
            _pkgs =
              {
                navi-master = pkgs.navi;
                git-repo-manager = grm;
                home-manager = hm;
                system-manager = sysm;
              }
              // allSystemsJar.wrappedPkgs.${system}
              // (unNestAttrs allSystemsJar.lazyPkgs.${system})
              // allSystemsJar.boxxyPkgs.${system};
          in
          _pkgs;
        checks = {
          formatting = treefmtCfg.check self;
          git-hooks-check = inputs.git-hooks.lib.${system}.run {
            src = pkgs.lib.cleanSource ./.;
            hooks = {
              deadnix = {
                enable = true;
                stages = [ "pre-push" ];
              };
              statix = {
                enable = true;
                stages = [ "pre-push" ];
              };
              nixfmt-rfc-style = {
                enable = true;
                stages = [
                  "pre-push"
                  "pre-commit"
                ];
              };
              skip-ci-check = {
                enable = true;
                always_run = true;
                stages = [ "prepare-commit-msg" ];
                entry = toString (
                  
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

        devShells.default = import ./flake/shell.nix {
          inherit
            pkgs
            treefmtCfg
            self
            system
            ;
        };
      }
    )
    // inputs.flake-utils.lib.eachDefaultSystemPassThrough (
      system:
      let
        user = "rithvij";
        uzer = "rithviz";
        droid = "nix-on-droid";
        liveuser = "nixos";

        linuxhost = "iron";
        hostdroid = "localhost"; 
        livehost = "nixos";

        pkgs = allSystemsJar.pkgs.${system};

        hmAliasModules = (import ./home/applications/special.nix { inherit pkgs; }).aliasModules;
        homeConfig =
          {
            username,
            hostname ? null,
            modules ? [ ],
            system ? "x86_64-linux",
          }:
          inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./home/users/${username} ] ++ modules ++ hmAliasModules;
            
            extraSpecialArgs = {
              flake-inputs = inputs;
              inherit system;
              inherit username;
              inherit hostname;
            };
          };
        nix-index-hm-modules = [
          inputs.nix-index-database.hmModules.nix-index
          { programs.nix-index-database.comma.enable = true; }
        ];
        common-hm-modules = [
          inputs.sops-nix.homeManagerModules.sops
        ];
        grm = inputs.git-repo-manager.packages.${system}.default;
        hm = inputs.home-manager.packages.${system}.default;
        sysm = inputs.system-manager.packages.${system}.default;
        toolsModule = {
          environment.systemPackages = [
            hm
            grm
            sysm
            
          ];
        };
        overlayModule = {
          nixpkgs.overlays = allSystemsJar.overlays.${system};
        };
        nixosSystem = import (allSystemsJar.nixpkgs'.${system} + "/nixos/lib/eval-config.nix");
      in
      {
        schemas = (builtins.removeAttrs inputs.flake-schemas.schemas [ "schemas" ]) // {
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
            
            
            extraSpecialArgs = { inherit pkgs; };
          };
          
          vps = inputs.system-manager.lib.makeSystemConfig {
            modules = [ ./hosts/sysm/vps/configuration.nix ];
            extraSpecialArgs = { inherit pkgs; };
          };
        };
        homeConfigurations = {
          
          "${user}@${linuxhost}" = homeConfig {
            username = user;
            hostname = linuxhost;
            modules = nix-index-hm-modules ++ common-hm-modules;
            inherit system;
          };
          
          ${uzer} = homeConfig {
            username = uzer;
            modules = nix-index-hm-modules ++ common-hm-modules;
            inherit system;
          };
          
          "${droid}@${hostdroid}" = homeConfig {
            username = droid;
            hostname = hostdroid;
            system = "aarch64-linux";
          };
          
          "${liveuser}@${livehost}" = homeConfig {
            username = liveuser;
            hostname = livehost;
            modules = common-hm-modules;
            inherit system;
          };
          
          "runner" = homeConfig {
            username = "runner";
            hostname = "_______";
            modules = nix-index-hm-modules ++ common-hm-modules;
            inherit system;
          };
        };
        nixosConfigurations = {
          defaultIso = nixosSystem {
            inherit system;
            specialArgs = {
              flake-inputs = inputs;
            };
            modules = [
              toolsModule
              overlayModule
              inputs.sops-nix.nixosModules.sops
              
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.nixos = ./home/users/nixos;
                  extraSpecialArgs = {
                    flake-inputs = inputs;
                    username = liveuser;
                    hostname = livehost;
                  };
                  sharedModules = common-hm-modules ++ hmAliasModules;
                };
              }
              ./hosts/nixos/iso.nix
            ];
          };
          ${linuxhost} = nixosSystem {
            inherit system;
            inherit pkgs;
            modules = [
              toolsModule
              overlayModule
              inputs.sops-nix.nixosModules.sops
              inputs.niri.nixosModules.niri
              ./hosts/${linuxhost}/configuration.nix
            ];
            specialArgs = {
              flake-inputs = inputs;
              inherit system; 
              username = user;
              hostname = linuxhost;
            };
          };
          wsl = nixosSystem {
            inherit system;
            modules = [
              toolsModule
              overlayModule
              inputs.sops-nix.nixosModules.sops
              inputs.nixos-wsl.nixosModules.default
              ./hosts/wsl/configuration.nix
              
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.nixos = ./home/users/nixos;
                  extraSpecialArgs = {
                    flake-inputs = inputs;
                    username = liveuser; 
                    hostname = livehost;
                  };
                  sharedModules = common-hm-modules ++ hmAliasModules;
                };
              }
            ];
            specialArgs = {
              flake-inputs = inputs;
              inherit system; 
              username = "nixos";
              hostname = "nixos";
            };
          };
        };
        nixOnDroidConfigurations =
          let
            mdroid = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
              inherit pkgs;
              extraSpecialArgs = {
                flake-inputs = inputs;
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

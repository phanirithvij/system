{
  inputs = {
    # THIS is dumb unless nixpkgs is based on nixos-unstable
    # useful for git bisecting
    #nixpkgs.url = "git+file:///shed/Projects/nixhome/nixpkgs?shallow=1";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    #nur-pkgs.url = "git+file:///shed/Projects/nur-packages";
    nur-pkgs.url = "github:phanirithvij/nur-packages/master";
    #shouldn't be used as cachix cache becomes useless
    #nur-pkgs.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:phanirithvij/home-manager/espanso-wl-no-pr";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    system-manager = {
      #url = "git+file:///shed/Projects/nixer/learn/numtide/system-manager";
      url = "github:numtide/system-manager/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrapper-manager.url = "github:viperML/wrapper-manager/master";
    wrapper-manager.inputs.nixpkgs.follows = "nixpkgs";

    git-repo-manager = {
      url = "github:hakoerber/git-repo-manager/develop";
      inputs.crane.follows = "crane";
      inputs.flake-utils.follows = "flake-utils";
      inputs.rust-overlay.follows = "rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # git-worktree helper
    git-prole = {
      url = "github:9999years/git-prole/main";
      inputs.systems.follows = "systems";
      inputs.crane.follows = "crane";
      inputs.rust-overlay.follows = "rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/master";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix client with schema support: see https://github.com/NixOS/nix/pull/8892
    flake-schemas.url = "github:DeterminateSystems/flake-schemas/main";

    sops-nix.url = "github:Mic92/sops-nix/master";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    navi_config.url = "github:phanirithvij/navi/main";
    navi_config.flake = false;

    nix-index-database.url = "github:nix-community/nix-index-database/main";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&ref=main";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";
    niri.inputs.nixpkgs-stable.follows = "nixpkgs-stable";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks.inputs.nixpkgs-stable.follows = "nixpkgs-stable";

    #systems.url = "github:nix-systems/default-linux";
    systems.url = "github:nix-systems/default";

    crane.url = "github:ipetkov/crane";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      ...
    }@inputs:
    let
      allSystemsJar = inputs.flake-utils.lib.eachDefaultSystem (system: rec {
        legacyPackages = inputs.nixpkgs.legacyPackages.${system};
        inherit (legacyPackages) lib;
        #pkgs = import inputs.nixpkgs {
        #pkgs = import nixpkgs' {
        pkgs = import (if (system == "x86_64-linux") then nixpkgs' else inputs.nixpkgs) {
          inherit overlays system;
          config = {
            # allowlist of unfree pkgs, for home-manager too
            # https://github.com/viperML/dotfiles/blob/43152b279e609009697346b53ae7db139c6cc57f/packages/default.nix#L64
            allowUnfreePredicate =
              pkg:
              let
                pname = lib.getName pkg;
                byName = builtins.elem pname [
                  "steam-unwrapped"
                  "spotify"
                ];
              in
              if byName then lib.warn "Allowing unfree package: ${pname}" true else false;

            packageOverrides = _: {
              # TODO espanso_wayland and espanso-x11 and use it in different places accordingly?
              # made a pr to home-manager see https://github.com/nix-community/home-manager/pull/5930
              /*
                espanso = pkgs.espanso.override {
                  x11Support = false;
                  waylandSupport = true;
                };
              */
            };
          };
        };
        # https://discourse.nixos.org/t/tips-tricks-for-nixos-desktop/28488/14
        nixpkgs' = legacyPackages.applyPatches {
          name = "nixpkgs-patched";
          src = inputs.nixpkgs;
          patches =
            [
              ./opengist-module.patch
            ]
            ++ builtins.map legacyPackages.fetchpatch2 [
              {
                url = "https://github.com/NixOS/nixpkgs/pull/364606.diff";
                hash = "sha256-FOoq//PnN1yGX6oyYmS7GDARdJEAxpJHUTuFs92nRhI=";
              }
            ];
        };
        overlays =
          (import ./lib/overlays {
            inherit system;
            flake-inputs = inputs;
          })
          ++ [ inputs.niri.overlays.niri ]
          ++ (builtins.attrValues
            (import "${inputs.nur-pkgs}" {
              # pkgs here is not being used in nur-pkgs overlays
              #inherit pkgs;
            }).overlays
          )
          ++ [
            # wrappedPkgs imported into pkgs as pkgs.wrappedPkgs
            # no need to pass them around
            (_: _: {
              inherit wrappedPkgs;
            })
          ];
        wrappedPkgs = import ./pkgs/wrapped-pkgs {
          inherit pkgs system;
          flake-inputs = inputs;
        };
      });
    in
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = allSystemsJar.pkgs.${system};
        treefmtCfg = (inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix).config.build;
        grm = inputs.git-repo-manager.packages.${system}.default;
        hm = inputs.home-manager.packages.${system}.default;
        sysm = inputs.system-manager.packages.${system}.default;
        nix-schema = pkgs.nix-schema { inherit system; }; # nur-pkgs overlay, cachix cache
      in
      rec {
        apps = {
          nix = {
            type = "app";
            program = "${nix-schema}/bin/nix-schema";
          };
        };
        packages = {
          inherit nix-schema;
          navi-master = pkgs.navi;
          git-repo-manager = grm;
          home-manager = hm;
          system-manager = sysm;
        } // allSystemsJar.wrappedPkgs.${system};
        formatter = treefmtCfg.wrapper;
        checks = {
          formatting = treefmtCfg.check self;
          git-hooks-check = inputs.git-hooks.lib.${system}.run {
            src = ./.;
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
                  # if all are md files, skip ci
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
        hostdroid = "localhost"; # not possible to change it
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
            modules = [ ./home/${username} ] ++ modules ++ hmAliasModules;
            # TODO sharedModules sops
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
            (pkgs.nix-schema { inherit system; })
          ];
        };
        overlayModule = {
          nixpkgs.overlays = allSystemsJar.overlays.${system};
        };

        #inherit (inputs.nixpkgs.lib) nixosSystem;
        # https://discourse.nixos.org/t/tips-tricks-for-nixos-desktop/28488/14
        # IFD BAD BAD AAAAAA!
        # only option is to maintain a fork of nixpkgs as of now
        # follow https://github.com/NixOS/nix/issues/3920
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
          };
          vps = inputs.system-manager.lib.makeSystemConfig {
            modules = [ ./hosts/sysm/vps/configuration.nix ];
          };
        };
        homeConfigurations = {
          # nixos main
          "${user}@${linuxhost}" = homeConfig {
            username = user;
            hostname = linuxhost;
            modules = nix-index-hm-modules ++ common-hm-modules;
            inherit system;
          };
          # non-nixos linux
          ${uzer} = homeConfig {
            username = uzer;
            modules = nix-index-hm-modules ++ common-hm-modules;
            inherit system;
          };
          # nix-on-droid
          "${droid}@${hostdroid}" = homeConfig {
            username = droid;
            hostname = hostdroid;
            system = "aarch64-linux";
          };
          # nixos live user
          "${liveuser}@${livehost}" = homeConfig {
            username = liveuser;
            hostname = livehost;
            modules = common-hm-modules;
            inherit system;
          };
          # TODO different repo with npins?
          "runner" = homeConfig {
            username = "runner";
            hostname = "_______";
            modules = nix-index-hm-modules ++ common-hm-modules;
            inherit system;
          };
        };
        nixosConfigurations = {
          ${linuxhost} = nixosSystem {
            inherit system;
            modules = [
              toolsModule
              overlayModule
              inputs.sops-nix.nixosModules.sops
              inputs.niri.nixosModules.niri
              ./hosts/${linuxhost}/configuration.nix
            ];
            specialArgs = {
              flake-inputs = inputs;
              inherit system; # TODO needed?
              username = user;
              hostname = linuxhost;
            };
          };
          defaultIso = nixosSystem rec {
            inherit system;
            specialArgs = {
              flake-inputs = inputs;
            };
            modules = [
              inputs.sops-nix.nixosModules.sops
              inputs.home-manager.nixosModules.home-manager
              toolsModule
              overlayModule
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.nixos = ./home/nixos;
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
        };
        # keep all nix-on-droid hosts in same state
        nixOnDroidConfigurations = rec {
          default = mdroid;
          mdroid = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              flake-inputs = inputs;
              hmSharedModules = hmAliasModules;
            };
            modules = [ ./hosts/nod ];
          };
        };
      }
    );
}

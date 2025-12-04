{
  inputs = {
    # THIS is dumb unless nixpkgs is based on nixos-unstable
    # TODO checkout https://github.com/blitz/hydrasect
    # useful for git bisecting, use path:/abs/path instead for the same
    #nixpkgs.url = "git+file:///shed/Projects/nixhome/nixpkgs/nixos-unstable?shallow=1";
    nixpkgs.url = "github:phanirithvij/nixpkgs/nixos-patched"; # managed via nix-patcher
    nixpkgs-upstream.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-patcher.url = "github:phanirithvij/nixpkgs-patcher/main";

    #nur-pkgs.url = "git+file:///shed/Projects/nur-packages";
    nur-pkgs.url = "github:phanirithvij/nur-packages/master";
    nur-pkgs.inputs.nix-update.follows = "nix-update";
    #follows shouldn't be used as cachix cache becomes useless
    #nur-pkgs.inputs.nixpkgs.follows = "nixpkgs";
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

    nixdroidpkgs-upstream.url = "github:horriblename/nixdroidpkgs/main";
    nixdroidpkgs-upstream.inputs.nixpkgs.follows = "nixpkgs";
    nixdroidpkgs-upstream.inputs.termux-auth.follows = "";
    nixdroidpkgs-upstream.inputs.termux-packages.follows = "";
    nixdroidpkgs.url = "github:phanirithvij/nixdroidpkgs/patched"; # nix-patcher
    nixdroidpkgs.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrapper-manager.url = "github:viperML/wrapper-manager/master";

    # lazy-apps.url = "sourcehut:~rycee/lazy-apps"; # upstream
    # lazy-apps.url = "git+file:///shed/Projects/nixer/core/lazy-apps?shallow=1";
    lazy-apps.url = "github:phanirithvij/lazy-apps/master"; # hard fork
    lazy-apps.inputs.nixpkgs.follows = "nixpkgs";
    lazy-apps.inputs.pre-commit-hooks.follows = "git-hooks";

    sops-nix.url = "github:Mic92/sops-nix/master";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

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

    ###### PATCHES #######

    ### nix-patcher patches

    # follow https://github.com/NixOS/nix/issues/3920

    ## NOTE
    ## nix-patcher fails to work due to various reasons
    ##   I fixed some issues in https://github.com/phanirithvij/nix-patcher
    ##   as well as https://github.com/phanirithvij/patch2pr

    # losslesscut pr
    nixpkgs-patch-385535.url = "https://github.com/NixOS/nixpkgs/pull/385535.patch?full_index=1";
    nixpkgs-patch-385535.flake = false;
    # octotail package (mine)
    nixpkgs-patch-419929.url = "https://github.com/NixOS/nixpkgs/pull/419929.patch?full_index=1";
    nixpkgs-patch-419929.flake = false;

    # TODO disabling for now because of rl-2511 notes conflict
    # opengist module (mine, its complex with createDBLocal etc.)
    #nixpkgs-patch-10.url = "https://github.com/phanirithvij/nixpkgs/commit/34be2e80d57c2fb93ece547d9b28947ae56cac92.patch?full_index=1";
    #nixpkgs-patch-10.flake = false;

    home-manager-patch-10.url = ./home/patches/docs-manpages-parallel.patch;
    home-manager-patch-10.flake = false;

    nixdroidpkgs-patch-01.url = ./hosts/nod/patches/nixdroidpkgs-flake-update.patch;
    nixdroidpkgs-patch-01.flake = false;

    ### end nix-patcher patches

    ### nixpkgs-patcher patches

    # TODO review https://github.com/NixOS/nixpkgs/pull/428674
    # opengist module (new)
    #pr-428674-nixpkgs-patch.url = "https://github.com/NixOS/nixpkgs/pull/428674.patch?full_index=1";
    #pr-428674-nixpkgs-patch.flake = false;

    ### end nixpkgs-patcher patches

    ###### END PATCHES #######

    # nix client with schema support: see https://github.com/NixOS/nix/pull/8892
    flake-schemas.url = "github:DeterminateSystems/flake-schemas/main";

    # https://github.com/hyprwm/Hyprland/issues/9314#issuecomment-2634051281
    hyprland.url = "https://github.com/hyprwm/Hyprland.git";
    hyprland.type = "git";
    hyprland.submodules = true; # inputs.self.submodules exists, and inputs.xxx.submodules is only for type git?
    # as per https://github.com/mightyiam/input-branches#the-setup
    # that thing also has issues, https://github.com/NixOS/nix/issues/13571
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&ref=main"; # FIXME doesn't work with nix-patcher
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.inputs.pre-commit-hooks.follows = "git-hooks";

    niri.url = "github:sodiboo/niri-flake/main";
    niri.inputs.nixpkgs.follows = "nixpkgs";
    niri.inputs.nixpkgs-stable.follows = "nixpkgs-stable";

    ### Indirect dependencies, dedup

    #systems.url = "github:nix-systems/default-linux/main";
    systems.url = "github:nix-systems/default/main";

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

  # TODO some overlay for fzf with this patch applied
  # https://github.com/junegunn/fzf/pull/3918/files

  outputs =
    inputs:
    let
      getFlakeInputs = system: inputs // { nixpkgs' = allSystemsJar.nixpkgs'.${system}; };
      allSystemsJar = inputs.flake-utils.lib.eachDefaultSystem (
        system:
        let
          inherit (legacyPackages) lib;
          args = {
            inherit pkgs system lib;
            flake-inputs = inputs // {
              inherit (patched) nixpkgs';
            };
          };
          legacyPackages = inputs.nixpkgs.legacyPackages.${system};
          wrappedPkgs = import ./pkgs/wrapped-pkgs args;
          binaryPkgs = import ./pkgs/binary args;
          boxxyPkgs = import ./pkgs/boxxy args;
          lazyPkgs = import ./pkgs/lazy args;
          nurPkgs = import ./pkgs/nurpkgs.nix (
            args
            // {
              # 2nd nixpkgs evaluation, override pkgs
              pkgs = import inputs.nur-pkgs.inputs.nixpkgs {
                inherit system;
                config = {
                  allowUnfreePredicate =
                    pkg:
                    let
                      pname = lib.getName pkg;
                      byName = builtins.elem pname [
                        "textual-window"
                        "pendulum"
                      ];
                    in
                    if byName then lib.warn "NurPkgs allowing unfree package: ${pname}" true else false;
                };
              };
            }
          );
          nvidia-offload = import ./pkgs/nvidia-offload.nix args;

          # so nixpkgs-patcher
          # PROS:
          # - handles system arg
          # - can cram in flake inputs to auto track hashes
          # - supports fetchpatch2 supplied patches instead of cramming patches in flake inputs
          patched = inputs.nixpkgs-patcher.lib {
            nixpkgsPatcher.inputs = inputs;
            nixpkgsPatcher.patchInputRegex = ".*-nixpkgs-patch$"; # default: "^nixpkgs-patch-.*"
            modules = [ { nixpkgs.hostPlatform = system; } ]; # without this, impure will be required
          };

          pkgs = import patched.nixpkgs' {
            inherit system overlays;
            config = {
              nvidia.acceptLicense = true;
              # allowlist of unfree pkgs, for home-manager too
              # https://github.com/viperML/dotfiles/blob/43152b279e609009697346b53ae7db139c6cc57f/packages/default.nix#L64
              # TODO these warnings should ideally be in nixpkgs itself (allow disabling viewing traces)
              # TODO before that, why is eval done 3 times (try nh home switch)?
              allowUnfreePredicate =
                pkg:
                let
                  pname = lib.getName pkg;
                  byName = builtins.elem pname [
                    "spotify" # in lazyapps used in home-manager
                    "hplip" # printer
                    "nvidia-x11"
                    "cloudflare-warp"
                    "nvidia-persistenced"
                    "plexmediaserver"
                    "p7zip"
                    "steam"
                    "steam-unwrapped"
                    "honey-home"
                    "nvidia-settings"
                  ];
                in
                if byName then lib.warn "Allowing unfree package: ${pname}" true else false;
              allowInsecurePredicate =
                pkg:
                let
                  name = "${lib.getName pkg}-${lib.getVersion pkg}";
                  byName = builtins.elem name [
                    "beekeeper-studio-5.3.4" # Electron version 31 is EOL, hm
                  ];
                in
                if byName then lib.warn "Allowing insecure package: ${name}" true else false;

              packageOverrides = _: {
                # No need to do this anymore
                # A pr to home-manager for better default behavior was merged a while ago
                # see https://github.com/nix-community/home-manager/pull/5930
                /*
                  espanso = pkgs.espanso.override {
                    x11Support = false;
                    waylandSupport = true;
                  };
                */
              };
            };
          };

          overlays =
            (import ./lib/overlays {
              inherit system;
              flake-inputs = inputs // {
                inherit (patched) nixpkgs';
              };
            })
            ++ [ inputs.niri.overlays.niri ]
            ++ (builtins.attrValues
              (import "${inputs.nur-pkgs}" {
                # pkgs here is not being used in nur-pkgs overlays
                #inherit pkgs; # WIP maybe get overlays from nurPkgs.overlays?
              }).overlays
            )
            ++ [
              # wrappedPkgs imported into pkgs as pkgs.wrappedPkgs
              # no need to pass them around
              (final: prev: {
                inherit wrappedPkgs;
                inherit lazyPkgs;
                inherit nurPkgs;
                inherit boxxyPkgs;
                inherit binaryPkgs;
                inherit nvidia-offload;
                lib = prev.lib // {
                  mine = {
                    unNestAttrs = import ./lib/unnest.nix { inherit pkgs; };
                    GPUOffloadApp = final.callPackage ./lib/gpu-offload.nix { };
                  };
                };
              })
            ];
        in
        {
          # nixpkgs overlays to lib don't apply, need to re-add them
          # home-manager lib is required to use lib.mine in home-manager config
          # https://github.com/nix-community/home-manager/issues/5980
          hmlib = pkgs.lib.extend (_: _: inputs.home-manager.lib // { inherit (pkgs.lib) mine; });
          inherit
            pkgs
            overlays
            wrappedPkgs
            binaryPkgs
            boxxyPkgs
            lazyPkgs
            nurPkgs
            nvidia-offload
            ;
          inherit (patched) nixpkgs' args';
        }
      );
    in
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = allSystemsJar.pkgs.${system};
        inherit (pkgs) lib;
        treefmtCfg =
          (inputs.treefmt-nix.lib.evalModule pkgs (import ./treefmt.nix { inherit pkgs; })).config.build;
        hm = inputs.home-manager.packages.${system}.default;
        sysm = inputs.system-manager.packages.${system}.default;
        nixp = inputs.nix-patcher.packages.${system}.nix-patcher;
        nh' = allSystemsJar.nurPkgs.${system}.nh;
        nom' = allSystemsJar.nurPkgs.${system}.flakePkgs.nix-output-monitor;
        #nix-schema = pkgs.nix-schema { inherit system; }; # nur-pkgs overlay, cachix cache

        lazyApps = lib.mine.unNestAttrs allSystemsJar.lazyPkgs.${system};
      in
      {
        inherit lazyApps allSystemsJar;
        apps = {
          /*
            nix = {
              type = "app";
              program = "${nix-schema}/bin/nix-schema";
            };
          */
        };
        packages =
          let
            _pkgs = {
              #inherit nix-schema;
              navi-master = pkgs.navi;
              home-manager = hm;
              # TODO optional if system is linux
              system-manager = sysm;
              nix-patcher = nixp;
              nvidia-offload = allSystemsJar.nvidia-offload.${system};
            }
            // lazyApps
            // allSystemsJar.wrappedPkgs.${system}
            // allSystemsJar.boxxyPkgs.${system}
            // allSystemsJar.binaryPkgs.${system}
            // (lib.filterAttrs (_: v: lib.isDerivation v && !(v ? meta && v.meta.broken)) (
              lib.mine.unNestAttrs allSystemsJar.nurPkgs.${system}
            ));
          in
          _pkgs;

        inherit pkgs inputs; # just for inspection

        # NEVER ever run `nix fmt` run `treefmt`
        #formatter = treefmtCfg.wrapper;
        checks = {
          formatting = treefmtCfg.check inputs.self;
          git-hooks-check = inputs.git-hooks.lib.${system}.run {
            src = lib.cleanSource ./.;
            hooks = {
              # ideally the formatting check from above can be used but they don't really go together
              # one can do nix build .#checks.system.formatting but that is beyond slow
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
            packages = inputs.self.checks.${system}.git-hooks-check.enabledPackages; # these don't show up in menu
            extraCommands = [ ]; # should be in the format list of attrs devshell expects
            devshell = import inputs.devshell { nixpkgs = pkgs; };
          }).shell.overrideAttrs # devshell is a `derivation` which has no overrideAttrs (it is an stdenv.mkdrv thing)
            (o: {
              name = "system";
              shellHook = o.shellHook + inputs.self.checks.${system}.git-hooks-check.shellHook;
            });
      }
    )
    // (
      let
        # Previously I used flake-utils.eachDefaultSystemPassThrough
        # but that functions in a way
        #  which allows only the last entry in the `defaultSystems` defined in flake-utils is used
        # and even with --impure, on aarch64-linux there is a check https://github.com/numtide/flake-utils/pull/119/files#diff-25f00f391a440414afdc84d7191b5892db3492e1c0b9a45f9063be83e21d75e4R55
        # which lets aarch64-linux to be in the defaultSystems[3] and not last one in the list
        # TODO follow https://github.com/NixOS/nix/issues/3843
        system = builtins.currentSystem or "x86_64-linux";

        user = "rithvij";
        uzer = "rithviz";
        droid = "nix-on-droid";
        liveuser = "nixos";

        linuxhost = "iron";
        hostdroid = "localhost"; # not possible to change it
        livehost = "nixos";

        pkgs = allSystemsJar.pkgs.${system};
        nixpkgs' = allSystemsJar.nixpkgs'.${system};
        args' = allSystemsJar.args'.${system};

        nixosSystem = import (nixpkgs' + "/nixos/lib/eval-config.nix");

        hmAliasModules = (import ./home/applications/alias-groups.nix { inherit pkgs; }).aliasModules;
        homeConfig =
          {
            username,
            hostname ? null,
            modules ? [ ],
            system ? "x86_64-linux",
          }:
          inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = allSystemsJar.pkgs.${system};
            modules = [ ./home/users/${username} ] ++ modules ++ hmAliasModules;
            # TODO sharedModules sops
            extraSpecialArgs = {
              flake-inputs = getFlakeInputs system;
              lib = allSystemsJar.hmlib.${system};
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
        sysm = inputs.system-manager.packages.${system}.default;
        toolsModule = {
          environment.systemPackages = [
            hm
            sysm
            #(pkgs.nix-schema { inherit system; })
          ];
        };
        overlayModule = {
          nixpkgs.overlays = allSystemsJar.overlays.${system};
        };
        versionModule = {
          # NOTE: these while good to have, will FOR SURE rebuild the whole system for every new commit in nixpkgs and current repo respectively
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
            overlays = allSystemsJar.overlays.${system};
            extraSpecialArgs = {
              inherit (pkgs) lib; # for GPUOffloadApp
              # NOTE and TODO:
              # system-manager likely needs nixGL not nvidia-offload
              # home-manager also has some nixGL stuff
              # nixGL also has alternatives https://github.com/soupglasses/nix-system-graphics#comparison-table
            };
          };
          # TODO rename vps
          vps = inputs.system-manager.lib.makeSystemConfig {
            modules = [ ./hosts/sysm/vps/configuration.nix ];
            overlays = allSystemsJar.overlays.${system};
            extraSpecialArgs = {
              inherit (pkgs) lib;
            };
          };
        };
        homeConfigurations = {
          # nixos main
          ${user} = homeConfig {
            username = user;
            hostname = linuxhost;
            modules = nix-index-hm-modules ++ common-hm-modules;
            inherit system;
          };
          # non-nixos linux
          ${uzer} = homeConfig {
            username = uzer;
            hostname = linuxhost;
            modules = nix-index-hm-modules ++ common-hm-modules;
            inherit system;
          };
          # nix-on-droid
          "${droid}@${hostdroid}" = homeConfig {
            username = droid;
            hostname = "nod"; # NOTE: nod = nix-on-droid, not the real hostname (it is localhost i.e. ${hostdroid})
            modules = common-hm-modules;
            system = builtins.currentSystem or "aarch64-linux";
          };
          # nixos live user
          "${liveuser}@${livehost}" = homeConfig {
            username = liveuser;
            hostname = livehost;
            modules = common-hm-modules;
            inherit system;
          };
          # TODO different repo with npins?
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
              # home-manager baked in
              inputs.home-manager.nixosModules.home-manager
              inputs.lazy-apps.nixosModules.default
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.nixos = ./home/users/nixos;
                  extraSpecialArgs = {
                    lib = allSystemsJar.hmlib.${system};
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
                # prevent the patched nixpkgs from gc as well, not just flake inputs
                system.extraDependencies = [ nixpkgs' ];
              }
            ]
            ++ args'.modules;
            specialArgs = {
              inherit (pkgs) lib;
              flake-inputs = getFlakeInputs system;
              inherit system; # TODO needed?
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
              # home-manager baked in
              inputs.home-manager.nixosModules.home-manager
              inputs.lazy-apps.nixosModules.default
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.nixos = ./home/users/nixos;
                  extraSpecialArgs = {
                    lib = allSystemsJar.hmlib.${system};
                    flake-inputs = getFlakeInputs system;
                    username = liveuser; # TODO wsl separate home config
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
              inherit system; # TODO needed?
              username = "nixos";
              hostname = "nixos";
            };
          };
        };
        # keep all nix-on-droid hosts in same state
        # TODO host level customisations and hostvars
        nixOnDroidConfigurations =
          let
            system = builtins.currentSystem or "aarch64-linux";
            mdroid = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
              pkgs = allSystemsJar.pkgs.${system};
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

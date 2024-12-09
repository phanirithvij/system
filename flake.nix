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
    nix-schema = {
      url = "github:DeterminateSystems/nix-src/flake-schemas";
      inputs.flake-schemas.follows = "flake-schemas";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.follows = "git-hooks";
    };

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

    systems.url = "github:nix-systems/default-linux";

    crane.url = "github:ipetkov/crane";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      system-manager,
      git-repo-manager,
      nix-on-droid,
      sops-nix,
      treefmt-nix,
      git-hooks,
      nix-index-database,
      niri,
      nur-pkgs,
      ...
    }@inputs:
    let
      user = "rithvij";
      uzer = "rithviz";
      droid = "nix-on-droid";
      liveuser = "nixos";

      host = "iron";
      hozt = "rithviz-inspiron7570";
      hostdroid = "localhost"; # not possible to change it
      livehost = "nixos";

      system = "x86_64-linux";
      pkgsF =
        nixpkgs:
        import nixpkgs {
          inherit overlays system;
          config = {
            allowUnfree = true;
            # TODO allowlist of unfree pkgs, for home-manager too
            allowUnfreePredicate = _: true;
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
      pkgs = pkgsF nixpkgs;
      pkgs' = pkgsF nixpkgs';

      # https://discourse.nixos.org/t/tips-tricks-for-nixos-desktop/28488/14
      patches = [
        ./opengist-module.patch
      ] ++ builtins.map pkgs.fetchpatch2 [ ];
      nixpkgs' = pkgs.applyPatches {
        name = "nixpkgs-patched";
        src = inputs.nixpkgs;
        inherit patches;
      };
      # IFD BAD BAD AAAAAA!
      # only option is to maintain a fork of nixpkgs as of now
      # follow https://github.com/NixOS/nix/issues/3920
      nixosSystem = import (nixpkgs' + "/nixos/lib/eval-config.nix");

      #inherit (inputs.nixpkgs.lib) nixosSystem;
      overlays =
        (import ./lib/overlays {
          inherit system;
          flake-inputs = inputs;
        })
        ++ [ niri.overlays.niri ]
        ++ (builtins.attrValues
          (import "${nur-pkgs}" {
            # pkgs here is not being used in nur-pkgs overlays
            #inherit pkgs;
          }).overlays
        )
        ++ [
          # wrappedPkgs imported into pkgs.wrappedPkgs
          # no need to pass them around
          (_: _: {
            inherit wrappedPkgs;
          })
        ];

      wrappedPkgs = import ./pkgs/wrapped-pkgs {
        inherit pkgs system;
        flake-inputs = inputs;
      };

      hmAliasModules = (import ./home/applications/special.nix { inherit pkgs; }).aliasModules;
      homeConfig =
        {
          username,
          hostname,
          modules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs';
          modules = [ ./home/${username} ] ++ modules ++ hmAliasModules;
          # TODO sharedModules sops
          extraSpecialArgs = {
            flake-inputs = inputs;
            inherit system;
            inherit username;
            inherit hostname;
          };
        };
      treefmtCfg = (treefmt-nix.lib.evalModule pkgs ./treefmt.nix).config.build;
      nix-index-hm-modules = [
        inputs.nix-index-database.hmModules.nix-index
        { programs.nix-index-database.comma.enable = true; }
      ];
      common-hm-modules = [
        inputs.sops-nix.homeManagerModules.sops
      ];
      grm = git-repo-manager.packages.${system}.default;
      hm = home-manager.packages.${system}.default;
      sysm = system-manager.packages.${system}.default;
      toolsModule = {
        environment.systemPackages = [
          hm
          grm
          sysm
          #pkgs.nix-schema
        ];
      };
      overlayModule = {
        nixpkgs.overlays = overlays;
      };
    in
    rec {
      inherit (inputs.flake-schemas) schemas;
      apps.${system} = {
        nix = {
          type = "app";
          program = "${pkgs.nix-schema}/bin/nix-schema";
        };
      };
      apps."aarch64-linux".nix = apps.${system}.nix;
      packages.${system} = {
        #inherit (pkgs) nix-schema;
        navi-master = pkgs.navi;
        git-repo-manager = grm;
        home-manager = hm;
        system-manager = sysm;
      } // wrappedPkgs;
      homeConfigurations = {
        # nixos main
        "${user}@${host}" = homeConfig {
          username = user;
          hostname = host;
          modules = nix-index-hm-modules ++ common-hm-modules;
        };
        # non-nixos
        "${uzer}@${hozt}" = homeConfig {
          username = uzer;
          hostname = hozt;
          modules = nix-index-hm-modules ++ common-hm-modules;
        };
        # nix-on-droid
        "${droid}@${hostdroid}" = homeConfig {
          username = droid;
          hostname = hostdroid;
        };
        # nixos live user
        "${liveuser}@${livehost}" = homeConfig {
          username = liveuser;
          hostname = livehost;
          modules = common-hm-modules;
        };
        # TODO different repo with npins?
        "runner" = homeConfig {
          username = "runner";
          hostname = "_______";
          modules = nix-index-hm-modules ++ common-hm-modules;
        };
      };
      nixosConfigurations = {
        ${host} = nixosSystem {
          inherit system;
          modules = [
            toolsModule
            overlayModule
            sops-nix.nixosModules.sops
            niri.nixosModules.niri
            ./hosts/${host}/configuration.nix
          ];
          specialArgs = {
            flake-inputs = inputs;
            inherit system;
            username = user;
            hostname = host;
          };
        };

        defaultIso = nixosSystem {
          inherit system;
          specialArgs = {
            flake-inputs = inputs;
          };
          modules = [
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            toolsModule
            overlayModule
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.nixos = ./home/nixos;
                extraSpecialArgs = {
                  flake-inputs = inputs;
                  username = "nixos";
                  hostname = "nixos";
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
        mdroid = nix-on-droid.lib.nixOnDroidConfiguration {
          extraSpecialArgs = {
            flake-inputs = inputs;
          };
          modules = [ ./hosts/nod ];
        };
      };
      inherit (system-manager.lib) makeSystemConfig;
      systemConfigs = rec {
        default = gha;
        gha = makeSystemConfig {
          modules = [ ./hosts/sysm/gha/configuration.nix ];
        };
        vps = makeSystemConfig { modules = [ ./hosts/sysm/vps/configuration.nix ]; };
      };
      formatter.${system} = treefmtCfg.wrapper;
      checks.${system} = {
        formatting = treefmtCfg.check self;
        git-hooks-check = git-hooks.lib.${system}.run {
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

      devShells.${system}.default = import ./flake/shell.nix {
        inherit
          pkgs
          treefmtCfg
          self
          system
          ;
      };
      # TODO broken
      #devShells."aarch64-linux".default = import ./flake/shellaarch.nix { inherit pkgs; };
    };
}

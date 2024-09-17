{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    blobdrop.url = "github:vimpostor/blobdrop";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    system-manager = {
      url = "github:numtide/system-manager";
      inputs.crane.follows = "crane";
      inputs.flake-utils.follows = "flake-utils";
      inputs.rust-overlay.follows = "rust-overlay";
      inputs.treefmt-nix.follows = "treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.follows = "git-hooks";
    };

    git-repo-manager = {
      url = "github:hakoerber/git-repo-manager";
      inputs.crane.follows = "crane";
      inputs.flake-utils.follows = "flake-utils";
      inputs.rust-overlay.follows = "rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-23.11";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix client with schema support: see https://github.com/NixOS/nix/pull/8892
    flake-schemas.url = "github:DeterminateSystems/flake-schemas";
    nix-schema = {
      url = "github:DeterminateSystems/nix-src/flake-schemas";
      inputs.flake-schemas.follows = "flake-schemas";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.follows = "git-hooks";
    };

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.inputs.nixpkgs-stable.follows = "";

    navi_config.url = "github:phanirithvij/navi";
    navi_config.flake = false;

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks.inputs.nixpkgs-stable.follows = "";

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
      blobdrop,
      home-manager,
      system-manager,
      git-repo-manager,
      nix-on-droid,
      sops-nix,
      treefmt-nix,
      git-hooks,
      nix-index-database,
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
      pkgs = import nixpkgs {
        inherit overlays system;
        config = {
          allowUnfree = true;
          # TODO allowlist of unfree pkgs, for home-manager too
          allowUnfreePredicate = _: true;
          packageOverrides = pkgs: {
            espanso = pkgs.espanso.override {
              x11Support = true;
              waylandSupport = false;
            };
          };
        };
      };
      overlays = import ./lib/overlays {
        inherit system;
        flake-inputs = inputs;
      };
      homeConfig =
        {
          username,
          hostname,
          modules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/${username} ] ++ modules;
          # TODO sharedModules sops
          extraSpecialArgs = {
            flake-inputs = inputs;
            inherit username;
            inherit hostname;
          };
        };
      treefmtCfg = (treefmt-nix.lib.evalModule pkgs ./treefmt.nix).config.build;
      nix-index-hm-modules = [
        inputs.nix-index-database.hmModules.nix-index
        { programs.nix-index-database.comma.enable = true; }
      ];
      common-hm-modules = [ inputs.sops-nix.homeManagerModules.sops ];
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
      };
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
        };
        # TODO different repo with npins?
        "runner" = homeConfig {
          username = "runner";
          hostname = "_______";
          modules = nix-index-hm-modules ++ common-hm-modules;
        };
      };
      nixosConfigurations = {
        ${host} = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            { environment.systemPackages = [ blobdrop.packages.${system}.default ]; }
            toolsModule
            overlayModule
            sops-nix.nixosModules.sops
            ./hosts/${host}/configuration.nix
          ];
          specialArgs = {
            flake-inputs = inputs;
            inherit system;
            username = user;
            hostname = host;
          };
        };

        defaultIso = nixpkgs.lib.nixosSystem {
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
                sharedModules = common-hm-modules;
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
      systemConfigs = rec {
        default = gha;
        gha = system-manager.lib.makeSystemConfig { modules = [ ./hosts/sysm/gha/configuration.nix ]; };
        vps = system-manager.lib.makeSystemConfig { modules = [ ./hosts/sysm/vps/configuration.nix ]; };
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
            nix-fmt = {
              enable = true;
              always_run = true;
              stages = [ "pre-commit" ];
              entry = toString (
                pkgs.writeShellScript "nix-fmt" ''
                  ${pkgs.nix}/bin/nix --extra-experimental-features "nix-command flakes" fmt
                ''
              );
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

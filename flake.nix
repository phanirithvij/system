{
  inputs = {
    nixpkgs.url = "github:phanirithvij/nixpkgs/nixos-unstable-ly";

    blobdrop.url = "github:vimpostor/blobdrop";
    blobdrop.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    system-manager = {
      url = "github:numtide/system-manager";
      inputs.crane.follows = "crane";
      inputs.flake-utils.follows = "flake-utils";
      inputs.rust-overlay.follows = "rust-overlay";
      inputs.treefmt-nix.follows = "treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
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

    systems.url = "github:nix-systems/default-linux";

    crane.url = "github:ipetkov/crane";
    crane.inputs.nixpkgs.follows = "nixpkgs";

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
      overlays = import ./lib/overlays.nix {
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
          pkgs.nix-schema
        ];
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
        inherit (pkgs) nix-schema;
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
          modules = [ ] ++ nix-index-hm-modules ++ common-hm-modules;
        };
        # non-nixos
        "${uzer}@${hozt}" = homeConfig {
          username = uzer;
          hostname = hozt;
          modules = [ ] ++ nix-index-hm-modules ++ common-hm-modules;
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
          modules = [ ] ++ nix-index-hm-modules ++ common-hm-modules;
        };
      };
      nixosConfigurations = {
        ${host} = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            { environment.systemPackages = [ blobdrop.packages.${system}.default ]; }
            toolsModule
            sops-nix.nixosModules.sops
            ./hosts/${host}/configuration.nix
            { nixpkgs.overlays = overlays; }
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
                sharedModules = [ ] ++ common-hm-modules;
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
      checks.${system}.formatting = treefmtCfg.check self;
      devShells.${system}.default = import ./flake/shell.nix { inherit pkgs treefmtCfg; };
      # TODO broken
      #devShells."aarch64-linux".default = import ./flake/shellaarch.nix { inherit pkgs; };
    };
}

{
  inputs = {
    nixpkgs.url = "github:phanirithvij/nixpkgs/nixos-unstable-ly";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.treefmt-nix.follows = "treefmt-nix";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    # https://github.com/gvolpe/nix-config/blob/d983b5e6d8c4d57152ef31fa7141d3aad465123a/flake.nix#L17
    flake-schemas.url = "github:DeterminateSystems/flake-schemas";
    #flake-schemas.url = "github:gvolpe/flake-schemas";
    # nix client with schema support: see https://github.com/NixOS/nix/pull/8892
    nix-schema = {
      url = "github:DeterminateSystems/nix-src/flake-schemas";
      inputs.flake-schemas.follows = "flake-schemas";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # TODO jupyenv python, nix, go kernels

    # TODO split up flakes, seems like inputs cannot be separated
    # Flakes are bad for big repos (lazy-trees)
    # TODO move to npins, also keep flakes config in a diff branch

    navi_config.url = "github:phanirithvij/navi";
    navi_config.flake = false;

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    blobdrop.url = "github:vimpostor/blobdrop";
    blobdrop.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-on-droid,
      system-manager,
      treefmt-nix,
      blobdrop,
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
      overlays = import ./lib/overlays.nix { inherit inputs system; };
      homeConfig =
        {
          username,
          hostname,
          modules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/${username} ] ++ modules;
          extraSpecialArgs = {
            inherit inputs;
            inherit username;
            inherit hostname;
          };
        };
      treefmtCfg = (treefmt-nix.lib.evalModule pkgs ./treefmt.nix).config.build;
      nix-index-hm-modules = [
        inputs.nix-index-database.hmModules.nix-index
        { programs.nix-index-database.comma.enable = true; }
      ];
      toolsModule = {
        environment.systemPackages = [
          home-manager.packages.${system}.default
          system-manager.packages.${system}.default
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
        system-manager = system-manager.packages.${system}.default;
      };
      homeConfigurations = {
        # nixos main
        "${user}@${host}" = homeConfig {
          username = user;
          hostname = host;
          modules = [ ] ++ nix-index-hm-modules;
        };
        # non-nixos
        "${uzer}@${hozt}" = homeConfig {
          username = uzer;
          hostname = hozt;
          modules = [ ] ++ nix-index-hm-modules;
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
        # TODO runner #different repo with npins?
      };
      nixosConfigurations = {
        ${host} = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            { environment.systemPackages = [ blobdrop.packages.${system}.default ]; }
            toolsModule
            ./hosts/${host}/configuration.nix
            { nixpkgs.overlays = overlays; }
          ];
          specialArgs = {
            inherit inputs;
            inherit system;
            username = user;
            hostname = host;
          };
        };

        defaultIso = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            home-manager.nixosModules.home-manager
            toolsModule
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.nixos = import ./home/nixos;
                extraSpecialArgs = {
                  inherit inputs;
                  username = "nixos";
                  hostname = "nixos";
                };
              };
            }
            ./hosts/nixos/iso.nix
          ];
        };
      };
      # keep all nix-on-droid hosts in same state
      nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
        modules = [ ./hosts/droid.nix ];
      };
      systemConfigs = rec {
        default = gha;
        gha = system-manager.lib.makeSystemConfig { modules = [ ./hosts/sysm/gha/configuration.nix ]; };
        vps = system-manager.lib.makeSystemConfig { modules = [ ./hosts/sysm/vps/configuration.nix ]; };
      };
      formatter.${system} = treefmtCfg.wrapper;
      checks.${system}.formatting = treefmtCfg.check self;
      devShells.${system}.default = import ./flake/shell.nix { inherit pkgs treefmtCfg; };
    };
}

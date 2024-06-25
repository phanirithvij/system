{
  inputs = {
    nixpkgs.url = "github:phanirithvij/nixpkgs/main";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.treefmt-nix.follows = "treefmt-nix";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    # https://github.com/gvolpe/nix-config/blob/d983b5e6d8c4d57152ef31fa7141d3aad465123a/flake.nix#L17
    flake-schemas.url = "github:gvolpe/flake-schemas";
    # nix client with schema support: see https://github.com/NixOS/nix/pull/8892
    nix-schema = {
      inputs.flake-schemas.follows = "flake-schemas";
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:DeterminateSystems/nix-src/flake-schemas";
    };
    # TODO jupyenv python, nix, go kernels

    # TODO split up flakes, seems like inputs cannot be separated
    # Flakes are bad for big repos (lazy-trees)
    # TODO move to npins, also keep flakes config in a diff branch

    navi_config = {
      url = "github:phanirithvij/navi";
      flake = false;
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    blobdrop.url = "github:vimpostor/blobdrop";
    blobdrop.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    lemurs.url = "github:NullCub3/lemurs/nixosmodule";
    lemurs.inputs.nixpkgs.follows = "nixpkgs";
    lemurs.inputs.utils.follows = "flake-utils";
    lemurs.inputs.rust-overlay.follows = "rust-overlay";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-on-droid,
      blobdrop,
      navi_config,
      nixos-cosmic,
      nix-index-database,
      system-manager,
      treefmt-nix,
      lemurs,
      ...
    }@inputs:
    let
      user = "rithvij";
      uzer = "rithviz";
      droid = "nix-on-droid";
      host = "iron";
      hozt = "rithviz-inspiron7570";
      hostdroid = "localhost"; # not possible to change it
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit overlays system;
        config = {
          allowUnfree = true;
          # TODO allowlist of unfree pkgs, for home-manager too
          allowUnfreePredicate = _: true;
        };
      };
      overlays = import ./lib/overlays.nix { inherit inputs system; };
      homeConfig =
        { username, hostname }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home/${username}

            nix-index-database.hmModules.nix-index
            { programs.nix-index-database.comma.enable = true; }
          ];
          extraSpecialArgs = {
            inherit inputs;
            inherit username;
            inherit hostname;
          };
        };
      treefmtCfg = (treefmt-nix.lib.evalModule pkgs ./treefmt.nix).config.build;
    in
    rec {
      inherit (inputs.flake-schemas) schemas;
      apps.${system}.nix = {
        type = "app";
        program = "${pkgs.nix-schema}/bin/nix-schema";
      };
      apps."aarch64-linux".nix = apps.${system}.nix;
      packages.${system}.nix-schema = pkgs.nix-schema;
      homeConfigurations = {
        "${user}@${host}" = homeConfig {
          username = user;
          hostname = host;
        };
        "${uzer}@${hozt}" = homeConfig {
          username = uzer;
          hostname = hozt;
        };
        "${droid}@${hostdroid}" = homeConfig {
          username = droid;
          hostname = hostdroid;
        };
        # TODO runner #different repo with npins?
        # TODO nixos live user
      };
      nixosConfigurations = {
        ${host} = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules = [
            lemurs.nixosModules.default
            {
              environment.systemPackages = [
                blobdrop.packages.${system}.default
                home-manager.packages.${system}.default
              ];
            }
            ./hosts/${host}/configuration.nix
          ];
          specialArgs = {
            inherit navi_config;
            inherit lemurs;
            inherit system;
            username = user;
            hostname = host;
          };
        };

        defaultIso = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [ ./hosts/iso.nix ];
        };
      };
      # keep all nix-on-droid hosts in same state
      nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
        modules = [ ./hosts/droid.nix ];
      };
      systemConfigs = rec {
        default = gha;
        gha = system-manager.lib.makeSystemConfig { modules = [ ./hosts/sm/gha/configuration.nix ]; };
        vps = system-manager.lib.makeSystemConfig { modules = [ ./hosts/sm/vps/configuration.nix ]; };
      };
      devShells.${system} = {
        default = pkgs.mkShell {
          packages =
            [
              pkgs.nh
              pkgs.xc
              pkgs.statix
            ]
            ++ [
              treefmtCfg.wrapper
              #(pkgs.lib.attrValues treefmtCfg.programs)
            ];
        };
      };
      formatter.${system} = treefmtCfg.wrapper;
      checks.${system} = {
        formatting = treefmtCfg.check self;
      };
    };
}

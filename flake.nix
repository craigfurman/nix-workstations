{
  description = "Craig's configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      home-manager,
      nix-darwin,
      nixpkgs,
      self,
    }:
    let
      lib = nixpkgs.lib;
      craigLib = (import ./lib) lib;

      macSystem = "aarch64-darwin";
      linuxSystem = "x86_64-linux";

      forAllSystems = craigLib.forEachSystem [
        macSystem
        linuxSystem
      ];

      crossPlatformPackages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          tinted-vim = pkgs.callPackage ./pkgs/tinted-vim.nix { };
        }
      );

      macPackages = craigLib.forEachSystem [ macSystem ] (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          autokbisw = pkgs.swiftPackages.callPackage ./pkgs/autokbisw { };
          bluesnooze = pkgs.callPackage ./pkgs/bluesnooze.nix { };
        }
      );
    in
    {

      packages = lib.recursiveUpdate crossPlatformPackages macPackages;

      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#$(hostname)
      darwinConfigurations.lakitu = nix-darwin.lib.darwinSystem (
        let
          system = macSystem;
          pkgs = nixpkgs.legacyPackages.${system};

          overlay = final: prev: {
            autokbisw = self.packages.${system}.autokbisw;
            bluesnooze = self.packages.${system}.bluesnooze;
            vimPlugins = pkgs.vimPlugins // {
              tinted-vim = self.packages.${system}.tinted-vim;
            };
          };
        in
        {
          modules = [
            (import ./darwin)

            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.craig = import ./home { backup.enable = true; };

                # I don't know why, but darwin's specialArgs doesn't propagate
                # through to home-manager, although the docs imply it should.
                extraSpecialArgs = {
                  inherit craigLib nixpkgs;
                  flakePath = ".config/nix-darwin";
                  secrets = import ./secrets/lakitu.nix;
                };
              };
            }
          ];

          specialArgs = {
            inherit overlay system;
            flake = self;
          };
        }
      );

      nixosConfigurations =
        let
          system = linuxSystem;
          overlay = final: prev: {
            vimPlugins = nixpkgs.legacyPackages.${system}.vimPlugins // {
              tinted-vim = self.packages.${system}.tinted-vim;
            };
          };
        in
        {
          chargin-chuck = nixpkgs.lib.nixosSystem {
            modules = [
              ./nixos/chargin-chuck/configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.craig = import ./home { };

                  extraSpecialArgs = {
                    inherit craigLib nixpkgs;
                    flakePath = ".config/nixos";
                    secrets = import ./secrets/chargin-chuck.nix;
                  };
                };
              }
            ];

            specialArgs = {
              inherit overlay;
            };
          };

          # Placeholder - coming soon!
          thwomp = nixpkgs.lib.nixosSystem {
            modules = [
              # ./nixos/thwomp/configuration.nix
            ];
          };
        };

      lib = craigLib;

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    };
}

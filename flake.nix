{
  description = "Craig's configuration flake";

  inputs = {
    # darwin
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    hm-darwin.url = "github:nix-community/home-manager";
    hm-darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # linux
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    hm-linux.url = "github:nix-community/home-manager";
    hm-linux.inputs.nixpkgs.follows = "nixos-unstable";
  };

  outputs =
    {
      nixpkgs-unstable,
      nix-darwin,
      hm-darwin,

      nixos-unstable,
      hm-linux,

      self,
    }:
    let
      lib = nixpkgs-unstable.lib;
      craigLib = (import ./lib) lib;

      macSystem = "aarch64-darwin";
      linuxSystem = "x86_64-linux";

      forAllSystems = craigLib.forEachSystem [
        macSystem
        linuxSystem
      ];

      systemNixpkgs =
        system:
        if nixpkgs-unstable.legacyPackages.${system}.stdenv.isLinux then
          nixos-unstable
        else
          nixpkgs-unstable;

      crossPlatformPackages = forAllSystems (
        system:
        let
          pkgs = (systemNixpkgs system).legacyPackages.${system};
        in
        {
          tinted-vim = pkgs.callPackage ./pkgs/tinted-vim.nix { };
        }
      );

      macPackages = craigLib.forEachSystem [ macSystem ] (
        system:
        let
          pkgs = nixpkgs-unstable.legacyPackages.${system};
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
          nixpkgs = nixpkgs-unstable;
          pkgs = nixpkgs.legacyPackages.${system};
          home-manager = hm-darwin;

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
                users.craig = import ./home {
                  backup.enable = true;
                  manageOtherMachines.enable = true;
                };

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
          nixpkgs = nixos-unstable;
          home-manager = hm-linux;

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

          thwomp = nixpkgs.lib.nixosSystem {
            modules = [
              ./nixos/thwomp/configuration.nix
            ];

            specialArgs = {
              inherit overlay;
              secrets = import ./secrets/thwomp.nix;
            };
          };
        };

      lib = craigLib;

      formatter = forAllSystems (
        system: (systemNixpkgs system).legacyPackages.${system}.nixfmt-rfc-style
      );
    };
}

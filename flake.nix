{
  description = "Craig's configuration flake";

  inputs = {
    # darwin
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    hm-darwin = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # linux
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    hm-linux = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixos-unstable";
    };
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

      forSystem =
        system: systemFn:
        let
          nixpkgs =
            if nixpkgs-unstable.legacyPackages.${system}.stdenv.isLinux then
              nixos-unstable
            else
              nixpkgs-unstable;
          pkgs = import nixpkgs { inherit system; };
          home-manager = if pkgs.stdenv.isLinux then hm-linux else hm-darwin;
        in
        systemFn {
          inherit
            home-manager
            nixpkgs
            pkgs
            system
            ;
        };

      forEachSystem = systems: systemFn: lib.genAttrs systems (system: forSystem system systemFn);

      macSystem = "aarch64-darwin";
      linuxSystem = "x86_64-linux";

      forAllSystems = forEachSystem [
        macSystem
        linuxSystem
      ];

      secrets = import ./secrets/user.nix;
      overlay = import ./overlay.nix;
    in
    {
      darwinModules = {
        bluesnooze = ./modules/darwin/bluesnooze.nix;
      };
      homeManagerModules = {
        autokbisw = ./modules/home-manager/autokbisw.nix;
      };

      lib = (import ./lib lib);

      darwinConfigurations.lakitu = forSystem macSystem (
        {
          home-manager,
          nixpkgs,
          system,
          ...
        }:
        nix-darwin.lib.darwinSystem {
          modules = [
            self.darwinModules.bluesnooze
            (import ./machines/lakitu)

            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.craig = import ./home {
                  backup = {
                    enable = true;
                    enableService = true;
                  };
                };

                # I don't know why, but darwin's specialArgs doesn't propagate
                # through to home-manager, although the docs imply it should.
                extraSpecialArgs = {
                  inherit nixpkgs secrets;
                  flake = self;
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

      nixosConfigurations = forSystem linuxSystem (
        { home-manager, nixpkgs, ... }:
        {
          chargin-chuck =
            let
              gnomeExtensions = [
                "appindicator"
                "no-overview"
              ];
            in
            nixpkgs.lib.nixosSystem {
              modules = [
                ./machines/chargin-chuck/configuration.nix
                ./modules/nixos/base
                home-manager.nixosModules.home-manager
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    users.craig = import ./home {
                      backup.enable = true;
                      dconf.enable = true;
                    };

                    extraSpecialArgs = {
                      flake = self;
                      inherit gnomeExtensions nixpkgs secrets;
                    };
                  };
                }
              ];

              specialArgs = {
                inherit gnomeExtensions overlay secrets;
              };
            };

          thwomp = nixpkgs.lib.nixosSystem {
            modules = [
              ./machines/thwomp/configuration.nix
              ./modules/nixos/base
              ./modules/nixos/nordvpn.nix
            ];

            specialArgs = {
              inherit overlay;
              secrets = secrets // (import ./secrets/thwomp.nix);
            };
          };
        }
      );

      formatter = forAllSystems ({ pkgs, ... }: pkgs.nixfmt-rfc-style);
    };
}

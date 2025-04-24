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
          pkgs = (systemNixpkgs system).legacyPackages.${system};
        in
        {
          bluesnooze = pkgs.callPackage ./pkgs/bluesnooze.nix { };
        }
      );

      secrets = import ./secrets/user.nix;
    in
    {

      packages = lib.recursiveUpdate crossPlatformPackages macPackages;

      darwinConfigurations.lakitu = nix-darwin.lib.darwinSystem (
        let
          system = macSystem;
          nixpkgs = nixpkgs-unstable;
          home-manager = hm-darwin;

          overlay = final: prev: {
            bluesnooze = self.packages.${system}.bluesnooze;
            vimPlugins = prev.vimPlugins // {
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
                  inherit craigLib nixpkgs secrets;
                  flakePath = ".config/nix-darwin";
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
            # TODO remove when linux-firmware bumped beyond 20250410
            linux-firmware = prev.linux-firmware.overrideAttrs rec {
              version = "20250311";
              src = prev.fetchzip {
                url = "https://cdn.kernel.org/pub/linux/kernel/firmware/linux-firmware-${version}.tar.xz ";
                hash = "sha256-ZM7j+kUpmWJUQdAGbsfwOqsNV8oE0U2t6qnw0b7pT4g=";
              };
            };
            vimPlugins = prev.vimPlugins // {
              tinted-vim = self.packages.${system}.tinted-vim;
            };
          };
        in
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
                ./nixos/chargin-chuck/configuration.nix
                home-manager.nixosModules.home-manager
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    users.craig = import ./home {
                      dconf.enable = true;
                    };

                    extraSpecialArgs = {
                      inherit
                        craigLib
                        gnomeExtensions
                        nixpkgs
                        secrets
                        ;
                      flakePath = ".config/nixos";
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
              ./nixos/thwomp/configuration.nix
            ];

            specialArgs = {
              inherit overlay;
              secrets = secrets // (import ./secrets/thwomp.nix);
            };
          };
        };

      lib = craigLib;

      formatter = forAllSystems (
        system: (systemNixpkgs system).legacyPackages.${system}.nixfmt-rfc-style
      );
    };
}

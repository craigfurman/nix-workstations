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

      secrets = import ./secrets/user.nix;
    in
    {
      darwinConfigurations.lakitu = nix-darwin.lib.darwinSystem (
        let
          system = macSystem;
          nixpkgs = nixpkgs-unstable;
          home-manager = hm-darwin;

          overlay = final: prev: {
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
                };

                # I don't know why, but darwin's specialArgs doesn't propagate
                # through to home-manager, although the docs imply it should.
                extraSpecialArgs = {
                  inherit craigLib nixpkgs secrets;
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
          nixpkgs = nixos-unstable;
          home-manager = hm-linux;

          overlay = final: prev: {
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

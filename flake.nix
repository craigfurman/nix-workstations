{
  description = "Craig's laptop configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};

      overlay = final: prev: {
        autokbisw = self.packages.${system}.autokbisw;
      };

      craigLib = pkgs.callPackage (import ./lib) { };
    in
    {
      packages.${system} = {
        autokbisw = pkgs.swiftPackages.callPackage ./pkgs/autokbisw { };
      };

      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#$(hostname)
      darwinConfigurations.lakitu = nix-darwin.lib.darwinSystem {
        modules = [
          (import ./darwin {
            inherit overlay system;
            flake = self;
          })

          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.craig = import ./home;
              extraSpecialArgs = { inherit craigLib; };
            };
          }
        ];
      };

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}

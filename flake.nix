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
      configuration =
        overlay:
        { pkgs, ... }:
        {
          nix.settings.experimental-features = "nix-command flakes";

          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          nixpkgs.hostPlatform = system;

          nixpkgs.overlays = [ overlay ];

          imports = [
            ./darwin/autokbisw.nix
            ./darwin/default.nix
          ];
        };

    in
    {
      packages.${system} = {
        autokbisw = pkgs.swiftPackages.callPackage ./pkgs/autokbisw { };
      };

      overlay = final: prev: {
        autokbisw = self.packages.${system}.autokbisw;
      };

      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#$(hostname)
      darwinConfigurations.lakitu = nix-darwin.lib.darwinSystem {
        modules = [
          (configuration self.overlay)

          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true; # TODO wat
              users.craig = import ./home;
            };

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}

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
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};

      overlay = final: prev: {
        autokbisw = self.packages.${system}.autokbisw;
        bluesnooze = self.packages.${system}.bluesnooze;
        vimPlugins = pkgs.vimPlugins // {
          tinted-vim = self.packages.${system}.tinted-vim;
        };
      };

      craigLib = pkgs.callPackage (import ./lib) { };
    in
    {
      packages.${system} = {
        autokbisw = pkgs.swiftPackages.callPackage ./pkgs/autokbisw { };
        bluesnooze = pkgs.callPackage ./pkgs/bluesnooze.nix { };
        tinted-vim = pkgs.callPackage ./pkgs/tinted-vim.nix { };
      };

      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#$(hostname)
      darwinConfigurations.lakitu = nix-darwin.lib.darwinSystem {
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
                inherit craigLib nixpkgs;
                secrets = import ./secrets/lakitu.nix;
              };
            };
          }
        ];

        specialArgs = {
          inherit overlay system;
          flake = self;
        };
      };

      lib = craigLib;

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}

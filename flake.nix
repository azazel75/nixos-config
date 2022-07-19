{
  inputs = {
    emacs.url = "github:nix-community/emacs-overlay";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neuron.url = "github:srid/neuron";
    nightly-ff.url = "github:colemickens/flake-firefox-nightly";
    nixos-hw.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, emacs, home-manager, neuron, nightly-ff, nixos-hw, nixpkgs }: {
    nixosConfigurations = {
      ender = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules =
          [ ./ender/configuration.nix
            nixos-hw.nixosModules.lenovo-thinkpad-x1-6th-gen
            nixpkgs.nixosModules.notDetected
            ({ pkgs, ... }: {
              nix = {
                registry = {
                  nixpkgs.flake = nixpkgs;
                  nixos-hardware.flake = nixos-hw;
                };
                binaryCaches = [
                  "https://nix-community.cachix.org"
                  "https://srid.cachix.org"
                ];
                binaryCachePublicKeys = [
                  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                  "srid.cachix.org-1:MTQ6ksbfz3LBMmjyPh0PLmos+1x+CdtJxA/J2W+PQxI="
                ];
              };
              nixpkgs.overlays = [
                emacs.overlay
                (self: super: { neuron = neuron.defaultPackage.${system}; })
              ];
            })
          ];
      };
      bean = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules =
          [ ./bean/configuration.nix
            nixos-hw.nixosModules.lenovo-thinkpad-x1-7th-gen
            nixpkgs.nixosModules.notDetected
            ({ pkgs, ... }: {
              nix = {
                registry = {
                  nixpkgs.flake = nixpkgs;
                  nixos-hardware.flake = nixos-hw;
                };
              };
              nixpkgs.overlays = [
                emacs.overlay
                (self: super: { neuron = neuron.defaultPackage.${system}; })
                (self: super: {
                  inherit (nightly-ff.packages.${system}) firefox-nightly-bin;
                  firefox-nightly = nightly-ff.defaultPackage.${system};
                })
                (import ./pkgs)
              ];
            })
            home-manager.nixosModules.home-manager
           {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.azazel = import ./azazel;
            }
          ];
      };
    };
  };
}

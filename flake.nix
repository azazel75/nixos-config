{
  inputs = {
    emacs.url = "github:nix-community/emacs-overlay";
    neuron.url = "github:srid/neuron";
    nixos-hw.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, emacs, neuron, nixos-hw, nixpkgs }: {

    nixosConfigurations.ender = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules =
        [ ./configuration.nix
          nixos-hw.nixosModules.lenovo-thinkpad-x1-6th-gen
          nixpkgs.nixosModules.notDetected
          ({ pkgs, ... }: {
            nix = {
              registry.nixpkgs.flake = nixpkgs;
              binaryCaches = [
                "https://nix-community.cachix.org/"
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
  };
}

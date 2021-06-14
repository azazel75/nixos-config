{ config, lib, pkgs, ... }:
  let
    wayland-enable = false;
  in {
    imports =
      [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        ./boot.nix
        ./net.nix
        ../configuration.nix
      ];
    programs.sway = {
      enable = wayland-enable;
    };
    services.greetd = {
      enable = wayland-enable;
    };
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
}

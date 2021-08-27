{ config, lib, pkgs, ... }:
  let
  in {
    imports =
      [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        ./boot.nix
        ./net.nix
        ../configuration.nix
      ];
    programs.sway = {
      enable = false;
    };
    services.greetd = {
      enable = false; # wayland-enable;
    };
  console = {
    # Early configure the console to make the font readable from the
    # start
    earlySetup = true;
    # this means ISO8859-1 or ISO8859-15 or Windows-1252 codepages
    # (ter-1), 16x32 px (32), normal font weight (n)
    font = "ter-132n";
    packages = [ pkgs.terminus_font ];
  };

  # Fix font sizes in X
  services.xserver.dpi = 162;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}

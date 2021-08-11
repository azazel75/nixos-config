{ config, lib, pkgs, ... }:
  let
    inherit (lib) mkIf mkOption types;
    cfg = config.system.useWayland;
  in {
    options.system.useWayland = mkOption {
      description = ''
        A global setting that defines if this system is using Wayland
      '';
      default = true;
      type = types.bool;
    };

    # This is is needed if sway is configured in home-manager and swaylock is
    # used. Without this, unlock will always fail (see swaylock pkg)
    config = mkIf cfg {security.pam.services.swaylock = {};};
  }

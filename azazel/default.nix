# See available options at https://nix-community.github.io/home-manager/options.html
{ config, lib, pkgs, nixosConfig, ... }:
  let
    inherit (lib) mkMerge mkIf;
    waylandEnabled = nixosConfig.system.useWayland;
  in {
    imports = [
      ./git.nix
      ./gpg.nix
      ./wayland.nix
    ];
    home.packages = with pkgs; [
      calibre
      wl-clipboard
      # firefox-nightly
    ];
    home.sessionVariables = mkMerge [
      {
        EDITOR = "emacsclient";
      }
      (mkIf waylandEnabled {
        MOZ_ENABLE_WAYLAND = 1;
        XDG_CURRENT_DESKTOP = "sway";
      })
    ];

    programs = {
      alacritty = {
        enable = true;
        settings = {
          env.TERM = "xterm-color";
          font.size = 16;
        };
      };
      bash.enable = true;
    };
 }

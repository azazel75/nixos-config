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
      # calibre # error with python3.9-apsw-3.37.0-r1.drv 2022-04-09
      wl-clipboard
      grim
      slurp
      wayland
      # firefox-nightly
      openzone-cursors
      ubuntu-themes
      virt-manager
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

    home.stateVersion = "22.05";

    programs = {
      alacritty = {
        enable = true;
        settings = {
          env.TERM = "xterm-color";
          font.size = 16;
        };
      };
      foot = {
        enable = true;
        settings = {
          main = {
            term = "xterm-256color";

            font = "monospace:size=10";
            dpi-aware = "yes";
          };
          bell = {
            urgent = true;
            notify = true;
          };
          mouse = {
            hide-when-typing = "yes";
          };
        };
      };
      bash.enable = true;
    };
 }

{ config, lib, pkgs, ... }:
  let
    enable = false;
  in {
    programs.sway = {
      enable = enable;
      extraPackages = with pkgs; [
        swaylock
        swayidle
        xwayland
        wl-clipboard
        mako # notification daemon
        alacritty # Alacritty is the default terminal in the config
        i3status
        dmenu
      ];
    };
    services.greetd = {
      enable = enable;
      settings = {
        default_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd sway";
        };
      };
  };
}

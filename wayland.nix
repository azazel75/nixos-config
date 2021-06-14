{ config, lib, pkgs, ... }:
  let
  in {
    programs.sway = {
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
      settings = {
        default_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd sway";
        };
      };
  };
}

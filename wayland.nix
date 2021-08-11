{ config, lib, pkgs, ... }:
  let
    inherit (pkgs) writeText;
    wlgreetConfig = writeText "greetd-wlgreet-config" ''
      exec "${pkgs.greetd.wlgreet}/bin/wlgreet --command sway; swaymsg exit"

      bindsym Mod4+shift+e exec swaynag \
        -t warning \
        -m 'What do you want to do?' \
        -b 'Poweroff' 'systemctl poweroff' \
        -b 'Reboot' 'systemctl reboot'

      #include /etc/sway/config.d/*
    '';
  in {
    programs.sway = {
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
      extraPackages = with pkgs; [
        swaylock
        swayidle
        xwayland
        wl-clipboard
        mako # notification daemon
        alacritty # Alacritty is the default terminal in the config
        i3status
        dmenu-wayland
      ];
      extraSessionCommands = ''
        # SDL:
        export SDL_VIDEODRIVER=wayland
        # QT (needs qt5.qtwayland in systemPackages), needed by VirtualBox GUI:
        export QT_QPA_PLATFORM=wayland-egl
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      '';
    };
    services.greetd = {
      settings = {
        default_session = {
          command = "sway --config ${wlgreetConfig}";
        };
      };
  };
}

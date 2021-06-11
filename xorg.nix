{ config, lib, pkgs, ... }: {
  # Enable the X11 windowing system.
  services.xserver = {
    enable = !config.programs.sway.enable;
    layout = "it";
    xkbOptions = "eurosign:e";
    # Enable touchpad support.
    libinput.enable = true;
    desktopManager.enlightenment.enable = false;
    desktopManager.mate.enable = false;
    desktopManager.pantheon.enable = false;
    windowManager.i3.enable = true;
    windowManager.i3.extraSessionCommands = ''
      nm-applet &
      EDITOR=emacsclient
      DPI=210
      TERMINAL=sakura
      XCURSOR_SIZE=48
      export EDITOR TERMINAL XCURSOR_SIZE DPI
      echo Xft.dpi: $DPI | xrdb -merge
      xset s off
      xset dpms 600 600
      xset +dpms

      ${pkgs.xss-lock}/bin/xss-lock -- i3lock-color -n -B5&
  '';
  };
}

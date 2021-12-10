{ config, lib, pkgs, ... }: {
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "it";
    xkbOptions = "eurosign:e";
    # Enable touchpad support.
    libinput.enable = true;
    displayManager.startx.enable = true;
  };
}

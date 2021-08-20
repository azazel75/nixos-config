{ config, lib, pkgs, ... }: {

  hardware = {
    i2c.enable = true; # allow connected display discovery
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      ];
    };
    pulseaudio.enable = true;
    trackpoint.enable = true;
  };

  environment.etc."libinput/local-overrides.quirks" =  {
    text = ''
      [Trackpoint Override]
      MatchUdevType=pointingstick
      AttrTrackpointMultiplier=0.8
    '';
  };

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}

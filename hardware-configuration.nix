{ config, lib, pkgs, ... }: {

  hardware = {
    i2c.enable = true; # allow connected display discovery
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

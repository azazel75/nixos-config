{ config, lib, pkgs, ... }: {

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    cpu.intel.updateMicrocode = true;
    i2c.enable = true; # allow connected display discovery
    opengl = {
      enable = true;
      driSupport = true; # it is true by default
      extraPackages = with pkgs; [ # The very same list is present in nixos-hardware
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      extraModules =  [ pkgs.pulseaudio-modules-bt ];
      extraConfig = ''
        load-module module-switch-on-connect
      '';
    };
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

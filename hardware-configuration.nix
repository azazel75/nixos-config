{ config, lib, pkgs, ... }:
let
  keppel-share = name: {
    name = "/mnt/keppel/${name}";
    value = {
      device = "//nas/${name}";
      fsType = "cifs";
      options = [
        "noauto"
        "credentials=/etc/nixos/secret/keppel_samba.cred"
        "x-systemd.automount"
        "x-systemd.idle-timeout=5min"
        "uid=azazel"
        "gid=users"
      ];
    };
  };
  keppel-shares = names: builtins.listToAttrs (map keppel-share names);
in {
  imports = [
    ./x1-6th.nix
  ];

  boot.initrd = {
    availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
    kernelModules = [ "intel_agp" "i915" ];
  };
  boot.kernelModules = [ "kvm-intel" "v4l2loopback"];
  boot.kernelParams = [
    "intel_iommu=nobounce"
    # see https://github.com/NixOS/nixpkgs/pull/102106
    # and https://github.com/erpalma/throttled/issues/215
    "msr.allow_writes=on"
  ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/9efb0739-a437-47cf-936b-dd45f5465d89";
      fsType = "btrfs";
    };

    "/home" = {
      device = "/dev/disk/by-uuid/570de865-292a-4375-ad47-6f68d74e17af";
      fsType = "btrfs";
    };

    "/boot/efi" = {
      device = "/dev/disk/by-uuid/8437-033C";
      fsType = "vfat";
    };

    "/mnt/giskard/data" = {
      device = "giskard:/mnt/data";
      fsType = "nfs";
      options = [
        "noauto"
        "x-systemd.automount"
        ''x-systemd.idle-timeout="20min"''
      ];
    };

    "/mnt/giskard/musica" = {
      device = "giskard:/mnt/musica";
      fsType = "nfs";
      options = [
        "noauto"
        "x-systemd.automount"
        ''x-systemd.idle-timeout="20min"''
      ];
    };

    "/mnt/giskard/books" = {
      device = "giskard:/mnt/books";
      fsType = "nfs";
      options = [
        "noauto"
        "x-systemd.automount"
        ''x-systemd.idle-timeout="20min"''
      ];
    };

    "/mnt/portable/sabrent1" = {
      device = "UUID=f846c91d-4206-4184-aa79-3246f01612c7";
      fsType = "xfs";
      options = [
        "noatime"
        "noauto"
        "x-systemd.automount"
        ''x-systemd.idle-timeout="20min"''
      ];
    };

    "/mnt/portable/samsung" = {
      device = "UUID=df6cab1a-128d-4a6c-89fe-64b5ee54d1fd";
      fsType = "ext4";
      options = [
        "noatime"
        "noauto"
        "x-systemd.automount"
        ''x-systemd.idle-timeout="20min"''
      ];
    };
  } // (keppel-shares ["azazel" "download" "keppel" "scansioni"]);

  swapDevices = [ { device="/dev/system/swap"; } ];

  hardware.pulseaudio.enable = true;
  hardware.trackpoint = {
    enable = true;
  };

  environment.etc."libinput/local-overrides.quirks" =  {
    text = ''
      [Trackpoint Override]
      MatchUdevType=pointingstick
      AttrTrackpointMultiplier=1.5
    '';
  };

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  services.throttled.enable = true;
  systemd.timers.cpu-throttling.enable = lib.mkForce false;
}

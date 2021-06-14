{ config, lib, pkgs, ... }: {
  imports = [
    ./x1-6th.nix
  ];

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
  };
  swapDevices = [ { device="/dev/system/swap"; } ];
  services.throttled.enable = true;
  systemd.timers.cpu-throttling.enable = lib.mkForce false;
}

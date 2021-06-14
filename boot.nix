{ config, lib, pkgs, ... }: {
  boot.initrd = {
    availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
    kernelModules = [ "intel_agp" "i915" ];
  };
  boot.kernelModules = [ "kvm-intel" "v4l2loopback"];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "intel_iommu=nobounce"
    "mem_sleep_default=deep"
    # see https://github.com/NixOS/nixpkgs/pull/102106
    # and https://github.com/erpalma/throttled/issues/215
    "msr.allow_writes=on"
    "i915.enable_dp_mst=0"
  ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = "1";
    "net.ipv6.conf.all.forwarding" = "1";
  };

  boot.cleanTmpDir = true;
}

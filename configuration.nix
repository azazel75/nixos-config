# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./net.nix
      ./packages.nix
      ./tlp.nix
      ./nur.nix
      ./encryption.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];
  boot.loader.grub = {
    efiSupport = true;
    enable = true;
    device = "nodev";
    useOSProber = true;
  };

  # See https://delta-xi.net/#056
  #boot.initrd.prepend = [
  #  "${/boot/acpi_override}"
  #];

  boot.cleanTmpDir = true;

  console = {
    earlySetup = true;
    font = "ter-132n";
    keyMap = "it";
    packages = [ pkgs.terminus_font ];
  };

  #Select internationalisation properties.
  i18n.defaultLocale = "it_IT.UTF-8";

  location = import ./secret/location.nix;
  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.adb.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.avahi = {
    enable = true;
    nssmdns = true;
  };
  services.connman.enable = false;

  #services.teamviewer.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;


  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "it";
  services.xserver.xkbOptions = "eurosign:e";
  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.enlightenment.enable = false;
  services.xserver.desktopManager.mate.enable = false;
  services.xserver.desktopManager.pantheon.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.extraSessionCommands = ''

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

  sound.mediaKeys = {
    enable = true;
    volumeStep = "5%";
  };
  services.illum.enable = true;
  services.redshift.enable = true;

  programs.sway = {
    enable = false;
    extraPackages = with pkgs; [
      swaylock swayidle xwayland i3status dmenu
    ];
  };

  services.pcscd.enable = true;
  services.pcscd.plugins = [ pkgs.ccid pkgs.libacr38u];
  services.fwupd.enable = true;

  users.users.azazel = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" "vboxusers" "cdrom" ];
    createHome = true;
    initialHashedPassword = "";
    description = "Alberto Berti";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host = {
    enable = true;
    #enableExtensionPack = true;
  };
  services.printing.enable = true;

  services.journald.extraConfig = ''
    MaxRetentionSec = 4 month
  '';
}

{ config, lib, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # utils
    wget vim less tree tmux zile sshfs nfs-utils cifs-utils
    cpio dhcp
    exa
    file
    htop
    inetutils
    killall
    nmap
    p7zip
    pciutils
    unzip

    # apps
    emacs firefox gnupg openssl python3 stunnel sysstat tcpdump


    # smarcard
    # pcsctools
    libacr38u opensc

  ];

  users.users.azazel.packages = with pkgs; [

    # utils
    adb-sync

    # apps
    albert
    anydesk
    aqemu
    aspellDicts.en
    aspellDicts.it
    borgbackup
    calibre
    chromium
    crip # terminal ripper
    # darcs # marked as broken
    digikam
    dpkg
    elixir_1_9 erlang mimic
    evince
    flac
    gnome3.cheese
    gnome3.dconf-editor
    google-chrome
    hunspell
    hunspellDicts.en-us
    hunspellDicts.it-it
    inkscape
    ispell
    kodi
    kubectl
    kvm
    libreoffice
    libvirt
    lyx
    mate.caja
    mate.caja-extensions
    mc
    mupdf
    nextcloud-client
    puddletag
    (python3.withPackages (ps: with ps; [
      flake8 black autopep8 rope setuptools yapf jedi]))
    redshift
    remmina
    samba
    scrcpy
    signal-desktop
    skopeo
    sqlitebrowser
    texlive.combined.scheme-medium
    thunderbird
    #tor-browser-bundle-bin
    units
    virtmanager
    vlc
    #wine-staging
    #xonsh
    xsettingsd
    zeal

    # visual
    breeze-icons
  ];
  fonts.fonts =  with pkgs; [
    carlito
    dejavu_fonts
    gentium
    gentium-book-basic
    liberation_ttf
  ];
}

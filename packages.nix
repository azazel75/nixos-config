{ config, lib, pkgs, ... }:
  let
  in {
    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [
      # utils
      wget vim less tree tmux zile sshfs nfs-utils cifs-utils
      cpio dhcp
      file
      htop
      xfsprogs
      inetutils
      killall
      nmap
      # p7zip # insecure
      pciutils
      unzip

      # apps
      firefox
      gnupg openssl python3 stunnel sysstat tcpdump


      # smarcard
      # pcsctools
      libacr38u opensc
      mate.mate-notification-daemon

    ];

    users.users.azazel.packages = with pkgs; [

      # utils
      adb-sync

      # apps
      #albert
      #anydesk
      #aqemu
      aspellDicts.en
      aspellDicts.it
      borgbackup
      # calibre
      cachix
      chromium
      crip # terminal ripper
      # darcs # marked as broken
      #digikam
      dpkg
      elixir_1_10 erlang mimic
      emacsPgtkGcc ripgrep fd clang #doom-emacs stuff
      evince
      flac
      gnome3.cheese
      google-chrome
      hunspell
      hunspellDicts.en-us
      hunspellDicts.it-it
      inkscape
      ispell
      #kodi
      kubectl
      kvm
      libreoffice
      libvirt
      lyx
      mate.caja
      mate.caja-extensions
      mc
      #mupdf
      neuron
      nextcloud-client
      puddletag
      python3
      redshift
      remmina
      samba
      scrcpy
      signal-desktop
      skopeo
      sqlitebrowser
      (texlive.combine {
            inherit (texlive) scheme-medium collection-langitalian; # caption wrapfig;
      })
      thunderbird
      #tor-browser-bundle-bin
      units
      virtmanager
      vlc
      #wine-staging
      #xonsh
      #xsettingsd
      #zeal

      # visual
      breeze-icons
    ];
    fonts.fonts =  with pkgs; [
      carlito
      dejavu_fonts
      gentium
      gentium-book-basic
      arkpandora_ttf
    ];
  }

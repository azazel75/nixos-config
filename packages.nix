{ config, lib, pkgs, ... }:
  let
    inherit (lib) mkMerge optionals;
    waylandEnabled = config.system.useWayland;
  in {
    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; (mkMerge [
      [
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

        # apps
        gnupg openssl python3 stunnel sysstat tcpdump


        # smarcard
        # pcsctools
        libacr38u opensc
        mate.mate-notification-daemon
      ]
      (optionals waylandEnabled [
        firefox-wayland
        kodi-wayland
        glib # gsettings needed in sway's conf
        qt5.qtwayland
      ])
      (optionals (! waylandEnabled) [
        firefox
        kodi
      ])
    ]);

    users.users.azazel.packages = with pkgs; (mkMerge [
      [
        # utils
        adb-sync

        # apps
        #albert
        #anydesk
        #aqemu
        arandr
        aspellDicts.en
        aspellDicts.it
        borgbackup
        brightnessctl
        calibre
        cachix
        chromium
        crip # terminal ripper
        # darcs # marked as broken
        #digikam
        dpkg

        # brightness of external displays
        ddcutil
        ddcui

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
        remmina
        sakura
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
        xonsh
        #xsettingsd
        zeal

        # visual
        breeze-icons
      ]
      (optionals (! waylandEnabled) [
        redshift
      ])
    ]);
    fonts.fonts =  with pkgs; [
      carlito
      dejavu_fonts
      gentium
      gentium-book-basic
      arkpandora_ttf
    ];
  }

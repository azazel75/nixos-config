{ config, lib, pkgs, ... }:
  let
    inherit (lib) mkMerge optionals;
    waylandEnabled = config.system.useWayland;
    kodi = if waylandEnabled then pkgs.kodi-wayland else pkgs.kodi;
    kodiDistro = kodi.withPackages (kpkgs: with kpkgs; [
      inputstreamhelper
      inputstream-adaptive
      inputstream-ffmpegdirect
      inputstream-rtmp
      pvr-iptvsimple
      vfs-sftp
      vfs-libarchive
    ]);
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
        openconnect
        pciutils
        pstree
        unzip

        # apps
        gnupg openssl python3 stunnel sysstat tcpdump


        # smarcard
        # pcsctools
        libacr38u opensc
        mate.mate-notification-daemon
        xdg-utils
      ]
      (optionals waylandEnabled [
        firefox-wayland
        glib # gsettings needed in sway's conf
        qt5.qtwayland
      ])
      (optionals (! waylandEnabled) [
        firefox
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
        brave
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
        fortune
        git-crypt
        gnome.networkmanagerapplet
        gnome3.cheese
        google-chrome
        hunspell
        hunspellDicts.en-us
        hunspellDicts.it-it
        inkscape
        ispell
        kodiDistro
        kubectl
        kvm
        libreoffice
        libvirt
        lyx
        mate.caja
        mate.caja-extensions
        mate.eom
        mc
        #mupdf
        neuron
        nextcloud-client
        nyxt
        oathToolkit
        pavucontrol
        puddletag
        python3
        remmina
        sakura
        samba
        scrcpy
        signal-desktop
        skopeo
        squeezelite
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
      [
        # rust
        cargo
        rustc
        rust-analyzer
        rustup
      ]
      (optionals waylandEnabled [
        (pass-wayland.withExtensions (exts: with exts; [ pass-genphrase
                                                        pass-import
                                                        pass-otp ]))
        wdisplays
      ])
      (optionals (! waylandEnabled) [
        pass
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

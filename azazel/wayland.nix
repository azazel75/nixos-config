{ config, lib, pkgs, nixosConfig,  ... }:
  let
    inherit (lib) mkIf;
    waylandEnabled = nixosConfig.system.useWayland;
  in {
    programs = mkIf waylandEnabled {
      mako = {
        enable = true;
        defaultTimeout = 5000;
      };
    };
    services = mkIf waylandEnabled {
      gammastep = {
        enable = true;
        # my place in Trentino;
        latitude = "45.89";
        longitude = "11.04";
      };
    };
    wayland= {
      windowManager.sway =
        let
          internal-lcd = "eDP-1";
        in {
          enable = waylandEnabled;
          config =
            let
              bctl = "${pkgs.brightnessctl}/bin/brightnessctl";
              fname = "monospace";
              font = {
                names = [ fname ];
                size = 14.0;
              };
              gnome-schema = "org.gnome.desktop.interface";
              genWorkspaceKey = keylist: cmd:
                /* given ["${mod}" "Shift"] "workspace" generates an attrs with
                  {
                    "${mod}+Shift+0" = "workspace 10";
                    "${mod}+Shift+1" = "workspace 1";
                    ...
                  }
                  for all the 10 workspaces
                */
                let
                  inherit (lib) concatStringsSep genList listToAttrs;
                  wsFromIx = ix: if ix == 0 then 10 else ix;
                in
                  listToAttrs (
                    genList (ix:
                      {
                        name = "${concatStringsSep "+" (keylist ++ [(toString ix)])}";
                        value = "${cmd} ${toString (wsFromIx ix)}";
                      }
                    ) 10);
              lg-5k = "Goldstar Company Ltd LG HDR 5K 904NTTQ6N889";
              lockCmd = "${pkgs.swaylock}/bin/swaylock -c 000000";
              menu = "${pkgs.bemenu}/bin/bemenu-run -b -p » --fn 'pango:${fname} ${builtins.toString font.size}'";
              mod = "Mod4";
              smsg = "${pkgs.sway}/bin/swaymsg";
            in {
              bars = [
                {
                  fonts = font;
                  statusCommand = "${pkgs.i3status}/bin/i3status";
                  trayOutput = "*";
                }
              ];
              fonts = font;
              input = {
                "*" = {
                  xkb_layout = "it";
                  xkb_options = "eurosign:e";
                };
              };
              # move keybindings, all configured here
              down = "k";
              left = "j";
              right = "ograve";
              up = "l";
              keybindings = {
                "${mod}+Ctrl+Down" = "move workspace to output down";
                "${mod}+Ctrl+Left" = "move workspace to output left";
                "${mod}+Ctrl+Right" = "move workspace to output right";
                "${mod}+Ctrl+Up" = "move workspace to output up";
                "${mod}+Shift+Down" = "move down";
                "${mod}+Shift+Left" = "move left";
                "${mod}+Shift+Right" = "move right";
                "${mod}+Shift+Up" = "move up";
                "${mod}+Down" = "focus down";
                "${mod}+Left" = "focus left";
                "${mod}+Right" = "focus right";
                "${mod}+Up" = "focus up";

                "${mod}+Ctrl+b" = "exec brave";
                "${mod}+Ctrl+c" = "exec chrome";
                "${mod}+Ctrl+e" = "exec emacs";
                "${mod}+Ctrl+Shift+e" = "exec emacs --with-profile gnus -f mine-emacs";
                "${mod}+Ctrl+f" = "exec firefox";
                "${mod}+Ctrl+k" = "exec kodi";
                "${mod}+Ctrl+n" = "exec nyxt-ok.sh";
                "${mod}+Ctrl+s" = "exec signal";
                "${mod}+Return" = "exec alacritty";
                "${mod}+Shift+c" = "reload";
                "${mod}+Shift+e" = "${pkgs.sway}/bin/swaynag 'Exit Sway?' -b 'Yes, exit Sway' '${pkgs.sway}/bin/${smsg} exit'";
                "${mod}+Shift+minus" = "move scratchpad";
                "${mod}+Shift+q" = "kill";
                "${mod}+Shift+r" = "restart";
                "${mod}+Shift+space" = "floating toggle";
                "${mod}+a" = "focus parent";
                "${mod}+e" = "layout toggle split";
                "${mod}+h" = "split h";
                "${mod}+f" = "fullscreen";
                "${mod}+g" = "sticky toggle";
                "${mod}+minus" = "scratchpad show";
                "${mod}+p" = "exec ${menu}";
                "${mod}+r" = ''mode "resize"'';
                "${mod}+s" = "layout stacking";
                "${mod}+space" = "focus mode_toggle";
                "${mod}+w" = "layout tabbed";
                "${mod}+v" = "split v";
                XF86AudioLowerVolume = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
                XF86AudioMute = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
                XF86AudioRaiseVolume = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
                XF86Display = "exec ${pkgs.wdisplays}/bin/wdisplays";
                XF86MonBrightnessDown = "exec ${bctl} s 5%-";
                XF86MonBrightnessUp = "exec ${bctl} s 5%+";
                XF86Search = "exec ${lockCmd}";
                XF86Tools = "exec ${lockCmd}";
              } // (genWorkspaceKey ["${mod}"] "workspace")
                // (genWorkspaceKey ["${mod}" "Shift"] "move container to workspace");
              menu = "${menu}";
              modifier = "${mod}";
              output = {
                ${internal-lcd} = {
                  mode = "1920x1200";
                  scale = "1";
                  subpixel = "vrgb";
                };
                ${lg-5k} = {
                  mode = "5120x2160";
                  scale = "1.3";
                };
              };
              seat = {
                "*" = {
                  hide_cursor = "when-typing enable";
                  xcursor_theme = ''"Adwaita" 24'';
                };
              };
              startup = [
                {
                  # see https://nixos.wiki/wiki/Firefox
                  always = true;
                  command = "systemctl --user import-environment";
                }
                {
                  command = ''
                   ${pkgs.swayidle}/bin/swayidle -w \
                     timeout 600 '${lockCmd} -f ' \
                     timeout 1800 '${smsg} "output * dpms off"' \
                     resume '${smsg} "output * dpms on"' \
                     before-sleep '${lockCmd} -f'
                  '';
                }
                {
                  always = true;
                  command = "${pkgs.glib}/bin/gsettings set ${gnome-schema} text-scaling-factor 1.5";
                }
                # start polkit pinentry for priviledge escalation (virt-manager) also used
                # by gnome utils like nm-connection-editor
                { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
              ];
              terminal = "${pkgs.alacritty}/bin/alacritty";
              workspaceAutoBackAndForth = true;
            };
          extraConfig = ''
             bindswitch --reload --locked lid:on output ${internal-lcd} disable
             bindswitch --reload --locked lid:off output ${internal-lcd} enable
             default_border normal
             default_floating_border pixel
             xwayland enable
          '';
          extraSessionCommands = ''
            # SDL:
            export SDL_VIDEODRIVER=wayland
            # QT (needs qt5.qtwayland in systemPackages), needed by VirtualBox GUI:
            export QT_QPA_PLATFORM=wayland-egl
            export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
          '';
          wrapperFeatures = {
            base = true;
            gtk = true;
          };
        };
    };
  }

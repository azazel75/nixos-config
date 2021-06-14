{ config, lib, pkgs, ... }: {
  # Sleep
  #   https://www.kernel.org/doc/html/latest/admin-guide/pm/sleep-states.html#basic-sysfs-interfaces-for-system-suspend-and-hibernation
  #   Force hybrid-sleep on suspend:
  #     - When suspending, write RAM to disk (hibernate)
  #     - When done writing hibernation image, suspend.
  environment.etc."systemd/sleep.conf".text = pkgs.lib.mkForce ''
    [Sleep]
    AllowSuspend=no
    AllowHybridSleep=yes
    AllowHibernation=yes
    AllowSuspendThenHibernate=yes
    SuspendMode=suspend
    SuspendState=mem
    HybridSleepMode=suspend
    HybridSleepState=mem
    HibernateMode=platform
    HibernateState=disk
    HibernateDelaySec=7200
  '';
  services.logind = with pkgs.lib; rec {
    lidSwitch = mkForce "suspend-then-hibernate";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = lidSwitch;
    extraConfig = ''
      idleAction=lock
    '';
  };
}

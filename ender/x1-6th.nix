# X1 6th generation with a QHD (2560x1440px) display
{ lib, pkgs, ... }:

{
  # Enable readable font on console. The example configuration that
  # follows is taliored towards western languages. To see how to
  # configure the font download the source tarball from
  # http://terminus-font.sourceforge.net/ and read the README file on
  # the root dir
  console = {
    # Early configure the console to make the font readable from the
    # start
    earlySetup = true;
    # this means ISO8859-1 or ISO8859-15 or Windows-1252 codepages
    # (ter-1), 16x32 px (32), normal font weight (n)
    font = "ter-132n";
    packages = [ pkgs.terminus_font ];
  };

  # Fix font sizes in X
  services.xserver.dpi = 210;
 
  # Fix sizes of GTK/GNOME ui elements
  environment.variables = {
    GDK_SCALE = lib.mkDefault "2";
    GDK_DPI_SCALE= lib.mkDefault "0.5";
  };
}

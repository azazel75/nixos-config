self: super: {
  # lispPackages = super.lispPackages // (import ./nyxt.nix {
  #   inherit (super.lispPackages) cl-webkit2 nyxt;
  #   inherit (super) fetchFromGitHub;
  # });
}

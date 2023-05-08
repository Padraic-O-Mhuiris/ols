{
  description = "ols";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix/monthly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fup.url = "github:gytis-ivaskevicius/flake-utils-plus";
  };
  outputs = { self, nixpkgs, fup, fenix }@inputs:
    let inherit (fup.lib) mkFlake;
    in mkFlake {
      inherit self inputs;
      supportedSystems = [ "x86_64-linux" ];

      sharedOverlays = [ fenix.overlays.default ];

      outputsBuilder = channel:
        let
          pkgs = channel.nixpkgs;
          fenixPkgs = (pkgs.fenix.complete.withComponents [
            "cargo"
            "clippy"
            "rust-src"
            "rustc"
            "rustfmt"
          ]);
        in {
          devShell = channel.nixpkgs.mkShell {
            name = "ols";
            packages = with pkgs; [ hyperfine rust-analyzer-nightly fenixPkgs ];
          };
        };
    };
}

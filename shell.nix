{nixpkgs ? import <nixos> {}}:

let
  inherit (nixpkgs) pkgs;

  ep = pkgs.elmPackages;
  np = pkgs.nodePackages;
in
  pkgs.mkShell {
    buildInputs = [
      ep.elm
      ep.elm-format
      np.elm-oracle
    ];
  }

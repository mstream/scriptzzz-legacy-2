{ sources ? import ./sources.nix }:

let
  overlay = _: _: {
    mstream = import ./mstream.nix { };
    niv = import sources.niv { };
  };
  pkgs = import sources.nixpkgs { overlays = [ overlay ]; };

in pkgs

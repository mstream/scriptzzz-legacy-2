{ sources ? import ./sources.nix, pkgs ? import sources.nixpkgs { } }:

pkgs.mkShell { nativeBuildInputs = with pkgs; [ elmPackages.elm niv ]; }

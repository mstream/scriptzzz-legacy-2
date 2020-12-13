{ sources ? import ./sources.nix, pkgs ? import sources.nixpkgs { } }:

{
  nativeBuildInputs = with pkgs.elmPackages; [ elm elm-live elm-test ];
}

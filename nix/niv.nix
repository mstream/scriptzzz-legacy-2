{ sources ? import ./sources.nix, pkgs ? import sources.nixpkgs { } }:

{
  nativeBuildInputs = with pkgs [ niv ];
}

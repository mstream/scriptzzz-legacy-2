{ sources ? import ./sources.nix, pkgs ? import sources.nixpkgs { } }:

{
  nativeBuildInputs = with pkgs.nodePackages; [ uglify-js ];
}

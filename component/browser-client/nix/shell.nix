{ pkgs ? import ../../../nix/pkgs.nix { } }:

let
  elm = import ../../../nix/elm.nix { };
  node = import ../../../nix/node.nix { };

in pkgs.mstream.mkShell [ elm node ]

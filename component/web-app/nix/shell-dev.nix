{ pkgs ? import ../../../nix/pkgs.nix { } }:

let
  ciShell = import ./shell-ci.nix { };
  overlayShell = pkgs.mkShell {
    shellHook = ''
      export PATH="''${PWD}/scripts:''${PATH}"
    '';
  };

in pkgs.mstream.mergeEnvs [ ciShell overlayShell ]

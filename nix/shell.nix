{ sources ? import ./sources.nix, pkgs ? import sources.nixpkgs { } }:

let
  elm = import ./elm.nix { };
  node = import ./node.nix { };

  commonNativeInputs = with pkgs; [ niv ];

in pkgs.mkShell {
  nativeBuildInputs = commonNativeInputs ++ elm.nativeBuildInputs
    ++ node.nativeBuildInputs;
}

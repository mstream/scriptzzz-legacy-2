{ sources ? import ./sources.nix, pkgs ? import sources.nixpkgs { } }:

let
  defaultShellOpts = {
    nativeBuildInputs = [ ];
    shellHooks = "";
  };

  mergeShellOpts = builtins.foldl' (optsA: optsB:
    let optsBWithDefaults = defaultShellOpts // optsB;
    in {
      nativeBuildInputs = optsA.nativeBuildInputs
        ++ optsBWithDefaults.nativeBuildInputs;
      shellHooks = optsA.shellHooks + "\n"
        + optsBWithDefaults.shellHooks;
    }) defaultShellOpts;

  mkShell = opts: pkgs.mkShell (mergeShellOpts opts);

in { inherit mkShell; }

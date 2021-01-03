{ pkgs ? import ./pkgs.nix { } }:

let
  reducer = acc: env: {
    buildInputs = acc.buildInputs ++ env.buildInputs;
    nativeBuildInputs = acc.nativeBuildInputs ++ env.nativeBuildInputs;
    propagatedBuildInputs = acc.propagatedBuildInputs
      ++ env.propagatedBuildInputs;
    propagatedNativeBuildInputs = acc.propagatedNativeBuildInputs
      ++ env.propagatedNativeBuildInputs;
    shellHook = acc.shellHook + "\n" + env.shellHook;
  };

  defaultShell = pkgs.mkShell { };

  mergeEnvs = envs:
    pkgs.mkShell (builtins.foldl' reducer defaultShell envs);

in { inherit mergeEnvs; }

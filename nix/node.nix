{ sources ? import ./sources.nix, pkgs ? import sources.nixpkgs { } }:

{
  nativeBuildInputs = (with pkgs; [ nodejs ])
    ++ (with pkgs.nodePackages; [ npm ]);

  shellHooks = ''
    export PATH="$PWD/node_modules/.bin/:$PATH"
    alias run='npm start'
  '';
}

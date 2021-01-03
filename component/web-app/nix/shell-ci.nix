{ pkgs ? import ../../../nix/pkgs.nix { } }:

pkgs.mkShell {
  shellHook = ''
    export NVM_DIR="''${HOME}/.nvm"
    export PATH="''${PWD}/node_modules/.bin/:''${PATH}"
    [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
  '';
}

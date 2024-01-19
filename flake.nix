{
  description = "A very basic flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import "${nixpkgs}" { inherit system; };
      in {
        packages.default = pkgs.haskellPackages.callCabal2nix
          "oauth2-simple" ./. { };
        devShells.default = pkgs.mkShell {
            nativeBuildInputs = [
              pkgs.ghcid
              pkgs.cabal-install
              pkgs.hpack
              (pkgs.haskellPackages.ghc.withPackages (p:
                self.packages.${system}.default.getBuildInputs.haskellBuildInputs
              ))
            ];
        };
      });
}

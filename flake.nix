{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            nativeBuildInputs = [
              # Compiler, VM & Builder
              pkgs.jdk21 # JDK
              pkgs.gradle_8 # Gradle

              # LSP
              pkgs.nil # Nix LSP
              pkgs.jdt-language-server # Java LSP by Eclipse team
            ];
          };
        };
    };
}
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
        let
          jdkWithFX = pkgs.jdk25.override { enableJavaFX = true; };
        in
        {
          devShells.default = pkgs.mkShell {
            nativeBuildInputs = [
              # Compiler, VM & Builder
              jdkWithFX # JDK
              pkgs.gradle_9 # Gradle

              # LSP
              pkgs.nil # Nix LSP
              pkgs.jdt-language-server # Java LSP by Eclipse team
            ];
          };
        };
    };
}

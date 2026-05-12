{
  description = "rust flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      fenix,
      flake-parts,
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            overlays = [
              fenix.overlays.default
            ];
          };

          devShells.default =
            let
              rust = pkgs.fenix.stable.toolchain;
              libPath = pkgs.lib.makeLibraryPath [ pkgs.libpcap ];
            in
            pkgs.mkShell {
              buildInputs = with pkgs; [
                rust
                rust-analyzer

                iw
                libpcap
              ];
              LD_LIBRARY_PATH = libPath;
              RUSTFLAGS = "-C link-arg=-Wl,-rpath,${libPath}";
            };
        };

      flake = {
        nixosModules.default = import ./nix/nixos-module.nix;
      };
    };
}

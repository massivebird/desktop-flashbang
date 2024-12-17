{
  description = "idk";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    naersk = {
      url = "github:nix-community/naersk/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, naersk, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        naersk-lib = pkgs.callPackage naersk { };
        libPath = with pkgs; lib.makeLibraryPath [
          libGL
          libxkbcommon
          wayland
        ];
      in
        with pkgs;
      {
        packages.default = naersk-lib.buildPackage ./.;

        # for `nix develop`:
        devShell = with pkgs;
          mkShell {
            buildInputs = [
              atk
              cargo
              fontconfig
              gdk-pixbuf
              glib
              libudev-zero
              pango
              pkg-config
              rubyPackages_3_1.gdk3
              rust-analyzer
              rustc
            ];

            RUST_LOG = "debug";
            RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
            LD_LIBRARY_PATH = libPath;
            WINIT_UNIX_BACKEND = "wayland";
          };
      }
    );
}

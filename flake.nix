{
  description = "A simple Go program";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (final: prev: { go = prev.go_1_24; }) ];
        pkgs = import nixpkgs { inherit system overlays; };
      in
      {
        packages.default = pkgs.buildGoModule {
          pname = "gotmpl";
          version = "0.1.0";
          src = ./.;
          vendorHash = "sha256-1g5na3vf1hpijsz2xdg8riv1bv9vvvds5q6pmycdwqqxnfn774b9";
        };
      });
}
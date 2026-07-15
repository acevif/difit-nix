{
  description = "Versioned difit packages for Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        { pkgs, ... }:
        let
          mkDifit = args: pkgs.callPackage ./packages/mkDifit.nix args;
          versioned = {
            difit_5_0_8 = mkDifit {
              version = "5.0.8";
              sourceHash = "sha256-AT2dUT14+yfMLxcJdJC/CI28RfyElsoa97vxUIMjUo0=";
              npmHash = "sha512-4wraDkhacN6VFdFm57GP+0qtimu0vnxgZ3hyVjgVEoU6r4xkH2B/vZoLa0XePYzbIhyZ/xPHYFn6WmVk8OVPCw==";
              pnpmDepsHash = "sha256-CGmYSEbTS3JgVcdxRot8RnYW9FUYQHvwp1nNI/zUM94=";
            };
          };
        in
        {
          packages = versioned // {
            # aliases
            difit_5_0 = versioned.difit_5_0_8;
            difit_5 = versioned.difit_5_0_8;
            difit = versioned.difit_5_0_8;
            default = versioned.difit_5_0_8;
          };

          formatter = pkgs.nixfmt;
        };
    };
}

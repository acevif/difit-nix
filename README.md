# difit-nix

[difit](https://github.com/yoshiko-pg/difit) packaged for [Nix](https://nixos.org/).

## Usage

Run difit:

```console
nix run github:acevif/difit-nix
```

Install it into your profile:

```console
nix profile add github:acevif/difit-nix
```

Or use it as a flake input:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    difit-nix.url = "github:acevif/difit-nix";
  };

  outputs =
    { difit-nix, nixpkgs, ... }:
    let
      # Replace the system when needed.
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [ difit-nix.packages.${system}.difit ];
      };
    };
}
```

The `difit` package and its `default` alias are exposed for `x86_64-linux`, `aarch64-linux`, `x86_64-darwin`, and `aarch64-darwin`.

## Development

Install [devenv](https://devenv.sh/) and [direnv](https://direnv.net/), enable direnv's shell hook, then allow this repository's `.envrc` once:

```console
direnv allow
```

The devenv environment is loaded automatically when you enter the directory and unloaded when you leave it.

Install the [prek](https://github.com/j178/prek) hooks:

```console
prek install
```

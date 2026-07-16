# difit-nix

[difit](https://github.com/yoshiko-pg/difit) packaged for [Nix](https://nixos.org/).

## Usage

Run difit:

```console
nix run 'github:acevif/difit-nix#difit'
```

Install it into your profile:

```console
nix profile add 'github:acevif/difit-nix#difit'
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

Enter the [devenv](https://devenv.sh/) shell:

```console
nix develop --no-pure-eval
```

With direnv and nix-direnv installed, the shell can be loaded automatically:

```console
direnv allow
```

Install and run the [prek](https://github.com/j178/prek) hooks:

```console
prek install
prek run --all-files
```

Run the full validation manually:

```console
nix fmt flake.nix packages/difit.nix
nix flake check --no-pure-eval
gitleaks git --redact .
```

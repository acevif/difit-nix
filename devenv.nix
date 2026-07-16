{ pkgs, ... }:

{
  packages = [
    pkgs.gitleaks
    pkgs.prek
  ];

  enterShell = ''
    if [ ! -f "$DEVENV_ROOT/.git/hooks/pre-commit" ]; then
      printf '%s\n' 'warning: prek hooks are not installed; run `prek install` to install them.' >&2
    fi
  '';
}

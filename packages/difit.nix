{
  lib,
  pkgs,
  stdenv,
  fetchPnpmDeps,
  makeWrapper,
  nodejs_24,
  pnpm_10,
  pnpmConfigHook,
  git,
  gh,
}:

let
  sources = pkgs.callPackage ./_sources/generated.nix { };
  version = lib.removePrefix "v" sources.difit.version;
in
assert version == sources.difit-npm.version;
stdenv.mkDerivation (finalAttrs: {
  pname = "difit";
  inherit version;

  src = sources.difit.src;
  npmPackage = sources.difit-npm.src;

  pnpmWorkspaces = [ "difit" ];
  pnpmInstallFlags = [ "--production" ];
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      pnpmInstallFlags
      ;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-CGmYSEbTS3JgVcdxRot8RnYW9FUYQHvwp1nNI/zUM94=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs_24
    pnpm_10
    pnpmConfigHook
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/difit $out/bin
    tar -xzf ${finalAttrs.npmPackage}
    cp -R package/dist package/package.json node_modules $out/lib/node_modules/difit/

    makeWrapper ${lib.getExe nodejs_24} $out/bin/difit \
      --add-flags "$out/lib/node_modules/difit/dist/cli/index.js" \
      --prefix PATH : ${
        lib.makeBinPath [
          gh
          git
        ]
      }

    runHook postInstall
  '';

  meta = {
    description = "GitHub-style diff viewer for local Git changes";
    homepage = "https://github.com/yoshiko-pg/difit";
    changelog = "https://github.com/yoshiko-pg/difit/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "difit";
    platforms = nodejs_24.meta.platforms;
  };
})

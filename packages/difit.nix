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
stdenv.mkDerivation (finalAttrs: {
  pname = "difit";
  inherit version;

  src = sources.difit.src;

  pnpmWorkspaces = [ "difit" ];
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-cRwlmoYGB0yxrBo3DGh/4DwvmnJhoQXYO3o812uy30k=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs_24
    pnpm_10
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/difit $out/bin
    cp -R dist package.json pnpm-lock.yaml pnpm-workspace.yaml $out/lib/node_modules/difit/

    pushd $out/lib/node_modules/difit
    pnpm install --prod --offline --frozen-lockfile --ignore-scripts
    popd

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

{
  lib,
  stdenv,
  fetchurl,
}:

let
  data = builtins.fromJSON (builtins.readFile ./version.json);
  system = stdenv.hostPlatform.system;

  asset =
    {
      x86_64-linux = "tmux-linux-x86_64";
      aarch64-linux = "tmux-linux-aarch64";
    }
    .${system} or (throw "tmux: unsupported system ${system}");
in
stdenv.mkDerivation {
  pname = "tmux";
  version = data.version;

  src = fetchurl {
    url = "https://github.com/atomic-235/tmux-flake/releases/download/v${data.version}/${asset}";
    hash = data.assets.${system};
  };

  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/bin/tmux"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Terminal multiplexer with clean UTF-8 tree lines (static release binary)";
    homepage = "https://github.com/tmux/tmux";
    license = licenses.isc;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "tmux";
  };
}

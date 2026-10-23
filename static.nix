{
  pkgs,
  ...
}:

# Built by CI, not by consumers: the resulting binary is published as the
# release asset that package.nix fetches.
let
  data = builtins.fromJSON (builtins.readFile ./version.json);
in
pkgs.pkgsStatic.tmux.overrideAttrs (old: {
  version = data.version;

  src = pkgs.fetchFromGitHub {
    owner = "tmux";
    repo = "tmux";
    tag = data.version;
    hash = data.srcHash;
  };

  patches = [ ./clean-tree-lines.patch ];
})

# tmux-flake

tmux with `clean-tree-lines.patch`, built **statically** with
`pkgsStatic.tmux` and published as a single release binary.

Statically linked on purpose: a nixpkgs tmux embeds `/nix/store` paths for
glibc, tzdata and friends, and `fetchurl` refuses fixed-output derivations that
refer to other store paths. The static build has no such references, so the
2 MB asset can be fetched directly.

## Packages

| Attribute | Contents |
|---|---|
| `packages.<system>.default` | the published static binary |
| `packages.<system>.tmux` | alias of `default` |
| `packages.<system>.static` | the `pkgsStatic` build CI publishes from |

`overlays.default` provides `pkgs.tmux`.

## Usage

```nix
{
  inputs.tmux-flake.url = "github:atomic-235/tmux-flake";
  inputs.tmux-flake.inputs.nixpkgs.follows = "nixpkgs";
}
```

```nix
nixpkgs.overlays = [ inputs.tmux-flake.overlays.default ];
# pkgs.tmux
```

## Updates

CI runs weekly (Monday 06:00 UTC): resolve the newest nixpkgs `tmux` version,
build `.#static^out` (the `out` output — `nix build` prints every output of a
multi-output derivation), upload `tmux-linux-x86_64`, verify the flake can
fetch it, commit and tag `v<version>`.

Supported: `x86_64-linux`, `aarch64-linux`.

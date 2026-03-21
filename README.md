# dotfiles

Personal dotfiles managed with `git` + `make`. No third-party tools required.

## Quickstart

```sh
git clone https://github.com/adeshmukh/dotfiles.git ~/.local/dotfiles
cd ~/.local/dotfiles
make install        # symlink dotfiles into $HOME
make packages       # (separate step) install system packages for this platform
```

Open a new shell or `source ~/.zshrc` to pick up the changes.

## What `make install` does

- Symlinks each file in `src/` to `~/.<name>` (e.g. `src/gitconfig` → `~/.gitconfig`)
- Symlinks `src/shellrc.d/` to `~/.shellrc.d/`
- Symlinks `src/claude/settings.json` and `src/claude/statusline-command.sh` into `~/.claude/`

Safe to re-run — existing symlinks are replaced, nothing is copied.

## Shell config loading

Both `~/.zshrc` (primary) and `~/.bashrc` source shell config in three tiers:

```
~/.shellrc.d/                   # base — always sourced
~/.shellrc.d/platform/darwin/   # sourced on macOS
~/.shellrc.d/platform/linux/    # sourced on Linux
~/.shellrc.d/host/<hostname>/   # sourced on that host only
```

Later tiers override earlier ones. Missing tiers are silently skipped.

## Extensibility

**Host-specific config** — drop a `.sh` file into `src/shellrc.d/host/<hostname>/`.
It will be sourced automatically on that host. Commit it if shareable; gitignore it if not.

**Secrets** — create `src/shellrc.d/host/<hostname>/secrets.sh` and add it to `.gitignore`.
It will be sourced at shell startup without ever being committed.

**New platform** — add a directory under `src/shellrc.d/platform/` matching `uname -s` lowercased
(e.g. `platform/linux/` for Linux). Drop `.sh` files in; they're picked up automatically.

## System packages

Platform-specific package manifests live in `packages/`:

| File | Platform | Tool |
|---|---|---|
| `packages/Brewfile` | macOS | `brew bundle` |
| `packages/Aptfile` | Debian/Ubuntu | `apt-bundle` |
| `packages/Yumfile` | RHEL/CentOS | `yum` |

Run `make packages` to install for the current platform.

## Keeping in sync

```sh
make sync           # git pull --rebase
```

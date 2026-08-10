# Dotfiles

Personal config files, tracked with a **bare git repository** whose work tree is `$HOME`.
Used on both macOS and Linux (Omarchy/Arch).

There is no symlinking and no install script: the files live exactly where the programs
expect them (`~/.config/nvim/init.lua`, `~/.bashrc`, …), and git just tracks them in place.
The repo data itself lives in `~/.dotfiles/` (a bare repo — not a normal `.git` directory).

Remote: `git@github.com:erialbin/dotfilesv2.git` (branch `main`)

## The `dotfiles` command

Because the repo is bare and lives outside its work tree, every git command needs to be
told where both are. That's what this alias does:

```fish
# fish — .config/fish/config.fish
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME/'
```

```bash
# bash — ~/.bashrc
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME/'
```

It is defined in both [`.config/fish/config.fish`](.config/fish/config.fish) and
[`.bashrc`](.bashrc), so after the first install it's available in a new shell on either
platform.

From then on, `dotfiles` behaves like `git` for anything under `$HOME`:

```
dotfiles status
dotfiles add .config/nvim/lua/plugins/telescope.lua
dotfiles commit -m "tweak telescope keymaps"
dotfiles push
dotfiles lola          # git aliases from .config/git/config work too
```

Important: `dotfiles add` only tracks files you name explicitly. Never run
`dotfiles add -A` or `dotfiles add .` from `$HOME` — that would try to add your entire
home directory.

## What's tracked

| Area | Path |
| --- | --- |
| Fish shell | `.config/fish/config.fish`, `.config/fish/conf.d/`, `.config/fish/fish_variables` |
| Bash | `.bashrc` (Omarchy/Linux machine) |
| Neovim | `.config/nvim/` (lazy.nvim, plugin specs under `lua/plugins/`, snippets under `lua/luasnippets/`) |
| tmux | `.config/tmux/tmux.conf` (prefix `C-Space`, vi copy mode) |
| Git | `.config/git/config` (aliases, rebase-on-pull, rerere), `.config/git/ignore` |
| Prompt | `.config/starship.toml` |
| Terminal | `.config/alacritty/alacritty.toml` (Tokyo Night, JetBrainsMono Nerd Font) |
| Claude Code | `.claude/settings.json` |
| This file | `README.md` |

## Installing on a new machine

### 0. Install the programs first

Nothing here installs software; the configs assume it's present. Install at least `git`
and `fish` before starting, and ideally the rest — `config.fish` calls `starship`,
`zoxide` and `fastfetch` unconditionally at startup, so a missing one prints an error in
every new shell.

**macOS** (via [Homebrew](https://brew.sh)):

```bash
brew install fish neovim tmux git starship zoxide fastfetch
brew install --cask alacritty font-jetbrains-mono-nerd-font
```

**Arch / Omarchy:**

```bash
sudo pacman -S fish neovim tmux git starship zoxide fastfetch alacritty ttf-jetbrains-mono-nerd
```

Omarchy already ships some of these (Alacritty, Neovim) — check before reinstalling.

**Debian / Ubuntu:**

```bash
sudo apt install fish neovim tmux git alacritty fonts-jetbrains-mono
```

`starship`, `zoxide` and `fastfetch` are old or absent in Debian/Ubuntu repos; prefer their
own installers (e.g. `curl -sS https://starship.rs/install.sh | sh`). The `fonts-jetbrains-mono`
package is **not** the Nerd Font patch — download JetBrainsMono from
[nerdfonts.com](https://www.nerdfonts.com/) into `~/.local/share/fonts` and run `fc-cache -f`,
or icons in starship/nvim will render as boxes.

### 1. Clone the repo bare

Identical on both platforms:

```
git clone --bare git@github.com:erialbin/dotfilesv2.git $HOME/.dotfiles
```

(Use `https://github.com/erialbin/dotfilesv2.git` if SSH keys aren't set up on the machine
yet.)

### 2. Define the alias for this shell session

The alias isn't available yet — it lives in a file that hasn't been checked out. Define it
temporarily, in whatever shell you're currently in:

```bash
# bash / zsh — the login shell on a fresh macOS or Debian box
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME/'
```

```fish
# fish
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME/'
```

### 3. Check out the files into `$HOME`

```
dotfiles checkout main
```

If the machine already has some of these files (a stock `.bashrc`, a default
`config.fish`), git refuses and lists the conflicting paths tab-indented. Back them up and
retry — pick the snippet for your current shell:

```bash
# bash / zsh
mkdir -p "$HOME/.dotfiles-backup"
dotfiles checkout main 2>&1 | awk '/^\t/ {print $1}' | while read -r f; do
  mkdir -p "$HOME/.dotfiles-backup/$(dirname "$f")"
  mv "$HOME/$f" "$HOME/.dotfiles-backup/$f"
done
dotfiles checkout main
```

```fish
# fish
mkdir -p $HOME/.dotfiles-backup
for f in (dotfiles checkout main 2>&1 | awk '/^\t/ {print $1}')
    mkdir -p $HOME/.dotfiles-backup/(dirname $f)
    mv $HOME/$f $HOME/.dotfiles-backup/$f
end
dotfiles checkout main
```

Both use `awk` rather than `grep -E '^\s+\.'`, because `\s` isn't supported by the BSD grep
that ships with macOS and would silently match nothing there.

Or, if you're sure you want the repo's versions: `dotfiles checkout -f main`.

### 4. Silence untracked files

Without this, `dotfiles status` lists every file in your home directory. The setting is
local to the clone, so it must be repeated on each new machine:

```
dotfiles config --local status.showUntrackedFiles no
```

### 5. Make fish the login shell

```bash
# macOS (Apple Silicon)
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish

# Linux
echo /usr/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/bin/fish
```

Log out and back in. The `dotfiles` alias now comes from the checked-out config.

### 6. Fix up the machine-specific paths

See the table below — `alacritty.toml` and `tmux.conf` hardcode a fish path that is only
correct on one of the two platforms.

### 7. Launch Neovim

`lazy.nvim` bootstraps itself and installs all plugins on first start. Run `:checkhealth`
afterwards; some LSPs and formatters configured under `lua/plugins/` need their language
toolchains installed separately.

## macOS vs Linux differences

| | macOS (Apple Silicon) | Linux |
| --- | --- | --- |
| fish binary | `/opt/homebrew/bin/fish` | `/usr/bin/fish` |
| Homebrew prefix | `/opt/homebrew` (Intel: `/usr/local`) | n/a |
| `alacritty.toml` → `shell.program` | `/opt/homebrew/bin/fish` ✅ as committed | needs editing to `/usr/bin/fish` |
| `tmux.conf` → `default-shell` | `/bin/fish` ✗ doesn't exist | `/bin/fish` — valid if fish is at `/usr/bin/fish` with a `/bin` symlink, else edit |
| `.bashrc` | sources Omarchy defaults that aren't there | ✅ as committed |
| Font install | `brew install --cask font-…` | `~/.local/share/fonts` + `fc-cache -f` |

The committed `tmux.conf` points `default-shell` at `/bin/fish`, which does not exist on
macOS. tmux silently ignores the invalid path and falls back to `$SHELL`, so it works out
as long as your login shell is already fish (step 5) — but it would drop you into `/bin/sh`
if it isn't. The `brew shellenv` block in `config.fish` is already guarded by
`test -x /opt/homebrew/bin/brew`, so it's a no-op on Linux.

## Dependencies

Core: `fish`, `neovim` (0.10+), `tmux`, `git`, `alacritty`,
[JetBrainsMono Nerd Font](https://www.nerdfonts.com/).

Called unconditionally by `config.fish` at startup: `starship`, `zoxide`, `fastfetch`.
Install them or delete the corresponding line.

Optional: `uv` (sourced from `conf.d/uv.env.fish`), `cargo`/rustup (sourced from
`.bashrc`), `try`, Homebrew (macOS).

## Notes and gotchas

- **Not tracked, but referenced:** `tmux.conf` binds `prefix + f` to
  `~/.local/scripts/tmux-sessionizer`, which is not in this repo. Copy it over manually or
  the keybind is a no-op.
- **Broken uv sourcing:** `conf.d/uv.env.fish` sources `~/.local/bin/env.fish` and
  `.bashrc` sources `~/.local/bin/env`. Neither file exists unless uv was installed with its
  standalone installer, and fish prints an error on every shell start when it's missing.
  Install uv (`curl -LsSf https://astral.sh/uv/install.sh | sh`) or delete those lines.
- **`/usr/bin/fish` in `config.fish`:** the `try` block runs `env SHELL=/usr/bin/fish`, a
  Linux path, on both platforms. It only sets a string that `try` reads to pick its output
  syntax, so it works on macOS regardless — but it's misleading.
- **Global gitignore:** `.config/git/ignore` applies to *all* repos on the machine, not
  just this one. It currently excludes `**/.claude/settings.local.json`,
  `compile_commands.json` and `.DS_store`.
- **Secrets:** everything here is public. Don't track anything with credentials —
  `.claude/settings.json` is fine, but API keys, SSH keys and `.env` files are not.

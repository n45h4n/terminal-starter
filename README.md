# Terminal Starter Kit

This is a small, beginner-friendly terminal setup for macOS,
Linux Mint/Ubuntu, and Arch Linux users.

It installs a nicer prompt, helpful command-line tools, and a simple `.zshrc`
that is safe to read and change later.

## What It Provides

- Zsh configuration with simple history, completion, and aliases
- Starship prompt
- zsh-autosuggestions
- zsh-syntax-highlighting
- fzf for fuzzy searching command history and files
- zoxide for jumping to folders you use often
- eza, a friendlier `ls`
- bat, a friendlier `cat`
- fd, a friendlier `find`
- ripgrep, a friendlier `grep`
- tldr, short examples for common commands
- neovim, a terminal text editor
- lazygit, a terminal UI for Git
- yazi, a terminal file manager
- less, tree, jq, zip, and unzip for common terminal workflows

Exact package installation varies by platform and apt repository availability;
see the package lists below.

All installers back up your existing `~/.zshrc` and
`~/.config/starship.toml` before replacing them.

## Supported Systems

- macOS with Homebrew
- Linux Mint/Ubuntu with apt
- Arch Linux with pacman only, no AUR

## Package Lists

macOS Homebrew packages:

```text
starship
zsh
zsh-autosuggestions
zsh-syntax-highlighting
fzf
zoxide
eza
bat
fd
ripgrep
tldr
neovim
lazygit
yazi
jq
tree
```

macOS already provides `less`, `zip`, and `unzip`, so the installer does not
install those through Homebrew.

Linux Mint/Ubuntu required apt packages:

```text
curl
git
wget
ca-certificates
zsh
less
tree
jq
zip
unzip
neovim
```

Linux Mint/Ubuntu optional apt packages:

```text
zsh-autosuggestions
zsh-syntax-highlighting
fzf
eza
bat
fd-find
ripgrep
tldr
starship
zoxide
lazygit
yazi
```

If `starship` or `zoxide` are not available from apt, the installer uses their
official install scripts. If `lazygit` or `yazi` are not available from apt,
the installer skips them and continues.

Arch Linux pacman packages:

```text
git
curl
wget
ca-certificates
zsh
starship
zsh-autosuggestions
zsh-syntax-highlighting
fzf
zoxide
eza
bat
fd
ripgrep
tldr
less
tree
jq
zip
unzip
neovim
lazygit
yazi
```

## macOS Install

This installer uses Homebrew. It will not install Homebrew for you.

1. Make sure Homebrew is already installed:

   ```bash
   brew --version
   ```

2. Run the macOS installer from this folder:

   ```bash
   bash install_macos.sh
   ```

3. Open a new terminal window.

The installer does not automatically change your login shell. If zsh is not
your login shell, the installer will print a `chsh` command you can run
yourself.

## Linux Mint/Ubuntu Install

This installer uses `apt` where possible. It uses the official Starship and
zoxide install scripts only if those tools are not available from `apt`.
Optional apt packages may be skipped if they are not available from your
Linux Mint/Ubuntu apt repositories.

Run from this folder:

```bash
bash install_linux_mint.sh
```

Then open a new terminal window.

The installer does not automatically change your login shell. If zsh is not
your login shell, the installer will print a `chsh` command you can run
yourself.

## Arch Linux Install

This installer uses `pacman` only. It does not use AUR.

Run from this folder:

```bash
bash install_arch.sh
```

Then open a new terminal window.

The installer does not automatically change your login shell. If zsh is not
your login shell, the installer will print a `chsh` command you can run
yourself.

## Commands To Learn First

- `ls` shows files and folders.
- `ll` shows a detailed file list.
- `la` shows all files, including hidden files.
- `lt` shows files as a small tree.
- `z <folder>` jumps to a folder you have visited before.
- `Ctrl-R` searches your command history.
- `bat <file>` prints a file with nicer colors.
- `rg <text>` searches for text inside files.
- `fd <name>` searches for files and folders by name.
- `tldr <command>` shows short examples for a command.

Example:

```bash
tldr rg
```

## How To Undo

The installer saves your old zsh and Starship configs before replacing them.
Backups look like:

```text
~/.zshrc.backup.20260624-153000
~/.config/starship.toml.backup.20260624-153000
```

To restore `.zshrc`, replace `BACKUP_FILE` with the backup file you want:

```bash
cp BACKUP_FILE ~/.zshrc
```

If the backup is a symlink, `cp` copies the symlink target's contents instead
of restoring the symlink. To restore the symlink itself, use:

```bash
mv ~/.zshrc "$HOME/.zshrc.starter.$(date +%Y%m%d-%H%M%S)-$$"
ln -s "$(readlink BACKUP_FILE)" ~/.zshrc
```

Then open a new terminal window.

To restore Starship, replace `BACKUP_FILE` with the backup file you want:

```bash
cp BACKUP_FILE ~/.config/starship.toml
```

You can also remove the Starship config:

```bash
rm ~/.config/starship.toml
```

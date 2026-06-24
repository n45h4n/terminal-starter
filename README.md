# Terminal Starter Kit

This is a small, beginner-friendly terminal setup for one macOS user and one
Linux Mint user.

It installs a nicer prompt, helpful command-line tools, and a simple `.zshrc`
that is safe to read and change later.

## What It Installs

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

The installer backs up your existing `~/.zshrc` before replacing it.

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

If zsh is not your login shell, the installer will print a `chsh` command you
can run yourself.

## Linux Mint Install

This installer uses `apt` where possible. It uses the official Starship and
zoxide install scripts only if those tools are not available from `apt`.
Some optional tools, such as `eza` or `tldr`, may be skipped if they are not
available from your Linux Mint apt repositories.

Run from this folder:

```bash
bash install_linux_mint.sh
```

Then open a new terminal window.

If zsh is not your login shell, the installer will print a `chsh` command you
can run yourself.

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

The installer saves your old zsh config before replacing it. Backups look like:

```text
~/.zshrc.backup.20260624-153000
```

To restore one, replace `BACKUP_FILE` with the backup file you want:

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

You can also remove the Starship config:

```bash
rm ~/.config/starship.toml
```

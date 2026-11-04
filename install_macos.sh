#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
zshrc_source="$script_dir/zsh/.zshrc"
starship_source="$script_dir/starship/starship.toml"
zshrc_target="$HOME/.zshrc"
starship_target="$HOME/.config/starship.toml"

info() {
  printf '\n==> %s\n' "$1"
}

require_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi

  if [ -x "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    return
  fi

  if [ -x "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
    return
  fi

  cat >&2 <<'EOF'
Homebrew is required, but it was not found.

Install Homebrew from https://brew.sh, then run this script again.
This script will not install Homebrew automatically.
EOF
  exit 1
}

install_packages() {
  info "Installing terminal tools with Homebrew"
  brew update
  brew install \
    starship \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    fzf \
    zoxide \
    eza \
    bat \
    fd \
    ripgrep \
    neovim \
    lazygit \
    yazi \
    jq \
    tree
}

next_backup_path() {
  local target_path="$1"
  local base_path
  local backup_path
  local suffix=1

  base_path="$target_path.backup.$(date +%Y%m%d-%H%M%S)"
  backup_path="$base_path"

  while [ -e "$backup_path" ] || [ -L "$backup_path" ]; do
    backup_path="$base_path.$suffix"
    suffix=$((suffix + 1))
  done

  printf '%s\n' "$backup_path"
}

install_config_file() {
  local source_path="$1"
  local target_path="$2"
  local display_path="$3"
  local backup_path

  if [ ! -e "$target_path" ] && [ ! -L "$target_path" ]; then
    cp "$source_path" "$target_path"
    info "Installed $display_path"
    return
  fi

  if [ -L "$target_path" ]; then
    backup_path="$(next_backup_path "$target_path")"
    cp -P "$target_path" "$backup_path"
    unlink "$target_path"
    cp "$source_path" "$target_path"
    info "Backed up existing $display_path symlink to $backup_path and replaced it"
    return
  fi

  if cmp -s "$source_path" "$target_path"; then
    info "Existing $display_path already matches this starter kit"
    return
  fi

  backup_path="$(next_backup_path "$target_path")"
  cp "$target_path" "$backup_path"
  cp "$source_path" "$target_path"
  info "Backed up existing $display_path to $backup_path and replaced it"
}

install_configs() {
  info "Installing zsh and Starship config"
  mkdir -p "$HOME/.config"
  install_config_file "$zshrc_source" "$zshrc_target" ".zshrc"
  install_config_file "$starship_source" "$starship_target" "starship.toml"
}

print_next_steps() {
  cat <<'EOF'

Done.

Open a new terminal window, or run:
  exec zsh

This script did not change your login shell automatically.
If zsh is not your login shell yet, you can run:
  chsh -s "$(command -v zsh)"

EOF
}

main() {
  require_homebrew
  install_packages
  install_configs
  print_next_steps
}

main "$@"

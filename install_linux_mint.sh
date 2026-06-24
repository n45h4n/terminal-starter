#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
zshrc_source="$script_dir/zsh/.zshrc"
starship_source="$script_dir/starship/starship.toml"
zshrc_target="$HOME/.zshrc"
starship_target="$HOME/.config/starship.toml"
local_bin="$HOME/.local/bin"
export PATH="$local_bin:$PATH"

info() {
  printf '\n==> %s\n' "$1"
}

install_core_packages() {
  info "Installing core packages with apt"
  sudo apt update
  sudo apt install -y \
    curl \
    git \
    wget \
    ca-certificates \
    zsh
}

try_apt_install() {
  local package="$1"

  if sudo apt install -y "$package"; then
    return
  fi

  info "Could not install $package with apt; continuing"
}

install_optional_apt_packages() {
  info "Installing optional terminal tools with apt"

  try_apt_install zsh-autosuggestions
  try_apt_install zsh-syntax-highlighting
  try_apt_install fzf
  try_apt_install eza
  try_apt_install bat
  try_apt_install fd-find
  try_apt_install ripgrep
  try_apt_install tldr
  try_apt_install starship
  try_apt_install zoxide
}

ensure_local_bin() {
  mkdir -p "$local_bin"
}

ensure_debian_tool_names() {
  ensure_local_bin

  if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
    create_safe_symlink "$(command -v batcat)" "$local_bin/bat"
  fi

  if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    create_safe_symlink "$(command -v fdfind)" "$local_bin/fd"
  fi
}

create_safe_symlink() {
  local target="$1"
  local link_path="$2"

  if [ -e "$link_path" ] && [ ! -L "$link_path" ]; then
    info "Skipping $link_path because it already exists and is not a symlink"
    return
  fi

  ln -sfn "$target" "$link_path"
  info "Created $link_path pointing to $target"
}

install_starship_if_needed() {
  if command -v starship >/dev/null 2>&1; then
    return
  fi

  info "Installing Starship with the official install script"
  curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b "$local_bin"
}

install_zoxide_if_needed() {
  if command -v zoxide >/dev/null 2>&1; then
    return
  fi

  info "Installing zoxide with the official install script"
  curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
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
  local zsh_path
  zsh_path="$(command -v zsh || true)"

  cat <<EOF

Done.

Open a new terminal window, or run:
  exec zsh

This script did not change your login shell automatically.
If zsh is not your login shell yet, you can run:
  chsh -s $zsh_path

EOF
}

main() {
  ensure_local_bin
  install_core_packages
  install_optional_apt_packages
  ensure_debian_tool_names
  install_starship_if_needed
  install_zoxide_if_needed
  install_configs
  print_next_steps
}

main "$@"

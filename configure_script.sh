#!/bin/bash

# ===== CONFIGURATIONS ===== #
XDG_CONFIG_HOME="$HOME/.config"

# zsh constants
ZSH_PATH="$HOME/.zshrc"
ZSH_BIN="/bin/zsh"

# script constants
SCRIPT_FILE="$(basename "$0")"
SCRIPT_PATH="$(realpath "$0")"
DRY_RUN=false

# git constants
NEOVIM_URL_GIT="https://github.com/Arthur-Negrao-Smith/My-nvim-config.git"
NEOVIM_CONFIG_PATH="$XDG_CONFIG_HOME/nvim"

# sddm constants
SDDM_CONFIG_PATH="/etc/sddm.conf.d"
SDDM_THEMES_PATH="/usr/share/sddm/themes"
SDDM_THEME_TAR_FILE="sugar-candy.tar.gz"

# hyprpaper constants
WALLPAPER_DIR_PATH="$HOME/Images/Wallpapers"

CONFIG_DIRS=(
  "dunst"
  "alacritty"
  "hypr"
  "rofi"
  "scripts"
  "swayidle"
  "waybar"
  "wlogout"
  "yazi"
)

# pacman packages to install
PACMAN_PACKAGES=(
  "alacritty"
  "rofi"
  "swayidle"
  "dunst"
  "stow"
  "zsh"
  "nvim"
  "sddm"
  "yazi"
  "tar"
  "qt5‑graphicaleffects"
  "qt5‑quickcontrols2"
  "qt5‑svg"
)

# yay packages to install
YAY_PACKAGES=(
  "waybar"
  "wlogout"
)


# ===== COLORS ===== #
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RED="\e[31m"
RESET="\e[0m"

log() {
  echo -e "${BLUE}󰆧 $1${RESET}"
}

warn() {
  echo -e "${YELLOW}⚠️ $1${RESET}"
}

success() {
  echo -e "${GREEN} $1${RESET}"
}

error() {
  echo -e "${RED}❌ $1${RESET}"
}

# ===== DRY RUN ===== #
run_cmd() {
  if $DRY_RUN; then
    echo -e "${YELLOW}DRY-RUN:${RESET} $*"
  else
    eval "$@"
  fi
}


# ===== FUNCTIONS ===== #
# function to create the components' dirs
create_config_dirs() {
  log "Creating configuration directories..."
  for dir in "${CONFIG_DIRS[@]}"; do
    run_cmd mkdir -p "${XDG_CONFIG_HOME}/${dir}"
  done
}

# updating all system packages
update_system() {
  log "Updating system packages..."
  run_cmd sudo pacman -Syu --noconfirm
  run_cmd yay
}

# install all needed packages
install_packages() {
  log "Installing packages from Packman..."
  run_cmd sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"

  log "Installing packages from Yay..."
  run_cmd yay -S --needed --noconfirm "${YAY_PACKAGES[@]}"
}

backup_if_exists() {
    target="$1"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
      warn "$target already exists. Creating backup as $target.bak"
      run_cmd mv "$target" "$target.bak"
    fi
}

# making backups to all existent configs files
backup_existing_configs() {
  log "Checking for conflicts before using stow..."

  for dir in "${CONFIG_DIRS[@]}" zsh; do
    if [ "$dir" == "zsh" ]; then
      target="$HOME/.zshrc"
    else
      target="$XDG_CONFIG_HOME/$dir"
    fi

    backup_if_exists "$target"

  done
}

# creating symbolic links
stow_configs() {
  log "Creating symbolic links with stow..."
  for dir in "${CONFIG_DIRS[@]}"; do
    run_cmd stow "$dir"
  done
  run_cmd stow zsh
}

# changing actual shell
change_shell_to_zsh() {
  log "Changing the current shell..."
  run_cmd chsh -s "$ZSH_BIN"
  run_cmd source "$ZSH_PATH"
}

# add neovim config
change_config_neovim() {
  backup_if_exists "$NEOVIM_CONFIG_PATH"

  log "Cloning the neovim config repository..."
  run_cmd git clone "$NEOVIM_URL_GIT" "$NEOVIM_CONFIG_PATH"
}

# changing the configure script name
change_config_script_name() {
  log "Renaming the configuration script from '$SCRIPT_FILE' to '$SCRIPT_FILE.used'..."
  run_cmd mv $SCRIPT_PATH "$SCRIPT_PATH.used"
}

configure_sddm() {
  log "Configuring the sddm to login in system..."
  log "Creating directorys: '$SDDM_CONFIG_PATH' and '$SDDM_THEMES_PATH'..."
  run_cmd mkdir -p "$SDDM_CONFIG_PATH"
  run_cmd mkdir -p "$SDDM_THEMES_PATH"

  log "Writing in file: $SDDM_CONFIG_PATH/theme.conf"
  run_cmd echo -e "
[Theme]
Current=sugar-candy" > "$SDDM_CONFIG_PATH/theme.conf"

  log "Extracting files from '$SDDM_THEME_TAR_FILE' to '$SDDM_THEMES_PATH'..."
  run_cmd sudo tar -xzvf "$SDDM_THEME_TAR_FILE" -C "$SDDM_THEMES_PATH"

  log "Initializing the sddm service"
  run_cmd systemctl enable sddm.service
}

configure_hyprpaper() {
  log "Creating wallpaper directory '$WALLPAPER_DIR_PATH'"
  run_cmd mkdir -p "$WALLPAPER_DIR_PATH"
}

# run all functions
main() {
  create_config_dirs

  update_system
  install_packages

  backup_existing_configs
  stow_configs

  change_shell_to_zsh
  change_config_neovim

  configure_sddm

  configure_hyprpaper

  change_config_script_name

  success "Installation completed successfully!"
  exit 0
}


# ===== PARSE ARGS ===== #
show_help() {
  echo -e "

Usage: $SCRIPT_FILE [OPTION]

Options:
  --run             Run the script in real mode (all changes are made)
  -d, --dry-run     Run the script in simulation mode (no changes made)
  -h, --help        Show this help message and exit

Returns:
  0                 If the script was a success
  1                 If an error occurs in runtime
  2                 If the arguments are invalid
  3                 If the number of arguments are invalid
"
}

# Parse arguments to use the script
parse_args() {
  # test number of arguments
  if [[ $# -ne 1 ]]; then
    error "Bad usage: Exactly one argument is required."
    show_help
    exit 3
  fi

  # check the argument
  case "$1" in
    -d|--dry-run)
      DRY_RUN=true
      warn "Dry-run mode enabled. No changes will be made."
      main
      ;;
    --run)
      warn "Run mode enabled. All changes will be made."
      main
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      error "Unknown option: $1"
      show_help
      exit 2
      ;;
  esac
}

# ===== RUN PARSER =====
parse_args "$@"

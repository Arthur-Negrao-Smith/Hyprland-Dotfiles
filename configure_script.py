import os
import sys
import subprocess as sbp
import logging
from datetime import datetime

logging.getLogger().setLevel(logging.ERROR)
log: logging.Logger = logging.getLogger(__name__)
LOG_FILE: str = "log.txt"

# ==== CONFIGURATIONS ==== #
HOME: str = os.path.expanduser("~")
XDG_CONFIG_HOME: str = f"{HOME}/.config"

# zsh constants
ZSH_PATH: str = f"{HOME}/.zshrc"
ZSH_BIN: str = "/bin/zsh"

# script constants
SCRIPT_FILE: str = os.path.basename(__file__)
SCRIPT_PATH: str = __file__
DRY_RUN: bool = False

# git constants
NEOVIM_URL_GIT: str = "https://github.com/Arthur-Negrao-Smith/My-nvim-config.git"
NEOVIM_CONFIG_PATH: str = f"{XDG_CONFIG_HOME}/nvim"

# sddm constants
SDDM_CONFIG_PATH: str = "/etc/sddm.conf.d"
SDDM_THEMES_PATH: str = "/usr/share/sddm/themes"
SDDM_THEME_TAR_FILE: str = "sugar-candy.tar.gz"

# hyprpaper constants
WALLPAPER_DIR_PATH: str = f"{HOME}/Images/Wallpapers"

CONFIG_DIRS: tuple[str, ...] = (
    "dunst",
    "alacritty",
    "hypr",
    "rofi",
    "scripts",
    "swayidle",
    "waybar",
    "wlogout",
    "yazi",
    "dunst",
    "eww",
    "systemd",
    "zsh",
)

# pacman packages to install
PACMAN_PACKAGES: tuple[str, ...] = (
    "alacritty",
    "rofi",
    "swayidle",
    "dunst",
    "stow",
    "zsh",
    "nvim",
    "sddm",
    "yazi",
    "tar",
    "qt5‑graphicaleffects",
    "qt5‑quickcontrols2",
    "qt5‑svg",
    "jq",
    "sensors",
)

# yay packages to install
YAY_PACKAGES: tuple[str, ...] = ("waybar", "wlogout", "cava")

# pywal files
PYWAL_LINKS: tuple[str, ...] = ("waybar", "wlogout", "rofi")

PYWAL_TEMPLATES_FILES: tuple[str, ...] = (
    "colors-waybar.css",
    "colors-waybar.css",  # to use in wlogout
    "colors-rofi-dark.rasi",
)

PYWAL_TEMPLATES_PATH: str = f"{HOME}/.cache/wal/templates"


# ==== COLORS ==== #
class COLORS:
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    BLUE = "\033[94m"
    RED = "\033[91m"
    RESET = "\033[0m"


# ==== FUNCTIONS ==== #
def show_command(args: tuple, dry_run: bool) -> None:
    """
    Function to show the bash commands
    """
    if dry_run:
        print(f"{COLORS.YELLOW}DRY-RUN: {COLORS.RESET}", end="")
    else:
        print(f"{COLORS.YELLOW}RUN: {COLORS.RESET}", end="")

    print(f"{COLORS.BLUE}{args[0]}{COLORS.RESET} ", end="")
    for arg in args[1:]:
        print(f"{arg} ", end="")
    print()

    log.info(f"Commands: {args}")


def run_cmd(*args, dry_run: bool = True) -> sbp.CompletedProcess | None:
    """
    Function to run bash commands
    """
    if dry_run:
        show_command(args, dry_run=dry_run)
    else:
        show_command(args, dry_run=dry_run)
        return sbp.run(args)


def show_help() -> None:
    """
    Show the script usage
    """
    print(
        f"""

Usage: {SCRIPT_FILE} [OPTIONS]

Options:
  --run             Run the script in real mode (all changes are made)
  --dry-run         Run the script in simulation mode (no changes made)
  -d, --debug       Active logs and save in the file "{LOG_FILE}"
  -h, --help        Show this help message and exit

Returns:
  0                 If the script was a success
  1                 If an error occurs in runtime
  2                 If the arguments are invalid
  3                 If the number of arguments are invalid
"""
    )


def create_config_dirs(dry_run: bool = True):
    print("Creating configuration directories...")
    log.info("Creating configuration directories...")
    for dir in CONFIG_DIRS:
        run_cmd("mkdir", "-p", f"{XDG_CONFIG_HOME}/{dir}", dry_run=dry_run)


def update_system(dry_run: bool = True):
    pass


def install_packages(dry_run: bool = True):
    pass


def backup_existing_configs(dry_run: bool = True):
    pass


def stow_configs(dry_run: bool = True):
    pass


def change_shell_to_zsh(dry_run: bool = True):
    pass


def change_config_neovim(dry_run: bool = True):
    pass


def configure_sddm(dry_run: bool = True):
    pass


def configure_hyprpaper(dry_run: bool = True):
    pass


def change_config_script_name(dry_run: bool = True):
    pass


def main(dry_run: bool = True):
    start: datetime = datetime.now()

    create_config_dirs(dry_run)

    update_system(dry_run)
    install_packages(dry_run)

    backup_existing_configs(dry_run)
    stow_configs(dry_run)

    change_shell_to_zsh(dry_run)
    change_config_neovim(dry_run)

    configure_sddm(dry_run)

    configure_hyprpaper(dry_run)

    change_config_script_name(dry_run)

    finish: datetime = datetime.now()

    log.info(
        f"""Script Finished:
    Started at {start}
    Finished at {finish}
    Total time: {finish-start}"""
    )
    print(f"\n{COLORS.GREEN}>>> Installation completed successfully! <<<{COLORS.RESET}")
    exit(0)


def parse_args(args: list) -> None:
    """
    Function to parse args and run main function
    """
    # test number of arguments
    if len(args) != 2 and len(args) != 3:
        print(args)
        print("Bad usage: Exactly one or two arguments are required.")
        show_help()
        exit(3)

    if ("-h" in args) or ("--help" in args):
        show_help()
        exit(0)

    debug_on = False
    dry_run: bool | None = None

    # check the arguments
    for arg in args[1:]:
        if arg == "--dry-run":
            if dry_run is None:
                print(
                    f"""{COLORS.YELLOW}
######################################################
>>> Dry-run mode enabled. No changes will be made. <<<
######################################################
{COLORS.RESET}"""
                )
                dry_run = True

        elif arg == "--run":
            if dry_run is None:
                print(
                    f"""{COLORS.YELLOW}
###################################################
>>> Run mode enabled. All changes will be made. <<<
###################################################
{COLORS.RESET}"""
                )
                dry_run = False

        elif (arg == "-d") or (arg == "--debug"):
            debug_on = True

        else:
            print(f"{COLORS.RED}Unknown option: {args[1]}{COLORS.RESET}")
            show_help()
            exit(2)

    if debug_on:
        root = logging.getLogger()
        # remove previous handlers
        for h in root.handlers[:]:
            root.removeHandler(h)

        # file handler to save the LOG_FILE
        fh = logging.FileHandler(LOG_FILE)
        formatter = logging.Formatter("%(levelname)s - %(message)s")
        fh.setFormatter(formatter)
        fh.setLevel(logging.DEBUG)

        # To show stderr
        sh = logging.StreamHandler()
        sh.setFormatter(formatter)
        sh.setLevel(logging.DEBUG)

        root.addHandler(fh)
        root.addHandler(sh)
        root.setLevel(logging.DEBUG)

    if dry_run is None:
        print(
            f'{COLORS.RED}The flags "--dry-run" or "--run" are required.{COLORS.RESET}'
        )
        show_help()
        exit(2)

    elif dry_run:
        log.warning("Dry-run mode enabled.")

    else:
        log.warning("Run mode enabled.")

    main(dry_run=dry_run)


# ==== RUN ==== #
parse_args(sys.argv)

import os
import sys
import subprocess as sbp
import logging
from datetime import datetime
from pathlib import Path

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
USED_STATE_FILE: str = ".already_configured"

# Assets
ASSETS_PATH: str = "assets"

# sddm constants
SDDM_CONFIG_PATH: str = "/etc/sddm.conf.d"
SDDM_THEMES_PATH: str = "/usr/share/sddm/themes"
SDDM_THEME_TAR_FILE: str = f"{ASSETS_PATH}/sugar-candy.tar.gz"

# hyprpaper constants
WALLPAPER_DIR_PATH: str = f"{HOME}/Images/Wallpapers"
DEFAULT_WALLPAPER_ASSET: str = f"{ASSETS_PATH}/default_wallpaper.jpg"
DEFAULT_WALLPAPER: str = f"{WALLPAPER_DIR_PATH}/default_wallpaper.jpg"

# Assets needed
NEEDED_ASSETS: tuple[str, ...] = (
    SDDM_THEME_TAR_FILE,
    DEFAULT_WALLPAPER_ASSET,
)


CONFIG_DIRS: tuple[str, ...] = (
    "dunst",
    "alacritty",
    "hypr",
    "rofi",
    "scripts",
    "waybar",
    "wlogout",
    "yazi",
    "dunst",
    "eww",
    "systemd",
    "zsh",
    "nvim"
)

# pacman packages to install
PACMAN_PACKAGES: tuple[str, ...] = (
    "alacritty",
    "rofi",
    "dunst",
    "stow",
    "zsh",
    "nvim",
    "hypridle",
    "sddm",
    "yazi",
    "tar",
    "qt5-graphicaleffects",
    "qt5-quickcontrols2",
    "qt5-svg",
    "jq",
    "sensors",
    "curl",
    "unzip",
    "zip",
    "git",
    "waybar",
    "curl",
    "ttf-cascadia-code-nerd",
    "ttf-0xproto-nerd",
    "hyprland"
)

# yay packages to install
YAY_PACKAGES: tuple[str, ...] = ("wlogout", "cava", "python-pywal16")

# pywal files
PYWAL_LINKS: tuple[str, ...] = ("waybar", "wlogout", "rofi", "dunst")

PYWAL_CACHE_DIR: str = f"{HOME}/.cache/wal"

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
    GREY = "\033[38"
    RESET = "\033[0m"

# ==== FUNCTIONS ==== #
def custom_print(msg: str, color: str | None = None, end: str = "\n") -> None:
    """
    Function to colorize the output of print
    """
    if color is None:
        print(f"{COLORS.YELLOW}{msg}{COLORS.RESET}", end=end)
    else:
        print(f"{color}{msg}{COLORS.RESET}", end=end)


def show_command(args: tuple, dry_run: bool) -> None:
    """
    Function to show the bash commands

    Args:
        dry_run (bool): True if 'DRY-RUN' is activated, else show 'RUN'
    """
    command: str = ""
    if dry_run:
        command += "DRY-RUN: "
    else:
        command += f"RUN: "

    command += f"{COLORS.BLUE}{args[0]}{COLORS.RESET} "
    for arg in args[1:]:
        command += f"{arg} "

    log.debug(command)


def run_cmd(*args, dry_run: bool = True) -> sbp.CompletedProcess | None:
    """
    Function to run bash commands

    Args:
        args (tuple[str, ...]): All commands to run
        dry_run (bool): True if don't run the command, else runs normally
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
  1                 If the script has been used previously
  2                 If the arguments are invalid
  3                 If the number of arguments are invalid
"""
    )

def script_already_used() -> bool:
    file_path: Path = Path(USED_STATE_FILE)

    return file_path.is_file()

def assets_are_available() -> bool:
    """
    Function to verify all assets
    """
    log.info(">>> Verifing the assets available")

    for asset in NEEDED_ASSETS:
        asset_file: Path = Path(asset)
        if not asset_file.is_file():
            log.warning(f"The asset '{asset}' aren't available")
            return False

    return True

def check_assets_availability() -> None:
    if not assets_are_available():
        response: str = input(
            f"The assets aren't available in '{ASSETS_PATH}'. " +
            "Continue configuration without assets? [y/n] "
        ).strip()[0].lower()

        if response != "y":
            log.warning(">>> Aborting the configuration script...")
            custom_print("\n>>> No modifications were made")
            exit(0)
        else:
            log.warning(">>> Continuing configuration without assets")


def create_config_dirs(dry_run: bool = True):
    """
    Function to create dirs in '~/config'

    Args:
        dry_run (bool): True if don't run the command, else runs normally
    """
    log.info(">>> Creating configuration directories...")

    for dir in CONFIG_DIRS:
        run_cmd("mkdir", "-p", f"{XDG_CONFIG_HOME}/{dir}", dry_run=dry_run)


def update_system(dry_run: bool = True):
    """
    Function to update the system packages

    Args:
        dry_run (bool): True if don't run the command, else runs normally
    """
    log.info(">>> Updating system packages...")
    run_cmd("sudo", "pacman", "-Syu", "--noconfirm", dry_run=dry_run)
    run_cmd("yay", "--noconfirm", dry_run=dry_run)


def install_packages(dry_run: bool = True):
    """
    Function to install packages with pacman and yay

    Args:
        dry_run (bool): True if don't run the command, else runs normally
    """
    log.info(">>> Installing packages from Packman...")
    run_cmd(
        "sudo",
        "pacman",
        "-S",
        "--needed",
        "--noconfirm",
        *PACMAN_PACKAGES,
        dry_run=dry_run,
    )

    log.info(">>> Installing packages from Yay...")
    run_cmd(
        "yay",
        "-S",
        "--needed",
        "--noconfirm",
        *YAY_PACKAGES,
        dry_run=dry_run,
    )

    log.debug("Updating the pacman agail")
    update_system(dry_run=dry_run)


def backup_if_exists(target: str, dry_run: bool) -> None:
    """
    Function to create backup to file if it exist

    Args:
        target (str): Path to file
        dry_run (bool): True if don't run the command, else runs normally
    """
    if os.path.exists(target) and not os.path.islink(target):
        log.warning(f"{target} already exists. Creating backup as {target}.bak")

        run_cmd("mv", target, f"{target}.bak", dry_run=dry_run)


def backup_existing_configs(dry_run: bool = True) -> None:
    """
    Function to create backup of original configs files

    Args:
        dry_run (bool): True if don't run the command, else runs normally
    """
    log.info(">>> Checking for conflicts before using stow...")

    for dir in CONFIG_DIRS:
        if dir == "zsh":
            target: str = f"{HOME}/.zshrc"
        else:
            target: str = f"{XDG_CONFIG_HOME}/{dir}"

        backup_if_exists(target, dry_run)


def stow_configs(dry_run: bool = True) -> None:
    """
    Function to create symbolical links

    Args:
        dry_run (bool): True if don't run the command, else runs normally
    """
    log.info(">>> Creating symbolic links with stow...")

    for dir in CONFIG_DIRS:
        run_cmd("stow", dir, dry_run=dry_run)

    run_cmd("stow", "zsh", dry_run=dry_run)

def configure_zsh(dry_run: bool = True) -> None:
    """
    Function to configure all zsh plugins
    """
    log.info(">>> Configuring the zsh...")

    log.debug("Configure the oh-my-zsh")
    run_cmd(
        "sh",
        "-c",
        '"$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"',
        dry_run=dry_run
    )

    log.debug("Configuring the powerlevel10k")
    run_cmd(
        "git",
        "clone",
        "--depth=1",
        "https://github.com/romkatv/powerlevel10k.git",
        '"${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"',
        dry_run=dry_run
    )

def change_shell_to_zsh(dry_run: bool = True) -> None:
    """
    Function to change the current shell to zsh

    Args:
        dry_run (bool): True if don't run the command, else runs normally
    """
    log.info(">>> Changing the root shell...")
    run_cmd("sudo", "chsh", "-s", ZSH_BIN, dry_run=dry_run)

    log.info(">>> Changing the current shell...")
    run_cmd("chsh", "-s", ZSH_BIN, dry_run=dry_run)

    log.debug("Source command to load the new configs")
    run_cmd("source", ZSH_PATH, dry_run=dry_run)


def configure_sddm(dry_run: bool = True):
    log.info("Configuring the sddm to login in system...")

    log.debug(f"Creating directorys: '{SDDM_CONFIG_PATH}' and '{SDDM_THEMES_PATH}'...")
    run_cmd("mkdir", "-p", SDDM_CONFIG_PATH, dry_run=dry_run)
    run_cmd("mkdir", "-p", SDDM_THEMES_PATH, dry_run=dry_run)

    sddm_file: Path = Path(SDDM_THEME_TAR_FILE)
    if sddm_file.is_file():
        log.debug(f"Writing in file: {SDDM_CONFIG_PATH}/theme.conf")
        run_cmd(
            "echo",
            "-e",
            """[Theme]
Current=sugar-candy""",
            ">",
            f"{SDDM_CONFIG_PATH}/theme.conf",
            dry_run=dry_run
        )

        log.debug(f"Extracting files from '{SDDM_THEME_TAR_FILE}' to '{SDDM_THEMES_PATH}'...")
        run_cmd("sudo", "tar", "-xzvf", SDDM_THEME_TAR_FILE, "-C", SDDM_THEMES_PATH, dry_run=dry_run)
    else:
        log.warning(f"The file '{SDDM_THEME_TAR_FILE}' aren't in dotfiles. No themes will be added to sddm")

    log.debug("Initializing the sddm service")
    run_cmd("systemctl", "enable", "sddm.service", dry_run=dry_run)


def configure_hyprpaper(dry_run: bool = True) -> None:
  log.info(f">>> Creating wallpaper directory {WALLPAPER_DIR_PATH}")

  run_cmd("mkdir", "-p", WALLPAPER_DIR_PATH, dry_run=dry_run)


def configure_pywal(dry_run: bool = True) -> None:
    log.info(">>> Configuring the pywal")

    log.debug(f"Copy the default wallpaper to {WALLPAPER_DIR_PATH}")
    run_cmd(
        "cp",
        DEFAULT_WALLPAPER_ASSET,
        DEFAULT_WALLPAPER,
        dry_run=dry_run
    )

    log.debug("Run the pywal")
    run_cmd(
        "wal",
        "-n",
        "-s",
        "-t",
        "-e",
        "-i",
        DEFAULT_WALLPAPER,
        dry_run=dry_run
    )

    log.debug("Link the color to eww")
    run_cmd(
        "ln",
        "-s",
        f"{PYWAL_CACHE_DIR}/color.scss",
        "eww/.config/eww/scss/wal.scss",
        dry_run=dry_run
    )

    log.debug("Link the color to waybar")
    run_cmd(
        "ln",
        "-s",
        f"{PYWAL_CACHE_DIR}/color.css",
        "waybar/.config/waybar/wal.scss",
        dry_run=dry_run
    )


def save_used_state(dry_run: bool = True):
    """
    Function to create a file to avoid run the script again
    """
    log.info(">>> Add saving a state to don't use this script again")

    run_cmd("touch", USED_STATE_FILE, dry_run=dry_run)


def main(dry_run: bool = True):
    start: datetime = datetime.now()
    log.debug(f"The script starts at: {start}")

    if script_already_used():
        log.error(f"{COLORS.RED}The script has been used previously{COLORS.RESET}")
        exit(1)

    check_assets_availability()

    create_config_dirs(dry_run)

    update_system(dry_run)
    install_packages(dry_run)

    backup_existing_configs(dry_run)
    stow_configs(dry_run)

    configure_zsh(dry_run)
    change_shell_to_zsh(dry_run)

    configure_sddm(dry_run)

    configure_hyprpaper(dry_run)

    configure_pywal(dry_run)

    save_used_state(dry_run)

    finish: datetime = datetime.now()

    log.info(
        f"""Script Finished:
    Started at {start}
    Finished at {finish}
    Total time: {finish-start}"""
    )
    log.info(f"{COLORS.GREEN}>>> Installation completed successfully! <<<{COLORS.RESET}")

    custom_print("\n>>> Type 'start-hyprland' to initilize the Hyprland. (reboot is recomended)")
    exit(0)


def parse_args(args: list) -> None:
    """
    Function to parse args and run main function
    """
    # test number of arguments
    if len(args) != 2 and len(args) != 3:
        print(args)
        custom_print("Bad usage: Exactly one or two arguments are required.", color=COLORS.RED)
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
        log_level = logging.DEBUG
    else:
        log_level = logging.INFO

    root: logging.Logger = logging.getLogger()
    # remove previous handlers
    for h in root.handlers[:]:
        root.removeHandler(h)

    # file handler to save the LOG_FILE
    fh: logging.FileHandler = logging.FileHandler(LOG_FILE)
    formatter: logging.Formatter = logging.Formatter(
        "[%(asctime)s] [%(levelname)7s] - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S"
    )
    fh.setFormatter(formatter)
    fh.setLevel(log_level)

    # To show stderr
    sh: logging.StreamHandler = logging.StreamHandler()
    sh.setFormatter(formatter)
    sh.setLevel(log_level)

    root.addHandler(fh)
    root.addHandler(sh)
    root.setLevel(log_level)

    if dry_run is None:
        custom_print('The flags "--dry-run" or "--run" are required', color=COLORS.RED)
        show_help()
        exit(2)

    elif dry_run:
        log.warning(f"{COLORS.YELLOW}Dry-run mode enabled.{COLORS.RESET}")

    else:
        log.warning(f"{COLORS.YELLOW}Run mode enabled.{COLORS.RESET}")

    main(dry_run=dry_run)


# ==== RUN ==== #
parse_args(sys.argv)

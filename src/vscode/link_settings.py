import os
import platform

from utils import path_utils


def user_settings_location():
    home = os.path.expanduser('~')
    system_name = platform.system()
    if system_name == "Linux":
        return f"{home}/.config/Code/User/settings.json"
    elif system_name == "Darwin":
        return f"{home}/Library/Application\ Support/Code/User/settings.json"
    elif system_name == "Windows":
        return f"{home}\\AppData\\Roaming\\Code\\User\\settings.json"
    else:
        raise Exception("Unknown system")


settings = os.path.join(
    path_utils.current_file_path(__file__), "settings.json")
path_utils.symlink(settings, user_settings_location())

local awful = require("awful")

HOME_PATH = os.getenv("HOME")

theme = require("beautiful")
beautiful = theme
theme.init(HOME_PATH .. "/.config/awesome/theme/theme.lua")
dpi = theme.xresources.apply_dpi

TERMINAL = "wezterm"
EDITOR = os.getenv("EDITOR") or "nvim"
EDITOR_CMD = TERMINAL .. " -e " .. EDITOR
BROWSER = "firefox"
POWERMENU = HOME_PATH .. "/.config/rofi/powermenu.sh"
SPACE = '<span font="' .. theme.monofont .. '"> </span>'

awful.spawn.with_shell("~/.config/autostart/autostart.sh")

require("config")

require("ui")

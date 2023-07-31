-- vim:fileencoding=utf-8:foldmethod=marker

---------------------------
-- Awesome theme
---------------------------

local wibox = require("wibox")
local gears = require("gears")
local n = require("naughty")

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

theme.home_path = os.getenv("HOME")

theme.font_name = "CaskaydiaCove Nerd Font Mono Bold"
-- theme.font_name = "JetBrainsMono Nerd Font Mono Medium"
-- theme.font_name = "Roboto Bold"
theme.monofont_name = "CaskaydiaCove Nerd Font Mono Bold "

local iconfont = "CaskaydiaCove Nerd Font Bold "
local normal = " 10"

theme.font = theme.font_name .. normal
theme.iconfont = iconfont .. normal
theme.iconfont_nosize = iconfont
theme.monofont = theme.monofont_name .. normal
theme.monofont_nosize = theme.monofont_name
theme.taglist_font = theme.font_name

theme.icon_theme = "ePapirus-Dark"

-- theme.bar_height = dpi(24)
-- theme.bar_margin = dpi(4)
theme.bar_height = dpi(32)
theme.bar_margin = dpi(8)

theme.border_width = dpi(0)
theme.floating_border_width = dpi(0)
theme.border_single_client = false
theme.widget_border_width = dpi(2)

theme.useless_gap = dpi(4)
theme.gap_single_client = false

XColor = xresources.get_current_theme()

-- get colors
-- package.path = package.path .. ";" .. theme.home_path .. "/.config/?/init.lua"
local colors = require("theme.colors")

for k, v in pairs(colors) do
	theme[k] = v
end

theme.bg_normal = theme.bg
theme.bg_focus = theme.bg
theme.bg_urgent = theme.bg
theme.bg_minimize = theme.black
theme.bg_systray = theme.bg

theme.fg_normal = theme.pink
theme.fg_focus = theme.purple
theme.fg_urgent = theme.orange
theme.fg_minimize = theme.dark_white

theme.border_normal = theme.surface2
theme.border_focus = theme.surface2
theme.border_marked = theme.surface2

--theme.titlebar_title_enabled = false
theme.titlebar_bg_focus = theme.bg
theme.titlebar_bg_normal = theme.grey1

-- theme.taglist_fg_focus = theme.background
-- theme.taglist_fg_occupied = theme.purple
-- theme.taglist_fg_empty = theme.mid_grey2
-- theme.taglist_bg_focus = theme.purple
-- theme.taglist_bg_occupied = theme.background
-- theme.taglist_bg_empty = theme.background
-- theme.taglist_font = theme.monofont_nosize .. "10"

theme.snap_bg = theme.blue

theme.notification_border_color = theme.bg

theme.rect_round3 = function(cr, width, height)
	gears.shape.rounded_rect(cr, width, height, 3)
end
theme.rect_round5 = function(cr, width, height)
	gears.shape.rounded_rect(cr, width, height, 5)
end
theme.rect_round8 = function(cr, width, height)
	gears.shape.rounded_rect(cr, width, height, 8)
end
theme.rect_round12 = function(cr, width, height)
	gears.shape.rounded_rect(cr, width, height, 12)
end
theme.taglist_shape = theme.rect_round5

theme.border_radius = dpi(8)

-- theme.tasklist_disable_task_name = true
-- theme.tasklist_plain_task_name = true
-- theme.tasklist_shape = theme.rect_round5
-- theme.tasklist_spacing = dpi(3)
local asset_path = gfs.get_configuration_dir() .. "theme/assets/"

theme.layout_fairh = asset_path .. "layouts/fairh.png"
theme.layout_fairv = asset_path .. "layouts/fairv.png"
theme.layout_floating = asset_path .. "layouts/floating.png"
theme.layout_magnifier = asset_path .. "layouts/magnifier.png"
theme.layout_max = asset_path .. "layouts/max.png"
theme.layout_fullscreen = asset_path .. "layouts/fullscreen.png"
theme.layout_tilebottom = asset_path .. "layouts/tilebottom.png"
theme.layout_tileleft = asset_path .. "layouts/tileleft.png"
theme.layout_tile = asset_path .. "layouts/tile.png"
theme.layout_tiletop = asset_path .. "layouts/tiletop.png"
theme.layout_spiral = asset_path .. "layouts/spiral.png"
theme.layout_dwindle = asset_path .. "layouts/dwindle.png"
theme.layout_cornernw = asset_path .. "layouts/cornernw.png"
theme.layout_cornerne = asset_path .. "layouts/cornerne.png"
theme.layout_cornersw = asset_path .. "layouts/cornersw.png"
theme.layout_cornerse = asset_path .. "layouts/cornerse.png"
theme = theme_assets.recolor_layout(theme, theme.purple)

-- Icons for Notif Center
theme.notification_icon = asset_path .. "notif.png"

-- Titlebar icons
theme.titlebar_close_button_normal = asset_path .. "titlebar/close_normal.png"
theme.titlebar_close_button_focus = asset_path .. "titlebar/close_focus.png"
theme.titlebar_minimize_button_normal = asset_path .. "titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus = asset_path .. "titlebar/minimize_focus.png"
theme.titlebar_maximized_button_normal_inactive = asset_path .. "titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = asset_path .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = asset_path .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = asset_path .. "titlebar/maximized_focus_active.png"

-- icons for layouts
theme.layout_txt_tile = "[]="
theme.layout_txt_tileleft = "=[]"
theme.layout_txt_tilebottom = "[v]"
theme.layout_txt_tiletop = "[^]"
theme.layout_txt_fairv = "[|]"
theme.layout_txt_fairh = "[-]"
theme.layout_txt_spiral = "[s]"
theme.layout_txt_dwindle = "[d]"
theme.layout_txt_max = "[+]"
theme.layout_txt_fullscreen = "[F]"
theme.layout_txt_magnifier = "[m]"
theme.layout_txt_floating = "{}="

-- fallback image if current media has no image
theme.media_default_img = asset_path .. "media.png"

-- bling task preview
theme.task_preview_widget_border_radius = 10 -- Border radius of the widget (With AA)
theme.task_preview_widget_bg = theme.bg -- The bg color of the widget
theme.task_preview_widget_border_color = theme.grey -- The border color of the widget
theme.task_preview_widget_border_width = 1 -- The border width of the widget
theme.task_preview_widget_margin = dpi(8) -- The margin of the widget

theme.tag_preview_widget_margin = dpi(8)
theme.tag_preview_widget_border_radius = theme.border_radius
theme.tag_preview_client_border_radius = theme.border_radius / 2
theme.tag_preview_client_opacity = 1
theme.tag_preview_client_bg = theme.bg
theme.tag_preview_client_border_color = theme.bg
theme.tag_preview_client_border_width = 0
theme.tag_preview_widget_bg = theme.bg
theme.tag_preview_widget_border_color = theme.bg
theme.tag_preview_widget_border_width = 0

-- bling flash focus
-- theme.flash_focus_start_opacity = 0.8 -- the starting opacity
-- theme.flash_focus_step = 0.005 -- the step of animation

return theme

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local clock = require("ui.widgets.clock")
local playerctl = require("ui.widgets.playerctl")
local get_taglist = require("ui.widgets.taglist")
local get_tasklist = require("ui.widgets.tasklist")
local get_layoutbox = require("ui.widgets.layoutbox")
local get_tray = require("ui.widgets.systray")
local get_net = require("ui.widgets.net")
local get_battery = require("ui.widgets.battery")
volume = require("ui.widgets.volume")
local notif_icon = require("ui.widgets.notif_icon")

local trayscreen = screen[screen.count()]
local systray = get_tray(trayscreen)
local net = get_net({ color = theme.blue })
local battery = get_battery({ color = theme.cyan })

-- Available layouts, order matters.
awful.layout.layouts = {
	awful.layout.suit.tile,
	-- awful.layout.suit.tile.left,
	-- awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.fair,
	-- awful.layout.suit.fair.horizontal,
	awful.layout.suit.max,
	--awful.layout.suit.max.fullscreen,
	--awful.layout.suit.magnifier,
	--awful.layout.suit.corner.nw,
	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.corner.sw,
	-- awful.layout.suit.corner.se,
	-- awful.layout.suit.spiral,
	-- awful.layout.suit.spiral.dwindle,
	awful.layout.suit.floating,
}

local tag_name = ""

-- separator for bar
local space = wibox.widget({
	markup = SPACE,
	font = theme.monofont,
	widget = wibox.widget.textbox,
})
-- local widget_container = wibox.widget {
--     widget = wibox.container.margin,
--     right = dpi(4),
--     left = dpi(4),
-- }
local function container(widget, width)
	return wibox.widget({
		widget = wibox.container.margin,
		right = dpi(0),
		left = dpi(0),
		{
			widget = wibox.container.constraint,
			strategy = "exact",
			width = width,
			{
				widget = wibox.container.place,
				--valign = "center",
				halign = "left",
				widget,
			},
		},
	})
end

awful.screen.connect_for_each_screen(function(s)
	-- local mylayoutbox = awful.widget.layoutbox {
	--     screen = s,
	--     -- Add buttons, allowing you to change the layout
	--     buttons = {
	--         awful.button({}, 1, function() awful.layout.inc(1) end),
	--         awful.button({}, 3, function() awful.layout.inc(-1) end),
	--         awful.button({}, 4, function() awful.layout.inc(1) end),
	--         awful.button({}, 5, function() awful.layout.inc(-1) end),
	--     }
	-- }
	awful.tag({ "1", "2", "3", "4", "5", "6" }, s, awful.layout.layouts[1])

	s.layoutbox = get_layoutbox(s)
	s.taglist = get_taglist(s)
	s.tasklist = get_tasklist(s)

	-- Create the bar
	s.wibar = awful.wibar({
		position = "top",
		screen = s,
		height = theme.bar_height,
		bg = "#00000000",
	})

	-- add widgets to bar
	s.wibar:setup({
		bg = theme.bg,
		widget = wibox.container.background,
		{
			widget = wibox.container.margin,
			right = theme.bar_margin * 1.5,
			left = theme.bar_margin * 1.5,
			{
				layout = wibox.layout.align.horizontal,
				-- expand = "outside",
				{
					-- Left widgets
					layout = wibox.layout.fixed.horizontal,
					s.taglist,
					space,
					{
						right = dpi(4),
						top = theme.bar_margin,
						bottom = theme.bar_margin,
						widget = wibox.container.margin,
						{
							widget = wibox.container.place,
							valign = "center",
							s.layoutbox,
						},
					},
					--space,
				},
				-- Middle widgets
				s.tasklist,
				-- {
				--     widget = wibox.container.place,
				--     valign = "center",
				--     halign = "left",
				--     s.tasklist,
				-- },
				{
					-- Right widgets
					widget = wibox.container.place,
					halign = "right",
					-- valign = "center",
					{
						layout = wibox.layout.fixed.horizontal,
						systray,
						space,
						playerctl,
						-- container(volume, dpi(46)),
						volume.widget,
						space,
						battery,
						net,
						-- space,
						clock,
						-- {
						--     widget = wibox.container.place,
						--     valign = "center",
						-- },
						-- notif_icon,
					},
				},
			},
		},
	})
end)

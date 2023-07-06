local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local helpers = require("modules.helpers")
local dpi = beautiful.xresources.apply_dpi
local markup = require("util").markup

local width = dpi(325)
local height = dpi(50)

local active_color_1 = {
	type = "linear",
	from = { 0, 0 },
	to = { width, height }, -- replace with w,h later
	stops = { { 0.0, beautiful.blue }, { 0.25, beautiful.purple } },
}

local volume_icon = wibox.widget({
	markup = "",
	align = "center",
	valign = "center",
	font = beautiful.font_name .. "25",
	widget = wibox.widget.textbox,
})

local volume_adjust = awful.popup({
	type = "notification",
	maximum_width = width,
	maximum_height = height,
	visible = false,
	ontop = true,
	widget = wibox.container.background,
	bg = "#00000000",
	placement = function(c)
		awful.placement.top_right(c, {
			margins = { top = theme.bar_height + dpi(10), right = dpi(30) },
			parent = awful.screen.focused(),
		})
	end,
})

local volume_bar = wibox.widget({
	bar_shape = gears.shape.rounded_rect,
	shape = gears.shape.rounded_rect,
	background_color = beautiful.surface2,
	color = active_color_1,
	max_value = 100,
	value = 0,
	widget = wibox.widget.progressbar,
})

local volume_ratio = wibox.widget({
	layout = wibox.layout.ratio.horizontal,
	{
		{ volume_bar, direction = "north", widget = wibox.container.rotate },
		left = dpi(20),
		top = dpi(20),
		bottom = dpi(20),
		widget = wibox.container.margin,
	},
	{
		{
			volume_icon,
			widget = wibox.container.constraint,
			strategy = "exact",
			width = dpi(40),
		},
		left = dpi(10),
		right = dpi(20),
		top = dpi(20),
		bottom = dpi(20),
		widget = wibox.container.margin,
	},
	nil,
})

volume_ratio:adjust_ratio(2, 0.72, 0.28, 0)

volume_adjust.widget = wibox.widget({
	volume_ratio,
	shape = helpers.rrect(beautiful.border_radius),
	border_width = beautiful.widget_border_width,
	border_color = beautiful.bg,
	bg = beautiful.bg,
	widget = wibox.container.background,
})

-- create a timer to hide the volume adjust
-- component whenever the timer is started
local hide_volume_adjust = gears.timer({
	timeout = 1.5,
	autostart = true,
	callback = function()
		volume_adjust.visible = false
		volume_bar.mouse_enter = false
	end,
})

awesome.connect_signal("signal::volume", function(level, muted)
	volume_bar.value = level

	if muted == "off" or level == 0 then
		volume_icon.markup = markup.fontcolor(beautiful.font, beautiful.purple, level .. "%")
	else
		volume_icon.markup = markup.fontcolor(beautiful.font, beautiful.purple, level .. "%")
	end

	if volume_adjust.visible then
		hide_volume_adjust:again()
	else
		volume_adjust.visible = true
		hide_volume_adjust:start()
	end
end)

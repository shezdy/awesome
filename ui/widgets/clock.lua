local wibox = require("wibox")
local awful = require("awful")
local util = require("util")

local notif_popup = awful.popup({
	widget = wibox.container.background,
	visible = false,
	ontop = true,
	maximum_height = 1080 - beautiful.bar_height - dpi(20),
	maximum_width = dpi(500),
	placement = function(c)
		awful.placement.top_right(c, {
			margins = { top = beautiful.bar_height + dpi(10), right = dpi(10) },
		})
	end,
	border_color = beautiful.surface0,
	border_width = dpi(1),
})

-- Create a textclock widget
local clock = wibox.widget({
	-- top = theme.bar_margin,
	-- bottom = theme.bar_margin,
	-- widget = wibox.container.margin,
	-- {
	--     -- format = "<span color='" .. beautiful.purple .. "' >" .. "%a %d %b %I:%M" .. "</span>",
	--     -- format = "<span color='" .. theme.purple .. "' >" .. "%a %d %b %H:%M" .. "</span>",

	-- },

	buttons = {
		awful.button({}, 1, function() -- left click
			notif_popup.widget = wibox.widget({
				notif_center,
				margins = dpi(20),
				widget = wibox.container.margin,
			})
			notif_popup.screen = awful.screen.focused()
			notif_popup.visible = not notif_popup.visible
		end),
		awful.button({}, 4, function() -- scroll up
			util.async("brightness 80 80")
		end),
		awful.button({}, 5, function() -- scroll down
			util.async("brightness 40 30")
		end),
	},
	-- format = "<span color='" .. beautiful.purple .. "' >" .. "%a %d %b %I:%M" .. "</span>",
	format = "<span color='" .. theme.purple .. "' >" .. "%a %d %b %H:%M" .. "</span>",
	-- format = "<span color='" .. theme.purple .. "' >" .. "%A %d %B %H:%M" .. "</span>",
	valign = "center",
	widget = wibox.widget.textclock,
})

return clock

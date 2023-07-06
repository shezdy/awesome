local beautiful = require("beautiful")
local wibox = require("wibox")
local util = require("util")

local empty_notifbox = wibox.widget({
	{
		{
			markup = util.markup.color(theme.dark_white, "NO NOTIFICATIONS"),
			font = beautiful.font_name .. " 10",
			align = "center",
			valign = "center",
			widget = wibox.widget.textbox,
		},
		margins = dpi(4),
		widget = wibox.container.margin,
	},
	-- strategy = 'exact',
	-- height = 40,
	-- width = 40,
	widget = wibox.container.constraint,
})

-- local centered_empty_notifbox = wibox.widget {
--     layout = wibox.layout.fixed.vertical,
--     expand = 'none',
--     empty_notifbox
-- }

return empty_notifbox

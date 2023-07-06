local awful = require("awful")
local wibox = require("wibox")
local markup = require("util").markup

local clear_button = wibox.widget({
	widget = wibox.widget.textbox,
	markup = markup.fontcolor(theme.font, theme.fg, "Clear All"),
	buttons = {
		awful.button({}, 1, function() -- left click
			_G.reset_notifbox_layout()
		end),
	},
})

local delete_button_wrapped = wibox.widget({
	nil,
	{
		clear_button,
		widget = wibox.container.background,
	},
	nil,
	expand = "none",
	layout = wibox.layout.align.vertical,
})

return delete_button_wrapped

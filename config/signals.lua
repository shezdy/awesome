-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local bling = require("modules.bling")
require("awful.autofocus")

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	if c.class == "Spotify" then
		-- spotify doesn't have an icon for some reason without doing this
		local icon = gears.surface("/usr/share/icons/spotify.png")
		c.icon = icon._native
		icon:finish()
	end
	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	local titlebar = awful.titlebar(c, {
		size = dpi(24),
	})
	-- buttons for the titlebar
	local buttons = gears.table.join(
		awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)

	titlebar:setup({
		margins = dpi(0),
		widget = wibox.container.margin({
			{
				-- Left
				margins = dpi(5),
				widget = wibox.container.margin({
					awful.titlebar.widget.iconwidget(c),
					layout = wibox.layout.fixed.horizontal(),
				}),
			},
			{
				-- Middle
				{
					-- Title
					align = "center",
					widget = awful.titlebar.widget.titlewidget(c),
				},
				buttons = buttons,
				layout = wibox.layout.flex.horizontal,
			},
			{
				-- Right
				margins = dpi(2),
				widget = wibox.container.margin({
					--awful.titlebar.widget.stickybutton   (c),
					--awful.titlebar.widget.ontopbutton    (c),
					--awful.titlebar.widget.floatingbutton (c),
					--awful.titlebar.widget.minimizebutton(c),
					--awful.titlebar.widget.maximizedbutton(c),
					awful.titlebar.widget.closebutton(c),
					layout = wibox.layout.fixed.horizontal,
				}),
			},
			layout = wibox.layout.align.horizontal,
		}),
	})
end)

-- Titlebar focus indicator only
-- only applied if titlebars are enabled in rules
-- client.connect_signal("request::titlebars", function(c)
--     awful.titlebar(c, { size = 1}) : setup ()
-- end) --]]

local no_titlbars_class = {
	"gnome-calculator",
	"MainKt",
	"zoom",
	"eww-bar",
	"mpv",
}
local no_titlbars_name = {
	"Totalled",
}
local function table_contains(tbl, x)
	local found = false
	for _, v in pairs(tbl) do
		if v == x then
			found = true
		end
	end
	return found
end

client.connect_signal("property::floating", function(c)
	if not c.fullscreen then
		if not c.floating or c.maximized then
			awful.titlebar.hide(c)
			c.border_width = beautiful.border_width
		else
			if
				not table_contains(no_titlbars_name, c.name)
				and not table_contains(no_titlbars_class, c.class)
				and not c.maximized
			then
				awful.titlebar.show(c)
				c.border_width = beautiful.floating_border_width
			end
			awful.placement.no_offscreen(c, { honor_workarea = true })
		end
	end
end)

client.connect_signal("manage", function(c)
	if c.floating or c.first_tag.layout.name == "floating" then
		if
			not table_contains(no_titlbars_name, c.name)
			and not table_contains(no_titlbars_class, c.class)
			and not c.maximized
			and not c.fullscreen
		then
			awful.titlebar.show(c)
			c.border_width = beautiful.floating_border_width
		else
			awful.titlebar.hide(c)
			c.border_width = beautiful.border_width
		end
	else
		awful.titlebar.hide(c)
		c.border_width = beautiful.border_width
	end
end)

tag.connect_signal("property::layout", function(t)
	local clients = t:clients()
	-- naughty.notify({ text = tostring(t.layout.name) })
	for _, c in pairs(clients) do
		if c.floating or t.layout.name == "floating" then
			if
				not table_contains(no_titlbars_name, c.name)
				and not table_contains(no_titlbars_class, c.class)
				and not c.maximized
			then
				awful.titlebar.show(c)
				c.border_width = beautiful.floating_border_width
			else
				awful.titlebar.hide(c)
				c.border_width = beautiful.border_width
			end
		else
			awful.titlebar.hide(c)
			c.border_width = beautiful.border_width
		end
	end
end)

--Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:activate({ context = "mouse_enter", raise = false })
end)

-- bling.module.flash_focus.enable()

-- client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
-- client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

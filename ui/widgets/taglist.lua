local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local rubato = require("modules.rubato")

local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ "Mod4" }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ "Mod4" }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local function update(self, tag)
	if tag.selected then
		self.widget.children[1].bg = theme.purple
		self.tag_animation.target = dpi(24)
	elseif #tag:clients() == 0 then
		self.widget.children[1].bg = theme.mid_grey
		self.tag_animation.target = dpi(8)
	else
		self.widget.children[1].bg = theme.purple
		self.tag_animation.target = dpi(8)
	end
end

local function get_taglist(s)
	local taglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		layout = { layout = wibox.layout.fixed.horizontal },
		widget_template = {
			widget = wibox.container.margin,
			forced_width = dpi(28),
			forced_height = theme.bar_height,
			create_callback = function(self, tag, _)
				local indicator = wibox.widget({
					widget = wibox.container.place,
					valign = "center",
					{
						widget = wibox.container.background,
						forced_height = dpi(8),
						shape = gears.shape.rounded_bar,
					},
				})
				self:set_widget(indicator)

				self.tag_animation = rubato.timed({
					duration = 0.125,
					subscribed = function(pos)
						indicator.children[1].forced_width = pos
					end,
				})

				update(self, tag)
			end,
			update_callback = update,
		},
		buttons = taglist_buttons,
	})

	return wibox.widget({
		widget = wibox.container.place,
		valign = "center",
		halign = "center",
		taglist,
	})
end

return get_taglist

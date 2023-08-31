local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local bling = require("modules.bling")
local n = require("naughty")

-- local animation = require("modules.animation")
local rubato = require("modules.rubato")

local bg_cmd = "cat /home/d/.fehbg | tail -n 1 | awk '{print $6}' | tr -d \"'\""
local bg_path = ""
awful.spawn.easy_async_with_shell(bg_cmd, function(stdout)
	bg_path = stdout
end)

local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ "Mod4" }, 1, function(t)
		-- n.notify({title = "t", text = client.focus})
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

-- bling.widget.tag_preview.enable({
-- 	show_client_content = true, -- Whether or not to show the client content
-- 	x = 10,                  -- The x-coord of the popup
-- 	y = 10,                  -- The y-coord of the popup
-- 	scale = 0.1,             -- The scale of the previews compared to the screen
-- 	honor_padding = false,   -- Honor padding when creating widget size
-- 	honor_workarea = false,  -- Honor work area when creating widget size
-- 	placement_fn = function(c) -- Place the widget using awful.placement (this overrides x & y)
-- 		awful.placement.next_to(c, {
-- 			margins = {
-- 				top = dpi(8),
-- 				left = 0,
-- 			},
-- 		})
-- 	end,
-- 	background_widget = wibox.widget({
-- 	                                -- Set a background image (like a wallpaper) for the widget
-- 		image = "/home/d/Pictures/wallpapers/starry-nebula.png",
-- 		horizontal_fit_policy = "fit",
-- 		vertical_fit_policy = "fit",
-- 		widget = wibox.widget.imagebox,
-- 	}),
-- })

-- local function get_taglist(s)
--     return wibox.widget({
--         widget = wibox.container.place,
--         valign = "center",
--         halign = "center",
--         {
--             widget = wibox.container.constraint,
--             height = theme.bar_height - theme.bar_margin * 2,
--             awful.widget.taglist({
--                 screen = s,
--                 filter = awful.widget.taglist.filter.all,
--                 buttons = taglist_buttons,
--                 layout = {spacing = dpi(4), layout = wibox.layout.fixed.horizontal},
--                 --style = {shape = gears.shape.circle},
--                 widget_template = {
--                     {
--                         {
--                             {
--                                 id = "text_role",
--                                 widget = wibox.widget.textbox,
--                                 --font = theme.iconfont,
--                                 align = "center",
--                                 markup = "O",
--                                 valign = "center",
--                             },
--                             margins = dpi(4),
--                             widget = wibox.container.margin,
--                         },
--                         id = "background_role",
--                         widget = wibox.container.background
--                     },

--                     --widget = wibox.container.background,
--                     margins = dpi(4),
--                     valign = "center",
--                     fill_vertical = true,
--                     --content_fill_vertical = true,
--                     widget = wibox.container.place,
--                 },

--             })
--         },
--     })
-- end

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

				--- Tag preview
				-- self:connect_signal("mouse::enter", function()
				-- 	if #tag:clients() > 0 then
				-- 		awesome.emit_signal("bling::tag_preview::update", tag)
				-- 		awesome.emit_signal("bling::tag_preview::visibility", s, true)
				-- 	end
				-- end)
				--
				-- self:connect_signal("mouse::leave", function()
				-- 	awesome.emit_signal("bling::tag_preview::visibility", s, false)
				-- end)
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

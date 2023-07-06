-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local bling = require("modules.bling")
local n = require("naughty")

-- bling.widget.task_preview.enable {
--     x = 0,                    -- The x-coord of the popup
--     y = 0,                    -- The y-coord of the popup
--     height = 150,              -- The height of the popup
--     width = 250,               -- The width of the popup
--     placement_fn = function(c) -- Place the widget using awful.placement (this overrides x & y)
--         awful.placement.next_to(c, {
--             margins = {
--                 top = DPI(4),
--             },
--             preferred_position = "bottom",
--             preferred_anchor = "back",
--             --parent = awful.screen.focused()
--         })
--     end,
--     widget_structure = {
--         {
--             {
--                 {
--                     id = 'icon_role',
--                     widget = awful.widget.clienticon, -- The client icon
--                 },
--                 {
--                     ellipsize = "end",
--                     line_spacing_factor = 0.0,
--                     id = 'name_role', -- The client name / title
--                     widget = wibox.widget.textbox,
--                 },
--                 layout = wibox.layout.flex.horizontal
--             },
--             widget = wibox.container.margin,
--             margins = DPI(0)
--         },
--         {
--             id = 'image_role', -- The client preview
--             resize = true,
--             valign = 'center',
--             halign = 'center',
--             widget = wibox.widget.imagebox,
--         },
--         layout = wibox.layout.fixed.vertical
--     }
-- }

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 2, function(c)
		c:kill()
	end),
	awful.button({}, 3, function(c)
		c.maximized = not c.maximized
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

local tasklist_template = {
	-- margin outside each task
	-- left = dpi(2),
	-- margins = dpi(2),
	widget = wibox.container.margin,
	{
		-- shape = theme.rect_round8,
		widget = wibox.container.background,
		{
			id = "background_role",
			bg = theme.bg,
			widget = wibox.container.background,
			{
				-- margin inside each task
				left = dpi(5),
				right = dpi(5),
				widget = wibox.container.margin,
				{
					-- valign = "center",
					halign = "left",
					widget = wibox.container.place,
					{
						{
							{
								id = "clienticon",
								widget = awful.widget.clienticon,
							},
							left = dpi(4),
							right = dpi(4),
							top = theme.bar_margin,
							bottom = theme.bar_margin,
							widget = wibox.container.margin,
						},
						{
							text = "",
							widget = wibox.widget.textbox,
						},
						{
							top = theme.bar_margin,
							bottom = theme.bar_margin,
							widget = wibox.container.margin,
							-- widget = wibox.container.place,
							-- valign = "center",
							{
								id = "text_role",
								widget = wibox.widget.textbox,
							},
						},
						layout = wibox.layout.fixed.horizontal,
					},
				},
			},
		},
	},
	-- create_callback = function(self, c, index, objects) --luacheck: no unused args
	--     self:get_children_by_id('clienticon')[1].client = c
	--
	--     -- BLING: Toggle the popup on hover and disable it off hover
	--     self:connect_signal('mouse::enter', function()
	--             awesome.emit_signal("bling::task_preview::visibility", s, true, c)
	--         end)
	--         self:connect_signal('mouse::leave', function()
	--             awesome.emit_signal("bling::task_preview::visibility", s, false, c)
	--         end)
	-- end,
}

-- local tasklist_template = {
--     layout = wibox.layout.align.horizontal,
--     {
--         margins = dpi(4),
--         widget  = wibox.container.margin,
--         {
--             shape = theme.rect_round5,
--             widget  = wibox.container.background,
--             {
--                 --wibox.widget.base.make_widget(),
--                 --forced_height = 2,
--                 shape = theme.rect_round5,
--                 id = 'background_role',
--                 widget = wibox.container.background,
--                 {
--                     {
--                         id = 'clienticon',
--                         widget = awful.widget.clienticon,
--                     },
--                     margins = {left = dpi(2), right = dpi(2), top = dpi(2), bottom = dpi(2)},
--                     widget  = wibox.container.margin
--                 },
--             }
--         }
--     },
--     nil,
--     -- create_callback = function(self, c, index, objects) --luacheck: no unused args
--     --     self:get_children_by_id('clienticon')[1].client = c

--     --     -- BLING: Toggle the popup on hover and disable it off hover
--     --     self:connect_signal('mouse::enter', function()
--     --             awesome.emit_signal("bling::task_preview::visibility", s,
--     --                                 true, c)
--     --         end)
--     --         self:connect_signal('mouse::leave', function()
--     --             awesome.emit_signal("bling::task_preview::visibility", s,
--     --                                 false, c)
--     --         end)
--     -- end,
-- }

-- local function reverse(tab)
--     for i = 1, #tab//2, 1 do
--         tab[i], tab[#tab-i+1] = tab[#tab-i+1], tab[i]
--     end
--     return tab
-- end
-- local source = function(s)
--     local ret = {}

--     local reversed = reverse(s.clients)
--     for _, c in ipairs(reversed) do
--             table.insert(ret, c)
--     end
--     return ret
-- end

local function get_tasklist(s)
	return awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
		-- layout = {
		--     -- spacing_widget = {
		--     --     {
		--     --         forced_width  = 8,
		--     --         forced_height = 24,
		--     --         thickness     = 2,
		--     --         color         = theme.mid_grey2,
		--     --         widget        = wibox.widget.separator
		--     --     },
		--     --     valign = 'center',
		--     --     halign = 'center',
		--     --     widget = wibox.container.place,
		--     -- },
		--     spacing = 0,
		--     layout  = wibox.layout.fixed.horizontal
		-- },
		widget_template = tasklist_template,
	})
end

return get_tasklist

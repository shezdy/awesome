local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")

-- {{{ Key bindings

-- Mod4 is super, change to Mod1 for alt
local modkey = "Mod4"

-- root mouse bindings
root.buttons(gears.table.join(
	awful.button({}, 3, function()
		-- local x = mouse.coords().x
		-- local y = mouse.coords().y
		-- awful.util.spawn("rofi -show drun -location 1 -xoffset ".. x .." -yoffset " .. y, false)
		awful.util.spawn("rofi -show drun", false)
	end) --right click menu
	-- awful.button({ }, 3, function () mymainmenu:toggle() end), --right click menu
	-- awful.button({ }, 4, awful.tag.viewnext),
	-- awful.button({ }, 5, awful.tag.viewprev)
))

local playerctl_cmd = "playerctl -i 'firefox' "

globalkeys = gears.table.join(

	-- script that sets a random background
	awful.key({ modkey }, "Delete", function()
		awful.spawn.with_shell(HOME_PATH .. "/.fehbg1")
	end),
	--back to default
	awful.key({}, "Menu", function()
		awful.spawn.with_shell(HOME_PATH .. "/.fehbg")
	end), --return to default
	awful.key({ modkey }, "Menu", function()
		awful.spawn.with_shell(HOME_PATH .. "/.fehbg")
	end), --return to default

	-- cycle through tags
	awful.key({ modkey, "Shift" }, "Tab", awful.tag.viewprev, { description = "view previous", group = "tag" }),
	awful.key({ modkey }, "Tab", awful.tag.viewnext, { description = "view next", group = "tag" }),
	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

	-- screenshot shortcut
	awful.key({}, "Print", function()
		awful.util.spawn("flameshot gui")
	end),

	--media controls or media keyboard buttons
	awful.key({}, "XF86AudioPlay", function()
		awful.spawn.with_shell("playerctl play-pause")
	end),
	awful.key({}, "XF86AudioNext", function()
		awful.spawn.with_shell("playerctl next")
	end),
	awful.key({}, "XF86AudioPrev", function()
		awful.spawn.with_shell("playerctl previous")
	end),
	awful.key({}, "XF86AudioRaiseVolume", function()
		volume.increment()
	end),
	awful.key({}, "XF86AudioLowerVolume", function()
		volume.decrement()
	end),
	awful.key({}, "XF86AudioMute", function()
		volume.toggle_mute()
	end),

	-- media shortcuts for arrow keys
	awful.key({ "Mod1" }, "Up", function()
		awful.spawn.with_shell(playerctl_cmd .. "volume .05+")
	end),
	awful.key({ "Mod1" }, "Down", function()
		awful.spawn.with_shell(playerctl_cmd .. "volume .05-")
	end),
	awful.key({ "Mod1" }, "Right", function()
		awful.spawn.with_shell(playerctl_cmd .. "next")
	end),
	awful.key({ "Mod1" }, "Left", function()
		awful.spawn.with_shell(playerctl_cmd .. "previous")
	end),
	awful.key({ "Mod1" }, "End", function()
		awful.spawn.with_shell(playerctl_cmd .. "play-pause")
	end),

	-- app opening shortcuts
	awful.key({ modkey }, "space", function()
		awful.util.spawn("rofi -show drun", false)
	end, { description = "launch launcher", group = "launcher" }),
	awful.key({ modkey }, "p", function()
		awful.util.spawn(POWERMENU, false)
	end, { description = "launch powermenu", group = "launcher" }),
	awful.key({ modkey }, "Insert", function()
		awful.util.spawn("rofimoji", false)
	end, { description = "launch powermenu", group = "launcher" }),
	awful.key({ modkey }, "Return", function()
		awful.spawn(TERMINAL)
	end, { description = "open a terminal", group = "launcher" }),
	awful.key({ modkey, "Control" }, "Return", function()
		awful.spawn("wezterm start --class wezterm-floating")
	end, { description = "open a terminal", group = "launcher" }),
	awful.key({ modkey }, "b", function()
		awful.spawn(BROWSER)
	end, { description = "open a browser", group = "launcher" }),
	awful.key({ modkey, "Control" }, "b", function()
		awful.spawn("brave")
	end, { description = "open a browser", group = "launcher" }),
	awful.key({ modkey, "Control", "Mod1" }, "b", function()
		awful.spawn("brave --incognito")
	end, { description = "open a browser", group = "launcher" }),

	-- awful.key({ modkey }, "e", function(c)
	--     awful.spawn("dolphin")
	-- end, { description = "open file manager", group = "launcher" }),
	awful.key({ modkey }, "e", function(c)
		awesome.emit_signal("scratch::file")
	end, { description = "open file manager", group = "launcher" }),

	-- restart awesome (reload config)
	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),

	-- logout
	awful.key({ "Control", "Mod1" }, "Delete", awesome.quit, { description = "quit awesome", group = "awesome" }),

	-- change layout
	awful.key({ modkey }, "n", function()
		awful.layout.inc(1)
	end, { description = "select next", group = "layout" }),
	awful.key({ modkey, "Shift" }, "n", function()
		awful.layout.inc(-1)
	end, { description = "select previous", group = "layout" }),

	-- Swap all clients on screens 1 and 2 on current tags
	awful.key({ modkey }, "d", function(s)
		local screen1clients = screen[1].selected_tag:clients()
		local screen2clients = screen[2].selected_tag:clients()
		for i in pairs(screen1clients) do
			screen1clients[i]:move_to_screen(screen[2])
		end
		for i in pairs(screen2clients) do
			screen2clients[i]:move_to_screen(screen[1])
		end
	end, { description = "move to screen", group = "client" })
)

clientkeys = gears.table.join(
	awful.key({ modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen", group = "client" }),

	awful.key({ modkey }, "z", function(c)
		c:kill()
	end, { description = "close", group = "client" }),
	awful.key({ modkey }, "v", awful.client.floating.toggle, { description = "toggle floating", group = "client" }),
	awful.key({ modkey }, "m", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" }),

	awful.key({ modkey }, "a", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" }),

	awful.key({ modkey }, "s", function(c)
		c:move_to_screen()
	end, { description = "move to screen", group = "client" }),

	awful.key({ modkey }, "t", function(c)
		c.ontop = not c.ontop
	end, { description = "toggle keep on top", group = "client" }),

	awful.key({ modkey }, "c", function(c)
		local restore_c = awful.client.restore()
		if restore_c ~= nil then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		else
			c.minimized = true
		end
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
	end, { description = "toggle minimize", group = "client" }),
	awful.key({ modkey, "Control" }, "c", function(c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end, { description = "minimize", group = "client" }),
	awful.key({ modkey }, "x", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "(un)maximize", group = "client" }),
	-- awful.key({ modkey, "Control" }, "x", function(c)
	--     c.maximized_vertical = not c.maximized_vertical
	--     c:raise()
	-- end, { description = "(un)maximize vertically", group = "client" }),
	-- awful.key({ modkey, "Shift" }, "m", function(c)
	--     c.maximized_horizontal = not c.maximized_horizontal
	--     c:raise()
	-- end, { description = "(un)maximize horizontally", group = "client" })

	awful.key({ modkey }, "o", function(c)
		local result = awful.screen.focused
		naughty.notify({
			title = "result!",
			text = tostring(result),
		})
	end, { description = "", group = "client" }),

	-- Change focused window directionally
	awful.key({ modkey }, "j", function(c)
		awful.client.focus.global_bydirection("down")
		c:lower()
	end, { description = "focus next window up", group = "client" }),

	awful.key({ modkey }, "k", function(c)
		awful.client.focus.global_bydirection("up")
		c:lower()
	end, { description = "focus next window down", group = "client" }),

	awful.key({ modkey }, "l", function(c)
		awful.client.focus.global_bydirection("right")
		c:lower()
	end, { description = "focus next window right", group = "client" }),
	awful.key({ modkey }, "h", function(c)
		awful.client.focus.global_bydirection("left")
		c:lower()
	end, { description = "focus next window left", group = "client" }),

	-- Move windows directionally
	awful.key({ modkey, "Control" }, "h", function(c)
		awful.client.swap.global_bydirection("left")
		c:raise()
	end, { description = "swap with left client", group = "client" }),
	awful.key({ modkey, "Control" }, "l", function(c)
		awful.client.swap.global_bydirection("right")
		c:raise()
	end, { description = "swap with right client", group = "client" }),
	awful.key({ modkey, "Control" }, "j", function(c)
		awful.client.swap.global_bydirection("down")
		c:raise()
	end, { description = "swap with down client", group = "client" }),
	awful.key({ modkey, "Control" }, "k", function(c)
		awful.client.swap.global_bydirection("up")
		c:raise()
	end, { description = "swap with up client", group = "client" }),

	-- Resize windows
	awful.key({ modkey }, "Up", function(c)
		if c.floating then
			c:relative_move(0, 0, 0, -80)
		else
			awful.client.incwfact(0.05)
		end
	end, { description = "Resize Vertical Up", group = "client" }),

	awful.key({ modkey }, "Down", function(c)
		if c.floating then
			c:relative_move(0, 0, 0, 80)
		else
			awful.client.incwfact(-0.05)
		end
	end, { description = "Resize Vertical Down", group = "client" }),

	awful.key({ modkey }, "Left", function(c)
		if c.floating then
			c:relative_move(0, 0, -80, 0)
		else
			awful.tag.incmwfact(-0.05)
		end
	end, { description = "Resize Horizontal Left", group = "client" }),

	awful.key({ modkey }, "Right", function(c)
		if c.floating then
			c:relative_move(0, 0, 80, 0)
		else
			awful.tag.incmwfact(0.05)
		end
	end, { description = "Resize Horizontal Right", group = "client" })
)

-- Bind all key numbers to tags.
function assignTagKeys(tagNum, key)
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		awful.key({ modkey }, key, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[tagNum]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag #" .. tagNum, group = "tag" }),

		-- Toggle tag display.
		-- awful.key({ modkey, "Control" }, key, function()
		--     local screen = awful.screen.focused()
		--     local tag = screen.tags[tagNum]
		--     if tag then
		--         awful.tag.viewtoggle(tag)
		--     end
		-- end, { description = "toggle tag #" .. tagNum, group = "tag" }),

		-- Move client to tag.
		awful.key({ modkey, "Shift" }, key, function()
			if client.focus then
				local tag = client.focus.screen.tags[tagNum]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. tagNum, group = "tag" }),
		awful.key({ modkey, "Control" }, key, function()
			if client.focus then
				local tag = client.focus.screen.tags[tagNum]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. tagNum, group = "tag" }),

		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, key, function()
			if client.focus then
				local tag = client.focus.screen.tags[tagNum]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, { description = "toggle focused client on tag #" .. tagNum, group = "tag" })
	)
end

for i = 1, 9 do
	assignTagKeys(i, i)
end

assignTagKeys(5, "w")
assignTagKeys(6, "q")

clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)
-- Set keys
root.keys(globalkeys)
-- }}}

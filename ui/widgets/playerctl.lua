local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local util = require("util")
local bling = require("modules.bling")
local naughty = require("naughty")

-- playerctl widgets
local playerart = wibox.widget({
	image = nil,
	clip_shape = theme.rect_round3,
	align = "center",
	valign = "center",
	resize = true,
	widget = wibox.widget.imagebox,
})

local playername = wibox.widget({
	markup = "No players",
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local playertitle = wibox.widget({
	markup = "", --
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local playerartist = wibox.widget({
	markup = "",
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local playerctl = bling.signal.playerctl.lib({
	ignore = "firefox",
	player = { "spotify", "%any" },
})

local active_player = ""

-- set markup using metadata
playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
	active_player = player_name:lower()
	if #artist == 0 and active_player ~= "spotify" then
		playerart:set_image(theme.media_default_img)
		-- playerartist:set_markup("")
		playerartist:set_markup(util.markup.color(theme.red, SPACE .. player_name .. SPACE))
		if #title <= 60 then
			playertitle:set_markup(util.markup.color(theme.orange, title .. SPACE))
		else
			playertitle:set_markup(util.markup.color(theme.orange, string.sub(title, 1, 57) .. "..."))
		end
		return
	end
	-- Set art widget
	if album_path == "" or album_path == nil then
		playerart:set_image(theme.media_default_img)
	else
		playerart:set_image(gears.surface.load_uncached(album_path))
	end
	-- Set player name, title and artist widgets
	playername:set_markup(player_name .. " ")
	if #title <= 60 then
		playertitle:set_markup(util.markup.color(theme.orange, title .. SPACE))
	else
		playertitle:set_markup(util.markup.color(theme.orange, string.sub(title, 1, 57) .. "..."))
	end
	if #artist <= 40 then
		playerartist:set_markup(util.markup.color(theme.red, SPACE .. artist .. SPACE))
	else
		playerartist:set_markup(util.markup.color(theme.red, SPACE .. string.sub(artist, 1, 37) .. "..."))
	end
end)

-- cleanup when there are no active players
playerctl:connect_signal("no_players", function(_)
	-- Set art widget
	playerart:set_image(nil)

	-- Set player name, title and artist widgets
	playername:set_markup("")
	playertitle:set_markup("")
	playerartist:set_markup("")
end)

--create buttons for playerctl widgets
playerart:buttons(gears.table.join(awful.button({}, 1, function()
	for _, c in ipairs(client.get()) do
		if c.class:lower() == active_player then
			c:jump_to(false)
			return
		end
	end
end)))

local playerctl_buttons = gears.table.join(
	awful.button({}, 1, function()
		playerctl:play_pause()
	end),
	awful.button({}, 2, function()
		playerctl:previous()
	end),
	awful.button({}, 3, function()
		playerctl:next()
	end),
	awful.button({}, 4, function()
		awful.spawn.with_shell("playerctl -p 'spotify' volume .05+")
	end),
	awful.button({}, 5, function()
		awful.spawn.with_shell("playerctl -p 'spotify' volume .05-")
	end)
)
playerartist:buttons(playerctl_buttons)
playertitle:buttons(playerctl_buttons)

local playerctl_widget = wibox.widget({
	-- valign = "center",
	-- halign = "center",
	-- widget = wibox.container.place,
	top = theme.bar_margin,
	bottom = theme.bar_margin,
	widget = wibox.container.margin,
	{
		layout = wibox.layout.fixed.horizontal,
		playerart,
		playerartist,
		playertitle,
	},
})

return playerctl_widget

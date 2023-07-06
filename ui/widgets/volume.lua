local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local n = require("naughty")
local util = require("util")

local volume = {}

volume.cmd = "amixer"
volume.channel = "Master"
-- volume.get_volume_cmd = "amixer get Master | tail -n 1 | awk '{print $5 \" \" $6}' | tr -d '[%]'"
volume.get_volume_cmd = "amixer get Master"
-- volume.get_volume_cmd = "pamixer --get-volume && pamixer --get-mute"
-- volume.increase_cmd = "pamixer -i 5"
-- volume.decrease_cmd = "pamixer -d 5"
-- volume.toggle_cmd = "pamixer -t"

volume.widget = wibox.widget({
	-- markup = "",
	-- layout = wibox.layout.fixed.horizontal,
	-- {
	--     widget = wibox.widget.imagebox,
	--     image = theme.volume_medium,
	-- },
	-- {
	-- },
	widget = wibox.widget.textbox,
	markup = "",
	font = theme.font,
	justify = true,
	align = "center",
	valign = "center",
})

function volume.update()
	util.async(volume.get_volume_cmd, function(stdout)
		-- local level, muted = string.match(stdout, "([%d]+)%s*([%a]+)")
		local level, muted = string.match(stdout, "([%d]+)%%.*%[([%l]*)")
		-- n.notify({ title = level, text = muted })
		level = tonumber(level)
		volume_now = { level, muted }
		--volume.value = tonumber(value)
		if muted == "off" then
			volume.widget.markup =
				util.markup.color(theme.green, util.markup.font(theme.iconfont, "󰖁 ") .. "")
		else
			if level == nil then
				-- wait 1 second, then try again
				gears.timer({
					timeout = 1,
					autostart = true,
					single_shot = true,
					callback = function()
						volume.update()
					end,
				})
			elseif level < 10 then
				volume.widget.markup =
					util.markup.color(theme.green, util.markup.font(theme.iconfont, "󰕾 ") .. "0" .. level .. "%")
			elseif level == 100 then
				volume.widget.markup =
					util.markup.color(theme.green, util.markup.font(theme.iconfont, "󰕾 ") .. "MAX")
			else
				volume.widget.markup =
					util.markup.color(theme.green, util.markup.font(theme.iconfont, "󰕾 ") .. level .. "%")
			end
		end
	end)
	-- awesome.emit_signal("signal::volume", level, muted)
	return true
end

function volume.increment()
	util.async(string.format("%s set %s 5%%+", volume.cmd, volume.channel), volume.update)
end

function volume.decrement()
	util.async(string.format("%s set %s 5%%-", volume.cmd, volume.channel), volume.update)
end

function volume.toggle_mute()
	-- n.notify({ title = "Test Title", text = "Text Text" })
	util.async(string.format("%s set %s toggle", volume.cmd, volume.channel), volume.update)
end

local volumebuttons = awful.util.table.join(
	awful.button({}, 1, function() -- left click
		volume.toggle_mute()
	end),
	awful.button({}, 2, function() -- middle click
		awful.spawn("noisetorch", {
			placement = awful.placement.top_right,
		})
	end),
	awful.button({}, 3, function() -- right click
		awful.spawn("pavucontrol -t 4", {
			placement = awful.placement.top_right,
		})
	end),
	awful.button({}, 4, function() -- scroll up
		volume.increment()
	end),
	awful.button({}, 5, function() -- scroll down
		volume.decrement()
	end)
)
volume.widget:buttons(volumebuttons)

gears.timer({
	timeout = 20,
	autostart = true,
	single_shot = false,
	callback = function()
		volume.update()
		-- gears.timer.start_new(20, volume.update)
	end,
})
volume.update()

-- local volume_widget = wibox.widget({
--     top = theme.bar_margin,
--     bottom = theme.bar_margin,
--     widget = wibox.container.margin,
--     {
--         layout = wibox.layout.fixed.horizontal,
--         volume,
--     },
-- })

return volume

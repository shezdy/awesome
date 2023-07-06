local awful = require("awful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local beautiful = require("beautiful")
local markup = require("util").markup

--- Network Widget
--[[
󰍁󰌾󰌿󰍀󰍂󰍃󰃛󰃜󰂚󰂛󰂜󰂝󰂞󰂟󰂠󰃨󰐥󰖟󰖩󰖪󰖔󰤄
󰕾󰕿󰖀󰖁
󰤟󰤠󰤡󰤢󰤣󰤤󰤥󰤦󰤧󰤨󰤩󰤪󰤫󰤬󰤭󰤮󰤯󰈀󰈁󰈂

󰤯

󰤟

󰤢

󰤥

󰤨

]]
local function create_wifi_markup(icon, color, net_name)
	return markup.color(color, icon)
end

return function(args)
	args = args or {}

	local color = args.color or "#ffffff"

	local network = wibox.widget({
		{
			id = "icon",
			markup = "",
			align = "center",
			valign = "center",
			font = beautiful.iconfont,
			widget = wibox.widget.textbox,
		},
		right = 0,
		widget = wibox.container.margin,
	})

	local netbuttons = awful.util.table.join(
		awful.button({}, 1, function() -- left click
			awful.util.spawn("nm-connection-editor", {
				placement = awful.placement.top_right,
			})
		end),
		awful.button({}, 3, function() -- left click
			awful.util.spawn("nm-connection-editor", {
				placement = awful.placement.top_right,
			})
		end)
	)
	network:buttons(netbuttons)

	watch(
		[[sh -c "
        nmcli g | tail -n 1 | awk '{ print $1 }'
        "]],
		5,
		function(_, stdout)
			local net_ssid = stdout
			net_ssid = string.gsub(net_ssid, "^%s*(.-)%s*$", "%1")

			if net_ssid:match("connected") then
				local strength_cmd = [[ awk '/^\s*w/ { print  int($3 * 100 / 70) }' /proc/net/wireless ]]
				awful.spawn.easy_async_with_shell(strength_cmd, function(strength_stdout)
					local strength = tonumber(strength_stdout)
					if not strength then
						network.icon:set_markup("<span color='" .. color .. "' >" .. "󰇽 " .. "</span>")
						network.right = 0
					else
						--󰤯󰤟󰤢󰤥󰤨
						if strength <= 20 then
							network.icon:set_markup(markup.color(color, "󰤯 "))
						elseif strength <= 40 then
							network.icon:set_markup(markup.color(color, "󰤟 "))
						elseif strength <= 60 then
							network.icon:set_markup(markup.color(color, "󰤢 "))
						elseif strength <= 80 then
							network.icon:set_markup(markup.color(color, "󰤥 "))
						else
							network.icon:set_markup(markup.color(color, "󰤨 "))
						end
						network.right = dpi(4)
					end
				end)
			else
				network.icon:set_markup("<span color='" .. color .. "' >" .. "󰣽 " .. "</span>")
				network.right = 0
			end
		end
	)

	return network
end

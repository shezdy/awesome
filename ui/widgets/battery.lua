local awful = require("awful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local theme = require("beautiful")
local markup = require("util").markup

local function battery_markup(icon, percentage, color)
    return markup.color(color, icon .. " " .. markup.font(theme.font, percentage) .. " ")
end
local icon_switch = {
    ["'battery-full-symbolic'"] = "󰁹",
    ["'battery-full-charging-symbolic'"] = "󰂅",
    ["'battery-good-symbolic'"] = "󰁾",
    ["'battery-good-charging-symbolic'"] = "󰂈",
    ["'battery-low-symbolic'"] = "󰁻",
    ["'battery-low-charging-symbolic'"] = "󰂆",
    ["'battery-caution-symbolic'"] = "󰂃",
    ["'battery-caution-charging-symbolic'"] = "󰠑",
    ["'battery-full-charged-symbolic'"] = "󰂄",
    ["'battery-empty-symbolic'"] = "󰂎",
    ["'battery-missing-symbolic'"] = "󰂑",
    ["'ac-adapter-symbolic'"] = "󰠠",
}

-- battery infos from freedesktop upower
return function(args)
    args = args or {}
    local color = args.color or "#ffffff"
    local battery = wibox.widget({
        {
            id = "icon",
            markup = "",
            align = "center",
            valign = "center",
            font = theme.iconfont,
            widget = wibox.widget.textbox,
        },
        layout = wibox.layout.align.horizontal,
    })

    watch(
        {
            awful.util.shell,
            "-c",
            "upower -i /org/freedesktop/UPower/devices/battery_BAT0 | sed -n '/present/,/icon-name/p'",
        },
        30,
        function(_, stdout)
            local bat_now = {
                present = "N/A",
                state = "N/A",
                warninglevel = "N/A",
                energy = "N/A",
                energyfull = "N/A",
                energyrate = "N/A",
                voltage = "N/A",
                percentage = "N/A",
                capacity = "N/A",
                icon = "N/A",
            }

            for k, v in string.gmatch(stdout, "([%a]+[%a|-]+):%s*([%g]+[,|%a|%d]-)") do
                if k == "present" then
                    bat_now.present = v
                elseif k == "state" then
                    bat_now.state = v
                elseif k == "warning-level" then
                    bat_now.warninglevel = v
                elseif k == "energy" then
                    bat_now.energy = string.gsub(v, ",", ".")     -- Wh
                elseif k == "energy-full" then
                    bat_now.energyfull = string.gsub(v, ",", ".") -- Wh
                elseif k == "energy-rate" then
                    bat_now.energyrate = string.gsub(v, ",", ".") -- W
                elseif k == "voltage" then
                    bat_now.voltage = string.gsub(v, ",", ".")    -- V
                elseif k == "percentage" then
                    bat_now.percentage = v                        -- %
                elseif k == "capacity" then
                    bat_now.capacity = string.gsub(v, ",", ".")   -- %
                elseif k == "icon-name" then
                    bat_now.icon = v
                end
            end

            if not bat_now.icon then
                return
            else
                if icon_switch[bat_now.icon] then
                    battery.icon:set_markup(battery_markup(icon_switch[bat_now.icon], bat_now.percentage, color))
                end
            end
        end
    )
    return battery
end

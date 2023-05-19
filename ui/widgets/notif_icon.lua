local awful = require("awful")
local wibox = require("wibox")

local notif_icon = wibox.widget {
    {
        widget = wibox.widget.textbox,
        font = beautiful.iconfont,
        markup = "<span foreground='" .. beautiful.fg .. "'>" .. " " ..
            "</span>",
        resize = true
    },
    margins = { top = dpi(10), bottom = dpi(10), left = dpi(8), right = dpi(0) },
    widget = wibox.container.margin
}

local notif_icon_container = wibox.widget {
    notif_icon,
    bg = beautiful.bg,
    widget = wibox.container.background
}

local notif_popup = awful.popup {
    widget = wibox.container.background,
    visible = false,
    ontop = true,
    maximum_height = 1080 - beautiful.bar_height - dpi(20),
    maximum_width = dpi(500),
    placement = function(c)
        awful.placement.top_right(c, {
            margins = { top = beautiful.bar_height + dpi(10), right = dpi(10) }
        })
    end,
    border_color = beautiful.black,
    border_width = dpi(1)
}

notif_icon_container:connect_signal("button::release", function()
    notif_popup.widget = wibox.widget {
        require("ui.notifs.notif-center"),
        margins = dpi(20),
        widget = wibox.container.margin
    }
    notif_popup.screen = awful.screen.focused()
    notif_popup.visible = not notif_popup.visible
    notif_icon.margins = {
        top = dpi(10),
        bottom = dpi(10),
        left = dpi(8),
        right = dpi(0)
    }
    notif_icon_container.bg = beautiful.bg
end)

return notif_icon_container

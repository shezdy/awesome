local wibox = require("wibox")

local tray = wibox.widget({
    widget = wibox.widget.systray,
})

local function get_systray(s)
    tray:set_screen(s)
    return wibox.widget({
        top = theme.bar_margin,
        bottom = theme.bar_margin,
        widget = wibox.container.margin,
        -- valign = "center",
        -- halign = "center",    wibox.
        -- widget = wibox.container.place,
        tray,
    })
end

return get_systray
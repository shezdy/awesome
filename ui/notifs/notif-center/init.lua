local wibox = require('wibox')
local beautiful = require("beautiful")
local markup = require("util").markup

notif_header = wibox.widget {
    markup = '',
    font = beautiful.font_name .. " 11",
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
    reset = function()
        notif_header.markup = markup.color(theme.fg, 'NO NOTIFICATIONS')
    end
}
notif_header.reset()

return wibox.widget {
    {
        widget = wibox.container.margin,
        top = dpi(10),
        {
            nil,
            notif_header,
            require("ui.notifs.notif-center.clear-all"),
            expand = "none",
            spacing = dpi(10),
            layout = wibox.layout.align.horizontal
        },
    },
    require('ui.notifs.notif-center.build-notifbox'),

    spacing = dpi(10),
    layout = wibox.layout.fixed.vertical
}

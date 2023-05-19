local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("modules.helpers")
local markup = require("util").markup

local notifbox = {}

notifbox.create = function(icon, n, width)
    local time = os.date("%H:%M")
    local box = {}

    local dismiss_button = wibox.widget {
        widget = wibox.widget.textbox,
        markup = markup.fontcolor(
            theme.font,
            theme.fg,
            "  "
        ),
        buttons = {
            awful.button({}, 1, function() -- left click
                _G.remove_notifbox(box)
            end)
        }
    }

    box = wibox.widget {
        {
            {
                {
                    {
                        {
                            {
                                image = icon,
                                resize = true,
                                clip_shape = helpers.rrect(
                                    beautiful.border_radius - 3),
                                widget = wibox.widget.imagebox
                            },
                            -- bg = beautiful.red,
                            strategy = 'exact',
                            height = 40,
                            width = 40,
                            widget = wibox.container.constraint
                        },
                        layout = wibox.layout.align.vertical
                    },
                    margins = dpi(16),
                    widget = wibox.container.margin
                },
                {
                    {
                        nil,
                        {
                            {
                                {
                                    step_function = wibox.container.scroll
                                        .step_functions
                                        .waiting_nonlinear_back_and_forth,
                                    speed = 100,
                                    {
                                        markup = "<b>" .. n.title .. "</b>",
                                        font = beautiful.font,
                                        align = "left",
                                        widget = wibox.widget.textbox
                                    },
                                    forced_width = dpi(204),
                                    widget = wibox.container.scroll.horizontal
                                },
                                {
                                    {
                                        markup = time,
                                        align = "right",
                                        font = beautiful.font,
                                        widget = wibox.widget.textbox
                                    },
                                    left = dpi(10),
                                    widget = wibox.container.margin
                                },
                                {
                                    {
                                        dismiss_button,
                                        halign = "right",
                                        widget = wibox.container.place
                                    },
                                    left = dpi(10),
                                    widget = wibox.container.margin
                                },
                                layout = wibox.layout.fixed.horizontal
                            },
                            {
                                markup = n.message,
                                align = "left",
                                font = beautiful.font,
                                widget = wibox.widget.textbox
                            },
                            layout = wibox.layout.fixed.vertical
                        },
                        nil,
                        expand = "none",
                        layout = wibox.layout.align.vertical
                    },
                    margins = dpi(8),
                    widget = wibox.container.margin
                },
                layout = wibox.layout.align.horizontal
            },
            top = dpi(2),
            bottom = dpi(2),
            widget = wibox.container.margin
        },
        bg = beautiful.surface1,
        shape = helpers.rrect(beautiful.border_radius),
        widget = wibox.container.background
    }

    return box
end

return notifbox

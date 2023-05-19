local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local markup = require("util").markup

local function update_layoutbox(s)
    -- Writes a string representation of the current layout in a textbox widget
    local txt_l =
        markup.color(theme.pink, theme["layout_txt_" .. awful.layout.getname(awful.layout.get(s))])
    s.layoutbox:set_markup(txt_l)
end

local function get_layoutbox(s)
    awful.tag.attached_connect_signal(s, "property::selected", function()
        update_layoutbox(s)
    end)
    awful.tag.attached_connect_signal(s, "property::layout", function()
        update_layoutbox(s)
    end)
    return wibox.widget({
        markup = markup.color(
            theme.pink,
            markup.bold(theme["layout_txt_" .. awful.layout.getname(awful.layout.get(s))])
        ),
        valign = "center",
        font = theme.monofont,
        buttons = {
            awful.button({}, 1, function() awful.layout.inc(1) end),
            awful.button({}, 2, function() awful.layout.set(awful.layout.layouts[1]) end),
            awful.button({}, 3, function() awful.layout.inc(-1) end),
            awful.button({}, 4, function() awful.layout.inc(1) end),
            awful.button({}, 5, function() awful.layout.inc(-1) end),
        },
        widget = wibox.widget.textbox,
    })
end

-- local function get_layoutbox(s)
--     return awful.widget.layoutbox {
--         screen = s,
--         -- Add buttons, allowing you to change the layout
--         buttons = {
--             awful.button({}, 1, function() awful.layout.inc(1) end),
--             awful.button({}, 2, function() awful.layout.set(awful.layout.layouts[1]) end),
--             awful.button({}, 3, function() awful.layout.inc(-1) end),
--             awful.button({}, 4, function() awful.layout.inc(1) end),
--             awful.button({}, 5, function() awful.layout.inc(-1) end),
--         }
--     }
-- end

return get_layoutbox

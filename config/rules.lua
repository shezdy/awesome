-- Standard awesome library
local awful = require("awful")
local ruled = require("ruled")
local naught = require("naughty")

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = theme.border_width,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        },
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA",   -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "Pavucontrol",
                "Nm-connection-editor",
                "xtightvncviewer",
                "gnome-calculator",
                "wezterm-floating",
                "zoom",
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
                "WASM-4",
                "Friends List",
            },
            role = {
                "AlarmWindow",   -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up",        -- e.g. Chrome's (detached) Developer Tools.
                "GtkFileChooserDialog",
            },
        },
        properties = { floating = true },
    },

    {
        rule_any = {
            instance = {
            },
            class = {
                "MainKt",
                "totalled.exe",
            },
            name = {},
            role = {},
        },
        properties = { floating = true, titlebars_enabled = false },
    },

    -- Fullscreen
    {
        rule_any = {
            instance = {},
            class = {
                "steam_app_920320",
                "steam_app_0",
            },
            name = {},
            role = {},
        },
        properties = { fullscreen = true },
    },
}

ruled.client.append_rule {
    rule = { class = "[Ss]potify" },
    properties = {
        screen = 2,
    },
}

-- invert order of clients
-- ruled.client.append_rule {
--     id = "tasklist_order",
--     rule = {},
--     properties = {},
--     callback = awful.client.setslave
-- }

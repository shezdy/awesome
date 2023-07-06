local naughty = require("naughty")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local box = require("ui/notifs.notif-center.build-notifbox.notifbox")

local width = dpi(380)

local remove_notifbox_empty = true

local notifbox_layout = wibox.widget({
	layout = require("modules.overflow").vertical,
	scrollbar_width = 2,
	spacing = 7,
	scroll_speed = 10,
})

notifbox_layout.forced_width = width

reset_notifbox_layout = function()
	notifbox_layout:reset(notifbox_layout)
	notif_header.reset()
	remove_notifbox_empty = true
end

remove_notifbox = function(box)
	notifbox_layout:remove_widgets(box)

	if #notifbox_layout.children == 0 then
		notif_header.reset()
		remove_notifbox_empty = true
	end
end

naughty.connect_signal("request::display", function(n)
	if #notifbox_layout.children == 1 and remove_notifbox_empty == true then
		notifbox_layout:reset(notifbox_layout)
		remove_notifbox_empty = false
	end
	notif_header.markup = ""

	-- local notifbox_color = beautiful.surface3
	-- if n.urgency == 'critical' then
	--     notifbox_color = beautiful.red .. '66'
	-- end
	local appicon = n.icon or n.app_icon
	if not appicon then
		appicon = beautiful.notification_icon
	end

	notifbox_layout:insert(1, box.create(appicon, n, width))
end)

return notifbox_layout
-- return empty_notifbox

local awful = require("awful")
local bling = require("modules.bling")
local rubato = require("modules.rubato")

local anim = rubato.timed({
	pos = -1400,
	rate = 60,
	easing = rubato.quadratic,
	intro = 0.1,
	duration = 0.25,
	awestore_compat = true, -- This option must be set to true.
})

local w = 1440
local h = 900

local file_scratch = bling.module.scratchpad:new({
	command = "dolphin",
	rule = { class = "dolphin" },
	sticky = true,
	autoclose = false,
	floating = true,
	geometry = {
		x = awful.screen.focused().workarea.width / 2,
		y = awful.screen.focused().workarea.height / 2,
		-- x = dpi(500),
		-- y = dpi(450) + beautiful.bar_height,
		height = dpi(h),
		width = dpi(w),
	},
	reapply = true,
	rubato = { y = anim },
})

-- file_scratch:connect_signal("turn_on", function(c)
--     c.screen = awful.screen.focused { client = true }
-- end)

awesome.connect_signal("scratch::file", function()
	-- this will center on both screens
	local focused = awful.screen.focused({ client = false })
	local main = screen[1]
	file_scratch.geometry.x = focused.workarea.width / 2 - dpi(w / 2)
	file_scratch.geometry.y = main.workarea.height / 2 - dpi(h / 2) + beautiful.bar_height
	file_scratch:toggle()
end)

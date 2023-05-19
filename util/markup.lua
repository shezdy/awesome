local format = string.format

local markup = { }

function markup.bold(text) return format("<b>%s</b>", text) end
function markup.italic(text) return format("<i>%s</i>", text) end
function markup.strike(text) return format("<s>%s</s>", text) end
function markup.underline(text) return format("<u>%s</u>", text) end
function markup.monospace(text) return format("<tt>%s</tt>", text) end
function markup.big(text) return format("<big>%s</big>", text) end
function markup.small(text) return format("<small>%s</small>", text) end

-- Set the font
function markup.font(font, text)
    return format("<span font='%s'>%s</span>", font, text)
end

-- Set the foreground color
function markup.color(color, text)
    return format("<span foreground='%s'>%s</span>", color, text)
end

-- Set font and foreground color
function markup.fontcolor(font, fg, text)
    return format("<span font='%s' foreground='%s'>%s</span>", font, fg, text)
end

return markup
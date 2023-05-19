local spawn = require("awful.spawn")

local util  = {
    markup = require("util.markup"),
}

-- helper to make easy_async even easier
function util.async(cmd, callback)
    if callback == nil then
        return spawn.easy_async(cmd,
            function(stdout, _, _, exit_code)
            end)
    end
    return spawn.easy_async(cmd,
        function(stdout, _, _, exit_code)
            callback(stdout, exit_code)
        end)
end

return util

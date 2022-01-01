local M = {}

M.getType = function(name)
    local events = '!onStart!'
    local vars = '!newText!'

    if UTF8.find(events, '!' .. name .. '!') then
        return {EVENTS = true}
    elseif UTF8.find(vars, '!' .. name .. '!') then
        return {VARS = true}
    end
end

return M

local M = {}

M['requestApi'] = function(params)
    local p1 = params[1][1][1]
    START.lua = START.lua .. p1 .. ';'
end

return M

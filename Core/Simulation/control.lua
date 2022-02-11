local M = {}

M['requestApi'] = function(params)
    local p1 = params[1][1][1]
    p1 = UTF8.gsub(p1, 'currentStage', '')
    p1 = UTF8.gsub(p1, 'getCurrentStage', '')
    p1 = UTF8.gsub(p1, 'setFocus', 'display.getCurrentStage():setFocus')
    print('local G = {} for key, value in pairs(GET_GLOBAL_TABLE()) do G[key] = value end setfenv(1, G) ' .. p1)
    loadstring('local G = {} for key, value in pairs(GET_GLOBAL_TABLE()) do G[key] = value end setfenv(1, G) ' .. p1)()
end

return M

local CALC = require 'Core.Simulation.calc'
local M = {}

M['requestApi'] = function(params)
    local p1 = params[1][1][1]
    p1 = UTF8.gsub(p1, 'currentStage', '')
    p1 = UTF8.gsub(p1, 'getCurrentStage', '')
    p1 = UTF8.gsub(p1, 'setFocus', 'display.getCurrentStage():setFocus')
    loadstring('local G = {} for key, value in pairs(GET_GLOBAL_TABLE()) do G[key] = value end setfenv(1, G) ' .. p1)()
end

M['if'] = function(params)
    GAME.lua = GAME.lua .. ' pcall(function() if ' .. CALC(params[1]) .. ' then'
end

M['ifEnd'] = function(params)
    GAME.lua = GAME.lua .. ' end end)'
end

return M

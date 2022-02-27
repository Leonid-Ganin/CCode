local INFO = require 'Data.info'
local M = {}

M.CONTROL = require 'Core.Simulation.control'
M.VARS = require 'Core.Simulation.vars'
M.OBJECTS = require 'Core.Simulation.objects'

M['onStart'] = function(nested, params)
    GAME.lua = GAME.lua .. ' pcall(function() local function event() local varsE = {}'

    for i = 1, #nested do
        local name = nested[i].name
        local params = nested[i].params
        local type = UTF8.upper(INFO.getType(name))
        pcall(function() M[type][name](params) end)
    end

    GAME.lua = GAME.lua .. ' end event() end)'
end

return M

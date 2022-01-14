local EVENTS = require 'Core.Simulation.events'
local M = {}

M.remove = function()
    M.group:removeSelf() M.group = nil
    display.setDefault('background', 0.15, 0.15, 0.17)

    for i = M.children, display.getCurrentStage().numChildren do
        pcall(function()
            display.getCurrentStage()[i]:removeSelf()
            display.getCurrentStage()[i] = nil
        end)
    end
end

M.new = function()
    M.lua, M.group = '', display.newGroup()
    M.children = display.getCurrentStage().numChildren
    M.data = GET_GAME_CODE(CURRENT_LINK)
    display.setDefault('background', 0)

    local nestedIndex = 0
    local nestedEvent = {}
    local dataEvent = {}
    local blockIndex = 0

    for i = 1, #M.data.scripts do
        while blockIndex < #M.data.scripts[i].params do
            blockIndex = blockIndex + 1

            if M.data.scripts[i].params[blockIndex].event then
                if #M.data.scripts[i].params[blockIndex].nested > 0 then
                    for j = 1, #M.data.scripts[i].params[blockIndex].nested do
                        local blockIndex, blockData = blockIndex + j, M.data.scripts[i].params[blockIndex].nested[j]
                        table.insert(M.data.scripts[i].params, blockIndex, blockData)
                    end

                    M.data.scripts[i].params[blockIndex].nested, blockIndex = {}, blockIndex + #M.data.scripts[i].params[blockIndex].nested
                end
            end
        end
    end

    for i = 1, #M.data.scripts do
        for j = 1, #M.data.scripts[i].params do
            if M.data.scripts[i].params[j].event then
                nestedIndex = nestedIndex + 1
                nestedEvent[nestedIndex] = {}
                dataEvent[nestedIndex] = {
                    name = M.data.scripts[i].params[j].name,
                    params = M.data.scripts[i].params[j].params,
                    comment = M.data.scripts[i].params[j].comment
                }
            elseif not M.data.scripts[i].params[j].comment then
                table.insert(nestedEvent[nestedIndex], M.data.scripts[i].params[j])
            end
        end
    end

    for i = 1, #nestedEvent do
        if not dataEvent[i].comment then
            pcall(function() EVENTS[dataEvent[i].name](nestedEvent[i], dataEvent[i].params) end)
        end
    end

    pcall(function() loadstring('local G = {} for key, value in pairs(_G) do G[key] = value end setfenv(1, G) ' .. M.lua)() end)
end

return M

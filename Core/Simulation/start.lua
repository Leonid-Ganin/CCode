local WINDOW = require 'Core.Modules.interface-window'
local EVENTS = require 'Core.Simulation.events'
local M = {}

local function getStartLua()
    return 'local varsP = {}'
end

M.remove = function()
    M.group:removeSelf() M.group = nil
    MAIN:removeSelf() MAIN = display.newGroup()
    display.setDefault('background', 0.15, 0.15, 0.17)
end

M.new = function()
    M.lua = getStartLua()
    M.group = display.newGroup()
    M.data = GET_GAME_CODE(CURRENT_LINK)
    display.setDefault('background', 0)

    M.group.texts = {}
    M.group.objects = {}

    local nestedIndex = 0
    local nestedEvent = {}
    local nestedScript = {}
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
                    script = i,
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
        if not nestedScript[dataEvent[i].script] then
            if #nestedScript > 0 then M.lua = M.lua .. ' end script()' end
            M.lua = M.lua .. ' local function script() local varsS = {}'
            nestedScript[dataEvent[i].script] = true
        end

        if not dataEvent[i].comment then
            pcall(function() EVENTS[dataEvent[i].name](nestedEvent[i], dataEvent[i].params) end)
        end
    end

    -- WINDOW.new(M.lua .. ' end script()', {'Ok'}, function() end, 3)

    pcall(function()
        print(M.lua .. ' end script()')
        loadstring(M.lua .. ' end script()')()
    end)
end

return M

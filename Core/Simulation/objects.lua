local CALC = require 'Core.Simulation.calc'
local M = {}

local function getImage(link)
    for i = 1, #GAME.data.resources.images do
        if '\'' .. GAME.data.resources.images[i][1] .. '\'' == link then
            display.setDefault('magTextureFilter', GAME.data.resources.images[i][2] or 'nearest')
            display.setDefault('minTextureFilter', GAME.data.resources.images[i][2] or 'nearest')
            return '\'' .. CURRENT_LINK .. '/Images/' .. GAME.data.resources.images[i][3] .. '\''
        end
    end
end

M['newObject'] = function(params)
    local name = CALC(params[1])
    local link = getImage(CALC(params[2]))
    local posX = '(CENTER_X + ' .. CALC(params[3]) .. ')'
    local posY = '(CENTER_Y - ' .. CALC(params[4]) .. ')'

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[' .. name ..  '] = display.newImage(' .. link .. ','
    GAME.lua = GAME.lua .. ' system.DocumentsDirectory) GAME.group:insert(GAME.group.objects[' .. name .. '])'
    GAME.lua = GAME.lua .. ' GAME.group.objects[' .. name .. '].x, GAME.group.objects[' .. name .. '].y = ' .. posX .. ', ' .. posY
    GAME.lua = GAME.lua .. ' GAME.group.objects[' .. name .. ']._width = GAME.group.objects[' .. name .. '].width'
    GAME.lua = GAME.lua .. ' GAME.group.objects[' .. name .. ']._height = GAME.group.objects[' .. name .. '].height'
    GAME.lua = GAME.lua .. ' GAME.group.objects[' .. name .. ']._size = 1 end)'
end

M['setPos'] = function(params)
    local name = CALC(params[1])
    local posX = '(CENTER_X + ' .. CALC(params[2]) .. ')'
    local posY = '(CENTER_Y - ' .. CALC(params[3]) .. ')'

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[' .. name .. '].x = ' .. posX
    GAME.lua = GAME.lua .. ' GAME.group.objects[' .. name .. '].y = ' .. posY .. ' end)'
end

M['setPosX'] = function(params)
    local name = CALC(params[1])
    local posX = '(CENTER_X + ' .. CALC(params[2]) .. ')'

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[' .. name .. '].x = ' .. posX .. ' end)'
end

M['setPosY'] = function(params)
    local name = CALC(params[1])
    local posY = '(CENTER_Y - ' .. CALC(params[2]) .. ')'

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[' .. name .. '].y = ' .. posY .. ' end)'
end

M['setWidth'] = function(params)
    local name = CALC(params[1])
    local width = CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[' .. name .. '].width = ' .. width .. ' end)'
end

M['setHeight'] = function(params)
    local name = CALC(params[1])
    local height = CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[' .. name .. '].height = ' .. height .. ' end)'
end

M['setSize'] = function(params)
    local name = CALC(params[1])
    local size = '(' .. CALC(params[2]) .. ' / 100)'

    GAME.lua = GAME.lua .. ' pcall(function()'
    GAME.lua = GAME.lua .. ' GAME.group.objects[' .. name ..  '].width = GAME.group.objects[' .. name ..  ']._width * ' .. size
    GAME.lua = GAME.lua .. ' GAME.group.objects[' .. name ..  '].height = GAME.group.objects[' .. name ..  ']._height * ' .. size
    GAME.lua = GAME.lua .. ' GAME.group.objects[' .. name ..  ']._size = ' .. size .. ' end)'
end

M['setRotation'] = function(params)
    local name = CALC(params[1])
    local rotation = CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[' .. name .. '].rotation = ' .. rotation .. ' end)'
end

M['setAlpha'] = function(params)
    local name = CALC(params[1])
    local alpha = '(' .. CALC(params[2]) .. ' / 100)'

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[' .. name .. '].alpha = ' .. alpha .. ' end)'
end

M['updPosX'] = function(params)
    local name = CALC(params[1])
    local posX = CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[' .. name .. '].x = GAME.group.objects[' .. name .. '].x + ' .. posX .. ' end)'
end

M['updPosY'] = function(params)
    local name = CALC(params[1])
    local posY = CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[' .. name .. '].y = GAME.group.objects[' .. name .. '].y - ' .. posY .. ' end)'
end

M['updSize'] = function(params)
    local name = CALC(params[1])
    local size = '(' .. CALC(params[2]) .. ' / 100 + GAME.group.objects[' .. name ..  ']._size)'

    GAME.lua = GAME.lua .. ' pcall(function()'
    GAME.lua = GAME.lua .. ' GAME.group.objects[' .. name ..  '].width = GAME.group.objects[' .. name ..  ']._width * ' .. size
    GAME.lua = GAME.lua .. ' GAME.group.objects[' .. name ..  '].height = GAME.group.objects[' .. name ..  ']._height * ' .. size
    GAME.lua = GAME.lua .. ' GAME.group.objects[' .. name ..  ']._size = ' .. size .. ' end)'
end

M['updRotation'] = function(params)
    local name = CALC(params[1])
    local rotation = CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[' .. name .. '].rotation = GAME.group.objects[' .. name .. '].rotation + ' .. rotation .. ' end)'
end

M['updAlpha'] = function(params)
    local name = CALC(params[1])
    local alpha = '(' .. CALC(params[2]) .. ' / 100)'

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[' .. name .. '].alpha = GAME.group.objects[' .. name .. '].alpha + ' .. alpha .. ' end)'
end

M['updWidth'] = function(params)
    local name = CALC(params[1])
    local width = CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[' .. name .. '].width = GAME.group.objects[' .. name .. '].width + ' .. width .. ' end)'
end

M['updHeight'] = function(params)
    local name = CALC(params[1])
    local height = CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.objects[' .. name .. '].height = GAME.group.objects[' .. name .. '].height + ' .. height .. ' end)'
end

return M

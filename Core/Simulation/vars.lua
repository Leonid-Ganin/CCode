local CALC = require 'Core.Simulation.calc'
local M = {}

local function getFont(font)
    for i = 1, #GAME.data.resources.fonts do
        if '\'' .. GAME.data.resources.fonts[i][1] .. '\'' == font then
            local new_font = io.open(DOC_DIR .. '/' .. CURRENT_LINK .. '/Fonts/' .. GAME.data.resources.fonts[i][2], 'rb')
            local main_font = io.open(RES_PATH .. '/' .. GAME.data.resources.fonts[i][2], 'wb')

            if main_font and new_font then
                main_font:write(new_font:read('*a'))
                io.close(new_font)
                io.close(main_font)
            end

            return '\'' .. GAME.data.resources.fonts[i][2] .. '\''
        end
    end

    return font
end

M['setVar'] = function(params)
    local type = params[1][1][2] == 'vE' and ' varsE' or params[1][1][2] == 'vS' and ' varsS' or ' varsP'
    local name, value = params[1][1][1], CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function()' .. type .. '[\'' .. name .. '\'] = ' .. value .. ' end)'
end

M['updVar'] = function(params)
    local type = params[1][1][2] == 'vE' and ' varsE' or params[1][1][2] == 'vS' and ' varsS' or ' varsP'
    local name, value = params[1][1][1], CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function()' .. type .. '[\'' .. name .. '\'] = ' .. type .. '[\'' .. name .. '\'] + ' .. value .. ' end)'
end

M['newText'] = function(params)
    local name, text = CALC(params[1]), CALC(params[2])
    local font, size = getFont(CALC(params[3], '\'ubuntu\'')), CALC(params[4], '36')
    local colors, alpha = CALC(params[5], '{255}'), CALC(params[6], '100')
    local posX = '(CENTER_X + ' .. CALC(params[7]) .. ')'
    local posY = '(CENTER_Y - ' .. CALC(params[8]) .. ')'

    GAME.lua = GAME.lua .. ' pcall(function() local colors = ' .. colors
    GAME.lua = GAME.lua .. ' GAME.group.texts[' .. name .. '] = display.newText(' .. text .. ', ' .. posX .. ', ' .. posY .. ', ' .. font .. ', ' .. size .. ')'
    GAME.lua = GAME.lua .. ' GAME.group:insert(GAME.group.texts[' .. name .. '])'
    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[' .. name .. ']:setFillColor(colors[1]/255, colors[2]/255, colors[3]/255) end)'
    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[' .. name .. '].alpha = ' ..  alpha .. ' / 100 end) end)'
end

M['newText2'] = function(params)
    local name, text = CALC(params[1]), CALC(params[2])
    local font, size = getFont(CALC(params[3])), CALC(params[4])
    local colors, align = CALC(params[5]), CALC(params[6], '\'center\'')
    local width, height = CALC(params[7]), CALC(params[8])
    local posX = '(CENTER_X + ' .. CALC(params[9]) .. ')'
    local posY = '(CENTER_Y - ' .. CALC(params[10]) .. ')'

    GAME.lua = GAME.lua .. ' pcall(function() local colors = ' .. colors
    GAME.lua = GAME.lua .. ' GAME.group.texts[' .. name .. '] = display.newText({text = '
    GAME.lua = GAME.lua .. text .. ', x = ' .. posX .. ', y = ' .. posY .. ', width = ' .. width .. ', height = ' .. height .. ', align = '
    GAME.lua = GAME.lua .. align .. ', font = ' .. font .. ', fontSize = ' .. size .. '}) GAME.group:insert(GAME.group.texts[' .. name .. '])'
    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[' .. name .. ']:setFillColor(colors[1]/255, colors[2]/255, colors[3]/255) end) end)'
end

M['setTextPos'] = function(params)
    local name = CALC(params[1])
    local posX = '(CENTER_X + ' .. CALC(params[2]) .. ')'
    local posY = '(CENTER_Y - ' .. CALC(params[3]) .. ')'

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[' .. name .. '].x = ' .. posX
    GAME.lua = GAME.lua .. ' GAME.group.texts[' .. name .. '].y = ' .. posY .. ' end)'
end

M['setTextPosX'] = function(params)
    local name = CALC(params[1])
    local posX = '(CENTER_X + ' .. CALC(params[2]) .. ')'

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[' .. name .. '].x = ' .. posX .. ' end)'
end

M['setTextPosY'] = function(params)
    local name = CALC(params[1])
    local posY = '(CENTER_Y - ' .. CALC(params[2]) .. ')'

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[' .. name .. '].y = ' .. posY .. ' end)'
end

M['setTextRotation'] = function(params)
    local name = CALC(params[1])
    local rotation = CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[' .. name .. '].rotation = ' .. rotation .. ' end)'
end

M['setTextAlpha'] = function(params)
    local name = CALC(params[1])
    local alpha = '(' .. CALC(params[2]) .. ' / 100)'

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[' .. name .. '].alpha = ' .. alpha .. ' end)'
end

M['updTextPosX'] = function(params)
    local name = CALC(params[1])
    local posX = CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[' .. name .. '].x = GAME.group.texts[' .. name .. '].x + ' .. posX .. ' end)'
end

M['updTextPosY'] = function(params)
    local name = CALC(params[1])
    local posY = CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[' .. name .. '].y = GAME.group.texts[' .. name .. '].y - ' .. posY .. ' end)'
end

M['updTextRotation'] = function(params)
    local name = CALC(params[1])
    local rotation = CALC(params[2])

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[' .. name .. '].rotation = GAME.group.texts[' .. name .. '].rotation + ' .. rotation .. ' end)'
end

M['updTextAlpha'] = function(params)
    local name = CALC(params[1])
    local alpha = '(' .. CALC(params[2]) .. ' / 100)'

    GAME.lua = GAME.lua .. ' pcall(function() GAME.group.texts[' .. name .. '].alpha = GAME.group.texts[' .. name .. '].alpha + ' .. alpha .. ' end)'
end

return M

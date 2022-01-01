local INFO = require 'Core.Modules.logic-info'
local M  = {}

M.getBlockColor = function(name)
    local type = INFO.getType(name)

    if type.EVENTS then
        return 0.1, 0.6, 0.65
    elseif type.VARS then
        return 0.75, 0.6, 0.3
    end
end

M.getTextY = function(count)
    return count < 3 and -32 or (count < 5 and -62 or -92)
end

M.getParamsNameX = function(count)
    return count < 3 and {-240, 80} or (count == 3 and {-240, -240, 80} or (count == 4 and {-240, 80, -240, 80}
    or (count == 5 and {-240, -240, 80, -240, 80} or {-240, 80, -240, 80, -240, 80})))
end

M.getParamsLineX = function(count)
    return count == 1 and {75} or (count == 2 and {-85, 235} or (count == 3 and {75, -85, 235}
    or (count == 4 and {-85, 235, -85, 235} or (count == 5 and {75, -85, 235, -85, 235} or {-85, 235, -85, 235, -85, 235}))))
end

M.getParamsNameY = function(count)
    return count < 3 and {22, 22} or (count == 3 and {-8, 52, 52} or (count == 4 and {-8, -8, 52, 52}
    or (count == 5 and {-38, 22, 22, 82, 82} or {-38, -38, 22, 22, 82, 82})))
end

M.getParamsLineWidth = function(count)
    return count == 1 and {470} or (count == 2 and {150, 150} or (count == 3 and {470, 150, 150}
    or (count == 4 and {150, 150, 150, 150} or (count == 5 and {470, 150, 150, 150, 150} or {150, 150, 150, 150, 150, 150}))))
end

M.new = function(name, scroll, group, index, event, params)
    local blockHeight, blockWidth, blockParams, lengthParams = 120, DISPLAY_WIDTH - 60, {}, #params

    if event then
        blockHeight = 106
        blockParams = {
            0 - blockWidth / 2, 0 - blockHeight / 2, 0 - blockWidth / 2, 0 + blockHeight / 2,
            0 + blockWidth / 2, 0 + blockHeight / 2, 0 + blockWidth / 2, 0 - blockHeight / 2,
            0 + blockWidth / 2 - 1, 0 - blockHeight / 2 - 1, 0 + blockWidth / 2 - 1, 0 - blockHeight / 2 - 2,
            0 + blockWidth / 2 - 1, 0 - blockHeight / 2 - 3, 0 + blockWidth / 2 - 1, 0 - blockHeight / 2 - 4,
            0 + blockWidth / 2 - 2, 0 - blockHeight / 2 - 5, 0 + blockWidth / 2 - 2, 0 - blockHeight / 2 - 6,
            0 + blockWidth / 2 - 3, 0 - blockHeight / 2 - 7, 0 + blockWidth / 2 - 3, 0 - blockHeight / 2 - 8,
            0 + blockWidth / 2 - 4, 0 - blockHeight / 2 - 9, 0 + blockWidth / 2 - 5, 0 - blockHeight / 2 - 10,
            0 + blockWidth / 2 - 6, 0 - blockHeight / 2 - 11, 0 + blockWidth / 2 - 7, 0 - blockHeight / 2 - 12,
            0 + blockWidth / 2 - 8, 0 - blockHeight / 2 - 12, 0 + blockWidth / 2 - 9, 0 - blockHeight / 2 - 13,
            0 + blockWidth / 2 - 10, 0 - blockHeight / 2 - 13, 0 + blockWidth / 2 - 11, 0 - blockHeight / 2 - 14,
            0 - blockWidth / 2 + 11, 0 - blockHeight / 2 - 14, 0 - blockWidth / 2 + 10, 0 - blockHeight / 2 - 13,
            0 - blockWidth / 2 + 9, 0 - blockHeight / 2 - 13, 0 - blockWidth / 2 + 8, 0 - blockHeight / 2 - 12,
            0 - blockWidth / 2 + 7, 0 - blockHeight / 2 - 12, 0 - blockWidth / 2 + 6, 0 - blockHeight / 2 - 11,
            0 - blockWidth / 2 + 5, 0 - blockHeight / 2 - 10, 0 - blockWidth / 2 + 4, 0 - blockHeight / 2 - 9,
            0 - blockWidth / 2 + 3, 0 - blockHeight / 2 - 8, 0 - blockWidth / 2 + 3, 0 - blockHeight / 2 - 7,
            0 - blockWidth / 2 + 2, 0 - blockHeight / 2 - 6, 0 - blockWidth / 2 + 2, 0 - blockHeight / 2 - 5,
            0 - blockWidth / 2 + 1, 0 - blockHeight / 2 - 4, 0 - blockWidth / 2 + 1, 0 - blockHeight / 2 - 3,
            0 - blockWidth / 2 + 1, 0 - blockHeight / 2 - 2, 0 - blockWidth / 2 + 1, 0 - blockHeight / 2 - 1
        }
    else
        blockHeight = lengthParams < 3 and 120 or (lengthParams < 5 and 180 or (lengthParams < 7 and 240 or 300))
        blockParams = {
            0 - blockWidth / 2, 0 - blockHeight / 2, 0 - blockWidth / 2, 0 + blockHeight / 2,
            0 + blockWidth / 2, 0 + blockHeight / 2, 0 + blockWidth / 2, 0 - blockHeight / 2
        }
    end

    local y = index == 1 and 75 or group.blocks[index - 1].y + group.blocks[index - 1].block.height / 2 + blockHeight / 2
    table.insert(group.blocks, index, display.newGroup())
    group.blocks[index].data = {}
    group.blocks[index].x = scroll.width / 2
    group.blocks[index].y = y

    group.blocks[index].block = display.newPolygon(0, 0, blockParams)
    group.blocks[index]:insert(group.blocks[index].block)

    group.blocks[index].block:setFillColor(M.getBlockColor(name))
    group.blocks[index].block:setStrokeColor(0.3)
    group.blocks[index].block.strokeWidth = 3

    group.blocks[index].text = display.newText({
            text = STR['blocks.' .. name], width = blockWidth - 20, height = 38, fontSize = 30,
            align = 'left', x = 10, y = M.getTextY(lengthParams), font = 'ubuntu'
        })
    group.blocks[index]:insert(group.blocks[index].text)

    group.blocks[index].params = {}

    for i = 1, lengthParams do
        local textGetHeight = display.newText({
            text = STR['blocks.' .. name .. '.params'][i], align = 'left',
            fontSize = 22, x = 0, y = 5000, font = 'ubuntu', width = 140
        }) if textGetHeight.height > 53 then textGetHeight.height = 53 end

        local nameY = M.getParamsNameY(lengthParams)[i]
        group.blocks[index].params[i] = {}

        group.blocks[index].params[i].name = display.newText({
                text = STR['blocks.' .. name .. '.params'][i], align = 'left', height = textGetHeight.height, fontSize = 22,
                x = M.getParamsNameX(lengthParams)[i], y = nameY, font = 'ubuntu', width = 140
            }) textGetHeight:removeSelf()
        group.blocks[index]:insert(group.blocks[index].params[i].name)

        group.blocks[index].params[i].line = display.newRect(M.getParamsLineX(lengthParams)[i], nameY + 20, M.getParamsLineWidth(lengthParams)[i], 3)
            group.blocks[index].params[i].line:setFillColor(0.3)
        group.blocks[index]:insert(group.blocks[index].params[i].line)
    end

    group.blocks[index].getIndex = function(target)
        for i = 1, #group.blocks do
            if group.blocks[i] == target then
                return i
            end
        end
    end

    group.blocks[index].remove = function(index)
        group.blocks[index].block:removeSelf()
        group.blocks[index]:removeSelf()
        table.remove(group.blocks, index)
    end

    scroll:insert(group.blocks[index])
    scroll:setScrollHeight(120 * #group.blocks)
end

return M

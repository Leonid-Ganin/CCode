local LISTENER = require 'Core.Modules.params-listener'
local INFO = require 'Data.info'
local M  = {}

M.getTextY = function(count)
    return count < 3 and -32 or count < 5 and -62 or count < 7 and -92 or count < 9 and -122 or -152
end

M.getParamsNameX = function(count, width)
    return count < 3 and {90 - width / 2, 80}
    or count == 3 and {90 - width / 2, 90 - width / 2, 80}
    or count == 4 and {90 - width / 2, 80, 90 - width / 2, 80}
    or count == 5 and {90 - width / 2, 90 - width / 2, 80, 90 - width / 2, 80}
    or count == 6 and {90 - width / 2, 80, 90 - width / 2, 80, 90 - width / 2, 80}
    or count == 7 and {90 - width / 2, 90 - width / 2, 80, 90 - width / 2, 80, 90 - width / 2, 80}
    or count == 8 and {90 - width / 2, 80, 90 - width / 2, 80, 90 - width / 2, 80, 90 - width / 2, 80}
    or count == 9 and {90 - width / 2, 90 - width / 2, 80, 90 - width / 2, 80, 90 - width / 2, 80, 90 - width / 2, 80}
    or {90 - width / 2, 80, 90 - width / 2, 80, 90 - width / 2, 80, 90 - width / 2, 80, 90 - width / 2, 80}
end

M.getParamsLineX = function(count, width)
    return count == 1 and {175 - width / 2}
    or count == 2 and {175 - width / 2, 160}
    or count == 3 and {175 - width / 2, 175 - width / 2, 160}
    or count == 4 and {175 - width / 2, 160, 175 - width / 2, 160}
    or count == 5 and {175 - width / 2, 175 - width / 2, 160, 175 - width / 2, 160}
    or count == 6 and {175 - width / 2, 160, 175 - width / 2, 160, 175 - width / 2, 160}
    or count == 7 and {175 - width / 2, 175 - width / 2, 160, 175 - width / 2, 160, 175 - width / 2, 160}
    or count == 8 and {175 - width / 2, 160, 175 - width / 2, 160, 175 - width / 2, 160, 175 - width / 2, 160}
    or count == 9 and {175 - width / 2, 175 - width / 2, 160, 175 - width / 2, 160, 175 - width / 2, 160, 175 - width / 2, 160}
    or {175 - width / 2, 160, 175 - width / 2, 160, 175 - width / 2, 160, 175 - width / 2, 160, 175 - width / 2, 160}
end

M.getParamsNameY = function(count)
    return count < 3 and {22, 22}
    or count == 3 and {-8, 52, 52}
    or count == 4 and {-8, -8, 52, 52}
    or count == 5 and {-38, 22, 22, 82, 82}
    or count == 6 and {-38, -38, 22, 22, 82, 82}
    or count == 7 and {-68, -8, -8, 52, 52, 112, 112}
    or count == 8 and {-68, -68, -8, -8, 52, 52, 112, 112}
    or count == 9 and {-98, -38, -38, 22, 22, 82, 82, 142, 142}
    or {-98, -98, -38, -38, 22, 22, 82, 82, 142, 142}
end

M.getParamsLineWidth = function(count, width)
    return count == 1 and {width - 200}
    or count == 2 and {width / 2 - 185, width / 2 - 185}
    or count == 3 and {width - 200, width / 2 - 185, width / 2 - 185}
    or count == 4 and {width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185}
    or count == 5 and {width - 200, width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185}
    or count == 6 and {width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185}
    or count == 7 and {width - 200, width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185}
    or count == 8 and {width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185}
    or count == 9 and {width - 200, width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185}
    or {width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185, width / 2 - 185}
end

M.getParamsValueText = function(params, i)
    local result = ''
    local lastFun = false

    if params[i] then
        for _, value in ipairs(params[i]) do
            if value[2] == 't' then
                if UTF8.len(result) > 0 then result = result .. ' ' end
                result = result .. '\'' .. UTF8.gsub(value[1], '\n', '\\n') .. '\''
            elseif value[2] == 'n' or value[2] == 'u' or value[2] == 'c' then
                if UTF8.len(result) > 0 then result = result .. ' ' end
                result = result .. value[1]
            elseif value[2] == 'vP' or value[2] == 'vS' or value[2] == 'vE' then
                if UTF8.len(result) > 0 then result = result .. ' ' end
                result = result .. '"' .. value[1] .. '"'
            elseif value[2] == 'f' then
                if UTF8.len(result) > 0 then result = result .. ' ' end
                result = result .. STR['editor.list.fun.' .. value[1]]
                lastFun = true
            elseif value[2] == 'm' then
                if UTF8.len(result) > 0 then result = result .. ' ' end
                result = result .. STR['editor.list.math.' .. value[1]]
                lastFun = true
            elseif value[2] == 'p' then
                if UTF8.len(result) > 0 then result = result .. ' ' end
                result = result .. STR['editor.list.prop.' .. value[1]]
                lastFun = true
            elseif value[2] == 'l' then
                if UTF8.len(result) > 0 then result = result .. ' ' end
                if STR['editor.list.log.' .. value[1]]
                then result = result .. STR['editor.list.log.' .. value[1]]
                else result = result .. value[1] end
                lastFun = false
            elseif value[2] == 'd' then
                if UTF8.len(result) > 0 then result = result .. ' ' end
                result = result .. STR['editor.list.device.' .. value[1]]
                lastFun = false
            elseif value[2] == 's' then
                if UTF8.len(result) > 0 and (not lastFun or value[1] ~= '(') then result = result .. ' ' end
                result = result .. value[1]
                if value[1] == ',' then result = result .. ' ' end
            end
        end
    end

    return result
end

M.getPolygonParams = function(event, blockWidth, blockHeight)
    if event then
        return {
            -blockWidth / 2, -blockHeight / 2, -blockWidth / 2, blockHeight / 2,
            blockWidth / 2, blockHeight / 2, blockWidth / 2, -blockHeight / 2,
            blockWidth / 2 - 1, -blockHeight / 2 - 1, blockWidth / 2 - 1, -blockHeight / 2 - 2,
            blockWidth / 2 - 1, -blockHeight / 2 - 3, blockWidth / 2 - 1, -blockHeight / 2 - 4,
            blockWidth / 2 - 2, -blockHeight / 2 - 5, blockWidth / 2 - 2, -blockHeight / 2 - 6,
            blockWidth / 2 - 3, -blockHeight / 2 - 7, blockWidth / 2 - 3, -blockHeight / 2 - 8,
            blockWidth / 2 - 4, -blockHeight / 2 - 9, blockWidth / 2 - 5, -blockHeight / 2 - 10,
            blockWidth / 2 - 6, -blockHeight / 2 - 11, blockWidth / 2 - 7, -blockHeight / 2 - 12,
            blockWidth / 2 - 8, -blockHeight / 2 - 12, blockWidth / 2 - 9, -blockHeight / 2 - 13,
            blockWidth / 2 - 10, -blockHeight / 2 - 13, blockWidth / 2 - 11, -blockHeight / 2 - 14,
            -blockWidth / 2 + 11, -blockHeight / 2 - 14, -blockWidth / 2 + 10, -blockHeight / 2 - 13,
            -blockWidth / 2 + 9, -blockHeight / 2 - 13, -blockWidth / 2 + 8, -blockHeight / 2 - 12,
            -blockWidth / 2 + 7, -blockHeight / 2 - 12, -blockWidth / 2 + 6, -blockHeight / 2 - 11,
            -blockWidth / 2 + 5, -blockHeight / 2 - 10, -blockWidth / 2 + 4, -blockHeight / 2 - 9,
            -blockWidth / 2 + 3, -blockHeight / 2 - 8, -blockWidth / 2 + 3, -blockHeight / 2 - 7,
            -blockWidth / 2 + 2, -blockHeight / 2 - 6, -blockWidth / 2 + 2, -blockHeight / 2 - 5,
            -blockWidth / 2 + 1, -blockHeight / 2 - 4, -blockWidth / 2 + 1, -blockHeight / 2 - 3,
            -blockWidth / 2 + 1, -blockHeight / 2 - 2, -blockWidth / 2 + 1, -blockHeight / 2 - 1
        }
    else
        return {
            -blockWidth / 2, -blockHeight / 2, -blockWidth / 2, blockHeight / 2,
            blockWidth / 2, blockHeight / 2, blockWidth / 2, -blockHeight / 2
        }
    end
end

M.new = function(name, scroll, group, index, event, params, comment, nested, vars, tables)
    local blockHeight, blockWidth, blockParams, lengthParams = 116, DISPLAY_WIDTH - BOTTOM_WIDTH - TOP_WIDTH - 60, {}, #INFO.listName[name] - 1
    if not event then blockHeight = lengthParams < 3 and 116 or (lengthParams < 5 and 176 or (lengthParams < 7 and 236 or (lengthParams < 9 and 296 or 356))) end
    blockParams = M.getPolygonParams(event, blockWidth, event and 102 or blockHeight)

    local y = index == 1 and 50 or group.blocks[index - 1].y + group.blocks[index - 1].block.height / 2 + blockHeight / 2 - 2
    if event then y = y + 24 end table.insert(group.blocks, index, display.newGroup())

    group.blocks[index].data = {event = event, comment = comment, name = name, params = params, nested = nested, vars = vars, tables = tables}
    group.blocks[index].x, group.blocks[index].y = scroll.width / 2, y

    group.blocks[index].block = display.newPolygon(0, 0, blockParams)
        group.blocks[index].block:setFillColor(INFO.getBlockColor(name, comment))
        group.blocks[index].block:setStrokeColor(0.3)
        group.blocks[index].block.strokeWidth = 4
        group.blocks[index]:addEventListener('touch', require 'Core.Modules.logic-listener')
    group.blocks[index]:insert(group.blocks[index].block)

    for i = index + 1, #group.blocks do
        group.blocks[i].y = group.blocks[i].y + (group.blocks[index].block.height - 4 + (event and 24 or 0))
    end

    group.blocks[index].text = display.newText({
            text = STR['blocks.' .. name], width = blockWidth - 20, height = 38, fontSize = 30,
            align = 'left', x = 10, y = M.getTextY(lengthParams), font = 'ubuntu'
        })
    group.blocks[index]:insert(group.blocks[index].text)

    if nested then
        local polygonX = group.blocks[index].block.x + group.blocks[index].block.width / 2 - 25
        local polygonY = group.blocks[index].block.y - group.blocks[index].block.height / 2 + 20

        group.blocks[index].polygon = display.newPolygon(polygonX, polygonY, {0, 0, 10, 10, -10, 10})
            group.blocks[index].polygon.yScale = #nested > 0 and 1 or -1
            group.blocks[index].polygon:setFillColor(#nested > 0 and 0.25 or 1)
        group.blocks[index]:insert(group.blocks[index].polygon)
    end

    group.blocks[index].checkbox = WIDGET.newSwitch({
            x = (-scroll.width / 2 + group.blocks[index].block.x - group.blocks[index].block.width / 2) / 2 - 10, y = 0,
            style = 'checkbox', width = 50, height = 50, onPress = function(event) event.target:setState({isOn = not event.target.isOn}) end
        }) group.blocks[index].checkbox.isVisible = false
    group.blocks[index]:insert(group.blocks[index].checkbox)

    group.scrollHeight = group.scrollHeight + group.blocks[index].block.height - 4
    if event then group.scrollHeight = group.scrollHeight + 24 end

    group.blocks[index].params = {}
    group.blocks[index].rects = display.newGroup()
    group.blocks[index]:insert(group.blocks[index].rects)

    for i = 1, lengthParams do
        local textGetHeight = display.newText({
            text = STR['blocks.' .. name .. '.params'][i], align = 'left',
            fontSize = 22, x = 0, y = 5000, font = 'ubuntu', width = 140
        }) if textGetHeight.height > 53 then textGetHeight.height = 53 end

        local nameY = M.getParamsNameY(lengthParams)[i]
        local width = group.blocks[index].block.width

        group.blocks[index].params[i] = {}
        group.blocks[index].params[i].name = display.newText({
                text = STR['blocks.' .. name .. '.params'][i], align = 'left', height = textGetHeight.height, fontSize = 22,
                x = M.getParamsNameX(lengthParams, width)[i], y = nameY, font = 'ubuntu', width = 140
            }) textGetHeight:removeSelf()
        group.blocks[index]:insert(group.blocks[index].params[i].name)

        group.blocks[index].params[i].line = display.newRect(M.getParamsLineX(lengthParams, width)[i], nameY + 20, M.getParamsLineWidth(lengthParams, width)[i], 3)
            group.blocks[index].params[i].line:setFillColor(0.3)
            group.blocks[index].params[i].line.anchorX = 0
        group.blocks[index]:insert(group.blocks[index].params[i].line)

        group.blocks[index].params[i].value = display.newText({
                text = M.getParamsValueText(params, i), height = 26, width = M.getParamsLineWidth(lengthParams, width)[i] - 5,
                x = M.getParamsLineX(lengthParams, width)[i], y = nameY + 5, font = 'ubuntu', fontSize = 20, align = 'center'
            }) group.blocks[index].params[i].value.anchorX = 0
        group.blocks[index]:insert(group.blocks[index].params[i].value)

        group.blocks[index].params[i].rect = display.newRect(M.getParamsLineX(lengthParams, width)[i], nameY + 20, M.getParamsLineWidth(lengthParams, width)[i], 40)
            group.blocks[index].params[i].rect:setFillColor(1)
            group.blocks[index].params[i].rect.alpha = 0.005
            group.blocks[index].params[i].rect.anchorX = 0
            group.blocks[index].params[i].rect.anchorY = 1
            group.blocks[index].params[i].rect.index = i
        group.blocks[index].rects:insert(group.blocks[index].params[i].rect)

        group.blocks[index].params[i].rect:addEventListener('touch', function(e)
            if e.phase == 'began' then
                display.getCurrentStage():setFocus(e.target)
                e.target.click = true
                e.target:setFillColor(0.8, 0.8, 1)
                e.target.alpha = 0.2
            elseif e.phase == 'moved' and math.abs(e.y - e.yStart) > 20 then
                BLOCKS.group[8]:takeFocus(e)
                e.target.click = false
                e.target:setFillColor(1)
                e.target.alpha = 0.005
            elseif e.phase == 'ended' or e.phase == 'cancelled' then
                display.getCurrentStage():setFocus(nil)
                if e.target.click then
                    e.target.click = false
                    e.target:setFillColor(1)
                    e.target.alpha = 0.005
                    LISTENER.open(e.target)
                end
            end

            return true
        end)
    end

    group.blocks[index].getIndex = function(target)
        for i = 1, #group.blocks do
            if group.blocks[i] == target then
                return i
            end
        end
    end

    scroll:insert(group.blocks[index])
    scroll:setScrollHeight(group.scrollHeight)
end

return M

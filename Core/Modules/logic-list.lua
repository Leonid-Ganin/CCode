local LISTENER = require 'Core.Interfaces.blocks'
local BLOCK = require 'Core.Modules.logic-block'
local INFO = require 'Data.info'
local M = {}

local function getButtonText(comment, nested)
    local comment = comment and STR['button.uncomment'] or STR['button.comment']
    local nested = nested and (#nested > 0 and STR['button.show'] or STR['button.hide']) or nil
    return {STR['button.remove'], STR['button.copy'], comment, nested}
end

M.remove = function()
    M.group:removeSelf()
    M.group, ALERT = nil, true
    BLOCKS.group[8]:setIsLocked(false, 'vertical')
end

M.create = function(target, polygon, length, size, height, width, comment, params, name, twidth)
    local block = display.newGroup()
        block.y = CENTER_Y - height / 2 + 10 + target.block.height / 2 / size
        block.x, block.params = CENTER_X, {}

    block.block = display.newPolygon(0, 0, polygon)
        block.block:setFillColor(INFO.getBlockColor(name, comment))
        block.block:setStrokeColor(0.3)
        block.block.strokeWidth = 4
    block:insert(block.block)

    block.text = display.newText({
            text = STR['blocks.' .. name], width = block.block.width - 20, height = 38 / size, fontSize = 30 / size,
            align = 'left', x = 10 / size, y = target.text.y / size, font = 'ubuntu'
        })
    block:insert(block.text)

    if twidth then
        for i = 1, length do
            local nameY = BLOCK.getParamsNameY(length)[i]
            local width = twidth

            block.params[i] = {}
            block.params[i].name = display.newText({
                    text = STR['blocks.' .. name .. '.params'][i], align = 'left', height = target.params[i].name.height / size, fontSize = 22 / size,
                    x = BLOCK.getParamsNameX(length, width)[i] / size, y = nameY / size, font = 'ubuntu', width = 140 / size
                })
            block:insert(block.params[i].name)

            block.params[i].line = display.newRect(BLOCK.getParamsLineX(length, width)[i] / size, (nameY + 20) / size, BLOCK.getParamsLineWidth(length, width)[i] / size, 3 / size)
                block.params[i].line:setFillColor(0.3)
                block.params[i].line.anchorX = 0
            block:insert(block.params[i].line)

            block.params[i].value = display.newText({
                    text = target.params[i].value.text, height = 26 / size, width = (BLOCK.getParamsLineWidth(length, width)[i] - 5) / size,
                    x = BLOCK.getParamsLineX(length, width)[i] / size, y = (nameY + 5) / size, font = 'ubuntu', fontSize = 20 / size, align = 'center'
                }) block.params[i].value.anchorX = 0
            block:insert(block.params[i].value)
        end

        return block
    end

    for i = 1, length do
        block.params[i] = {}
        block.params[i].name = display.newText({
                text = STR['blocks.' .. name .. '.params'][i], align = 'left', height = target.params[i].name.height / size, fontSize = 22 / size,
                x = target.params[i].name.x / size, y = target.params[i].name.y / size, font = 'ubuntu', width = 140 / size
            })
        block:insert(block.params[i].name)

        block.params[i].line = display.newRect(target.params[i].line.x / size, target.params[i].line.y / size, target.params[i].line.width / size, 3 / size)
            block.params[i].line:setFillColor(0.3)
            block.params[i].line.anchorX = 0
        block:insert(block.params[i].line)

        block.params[i].value = display.newText({
                text = target.params[i].value.text, height = 26 / size, width = target.params[i].value.width / size,
                x = target.params[i].value.x / size, y = target.params[i].value.y / size, font = 'ubuntu', fontSize = 20 / size, align = 'center'
            }) block.params[i].value.anchorX = 0
        block:insert(block.params[i].value)
    end

    return block
end

M.new = function(target)
    if not M.group then
        M.group, ALERT = display.newGroup(), false
        BLOCKS.group[8]:setIsLocked(true, 'vertical')

        local polygon = BLOCK.getPolygonParams(target.data.event, target.block.width, target.data.event and 102 or target.block.height)
        local length, size = #INFO.listName[target.data.name] - 1, 1.6
        local height = target.data.event and target.block.height / size + 340 or target.block.height / size + 264
        local width = target.block.width / size + 20 for i = 1, #polygon do polygon[i] = polygon[i] / size end

        local bg = display.newRect(CENTER_X, CENTER_Y, DISPLAY_WIDTH, DISPLAY_HEIGHT)
            bg:setFillColor(1, 0.005)
        M.group:insert(bg)

        local rect = display.newRoundedRect(CENTER_X, CENTER_Y, width, height, 20)
            rect:setFillColor(0.2, 0.2, 0.22)
        M.group:insert(rect)

        local index = target.getIndex(target)
        local comment = target.data.comment
        local nested = target.data.nested
        local params = target.data.params
        local event = target.data.event
        local name = target.data.name

        local block = M.create(target, polygon, length, size, height, width, comment, params, name)
        local y = block.y + block.block.height / 2 + 50 M.group:insert(block)

        for i = 1, #getButtonText(comment, nested) do
            local button = display.newRect(CENTER_X, y, width - 25, 66)
                button:setFillColor(0.2, 0.2, 0.22)
            M.group:insert(button)

            button.text = display.newText({
                    text = getButtonText(comment, nested)[i], align = 'left', fontSize = 24,
                    x = CENTER_X + 10, y = y, font = 'ubuntu', height = 28, width = width - 40
                }) button.text.id = i
            M.group:insert(button.text)

            button:addEventListener('touch', function(e)
                if e.phase == 'began' then
                    display.getCurrentStage():setFocus(e.target)
                    e.target:setFillColor(0.22, 0.22, 0.24)
                    e.target.click = true
                elseif e.phase == 'moved' and math.abs(e.y - e.yStart) > 20 then
                    display.getCurrentStage():setFocus(nil)
                    e.target:setFillColor(0.2, 0.2, 0.22)
                    e.target.click = false
                elseif e.phase == 'ended' or e.phase == 'cancelled' then
                    display.getCurrentStage():setFocus(nil)
                    e.target:setFillColor(0.2, 0.2, 0.22)
                    if e.target.click then
                        e.target.click = false
                        INDEX_LIST = e.target.text.id

                        for j = 1, #BLOCKS.group.blocks do
                            BLOCKS.group.blocks[j].x = BLOCKS.group.blocks[j].x + 20
                            BLOCKS.group.blocks[j].checkbox.isVisible = true
                            BLOCKS.group.blocks[j].rects.isVisible = false
                        end

                        onCheckboxPress({target = target}) M.remove()
                        LISTENER({target = {button = 'but_okay', click = true}, phase = 'ended'})
                    end
                end

                return true
            end)

            y = y + 76
        end

        bg:addEventListener('touch', function(e)
            if e.phase == 'began' then
                display.getCurrentStage():setFocus(e.target)
                e.target.click = true
            elseif e.phase == 'ended' or e.phase == 'cancelled' then
                display.getCurrentStage():setFocus(nil)
                if e.target.click then
                    e.target.click = false
                    M.remove()
                end
            end return true
        end)

        rect:addEventListener('touch', function(e)
            if e.phase == 'began' then
                display.getCurrentStage():setFocus(e.target)
            elseif e.phase == 'ended' or e.phase == 'cancelled' then
                display.getCurrentStage():setFocus(nil)
            end return true
        end)
    end
end

return M

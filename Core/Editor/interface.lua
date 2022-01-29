local BLOCK = require 'Core.Modules.logic-block'
local LIST = require 'Core.Modules.logic-list'
local INFO = require 'Data.info'
local M = {}

local getFontSize = function(i)
    if CENTER_X == 360 then
        return (i == 1 or i == 2 or i == 6) and 24 or 36
    elseif CENTER_X == 640 then
        return (i == 17 or i == 18 or i == 22) and 24 or 36
    end
end

M.create = function(blockName, blockIndex, paramsData, paramsIndex)
    M.group = display.newGroup()
    M.restart = {blockName, blockIndex, COPY_TABLE(paramsData), paramsIndex}
    BLOCKS.group.isVisible = false

    local buttonsText = {
        STR['editor.button.text'], STR['editor.button.local'],
        '[', ']', '=', STR['editor.button.hide'], '(', ')',
        1, 2, 3, '+', 4, 5, 6, '-', 7, 8, 9, '*',
        '.', 0, ',', '/', 'C', '<-', '->', 'Ok'
    }

    local title = display.newText(STR['program.editor'], ZERO_X + 20, ZERO_Y + 10, 'ubuntu', 40)
        title.anchorX = 0
        title.anchorY = 0
    M.group:insert(title)

    -- local textListener = function(e)
    --     print(JSON.encode(e))
    --
    --     if e.phase == 'editing' then
    --         e.target.text = UTF8.gsub(UTF8.gsub(e.target.text, '[^%+%-%=%.%,%*%/%%%d%s]', ''), '%s+', ' ')
    --         native.setKeyboardFocus(e.target)
    --     end
    -- end

    local target = BLOCKS.group.blocks[blockIndex]
    local length = #INFO.listName[target.data.name] - 1
    local twidth, size = CENTER_X == 640 and (MAX_X - ZERO_X - 844) * 1.2 or target.block.width, CENTER_X == 640 and 1.2 or 1.0
    local polygon = BLOCK.getPolygonParams(target.data.event, twidth, target.data.event and 102 or target.block.height)
    local comment, params, name = target.data.comment, target.data.params, target.data.name
    local height = target.data.event and target.block.height / size + 340 or target.block.height / size + 264
    local width = target.block.width / size + 20 for i = 1, #polygon do polygon[i] = polygon[i] / size end

    local block = LIST.create(target, polygon, length, size, height, width, comment, params, name, twidth)
        block.y = title.y + title.height + 30 + block.height / 2
        block.x = CENTER_X == 640 and (ZERO_X + 799 + MAX_X) / 2 or block.x
    M.group:insert(block)

    local buttons = {}
    local buttonsX = ZERO_X + 54
    local buttonsY = MAX_Y - 655

    if CENTER_X == 640 then
        buttonsY = MAX_Y - 355
        for i = 8, 1, -1 do table.insert(buttonsText, 25, buttonsText[i]) end
        for i = 8, 1, -1 do table.remove(buttonsText, 1) end
    end

    local scrollY = (buttonsY - 55 + block.y + block.height / 2 + 30) / 2
    local scrollHeight = buttonsY - 55 - block.y - block.height / 2 - 30
    local scrollWidth, scrollX = DISPLAY_WIDTH, CENTER_X

    if CENTER_X == 640 then
        scrollHeight = buttonsY - 85 - title.y - title.height
        scrollY = (title.y + title.height + buttonsY - 25) / 2
        scrollWidth, scrollX, block.y = 745, ZERO_X + 404, scrollY
    end

    for i = 1, 28 do
        buttons[i] = display.newRoundedRect(buttonsX, buttonsY, 90, 90, 10)
            buttons[i]:setFillColor(0.15, 0.15, 0.17)
        M.group:insert(buttons[i])

        buttons[i].text = display.newText(buttonsText[i], buttonsX, buttonsY, 'ubuntu', getFontSize(i))
            buttons[i].text.id = i == 28 and 'ok' or i == 1 and 'text' or i == 2 and 'local' or i == 6 and 'hide' or buttons[i].text.text
        M.group:insert(buttons[i].text)

        if CENTER_X == 640 then
            buttons[i].text.id = i == 28 and 'ok' or i == 17 and 'text' or i == 18 and 'local' or i == 22 and 'hide' or buttons[i].text.text
        end

        buttonsX = i % 4 == 0 and ZERO_X + 54 or buttonsX + 100
        buttonsY = i % 4 == 0 and buttonsY + 100 or buttonsY

        if CENTER_X == 640 and i == 16 then
            buttonsX = buttonsX + 400
            buttonsY = MAX_Y - 355
        elseif CENTER_X == 640 and i > 16 and i % 4 == 0 then
            buttonsX = buttonsX + 400
        end

        buttons[i]:addEventListener('touch', function(e)
            if e.phase == 'began' and ALERT then
                display.getCurrentStage():setFocus(e.target)
                e.target:setFillColor(0.18, 0.18, 0.2)
                e.target.click = true
            elseif e.phase == 'moved' and (math.abs(e.y - e.yStart) > 30 or math.abs(e.x - e.xStart) > 60) and ALERT then
                display.getCurrentStage():setFocus(nil)
                e.target:setFillColor(0.15, 0.15, 0.17)
                e.target.click = false
            elseif (e.phase == 'ended' or e.phase == 'cancelled') and ALERT then
                display.getCurrentStage():setFocus(nil)
                e.target:setFillColor(0.15, 0.15, 0.17)
                if e.target.click then
                    e.target.click = false
                    print(e.target.text.id)
                end
            end
        end)
    end

    local scroll = WIDGET.newScrollView({
            x = scrollX, y = scrollY,
            width = scrollWidth, height = scrollHeight,
            hideScrollBar = false, horizontalScrollDisabled = true,
            isBounceEnabled = true, backgroundColor = {0.11, 0.11, 0.13}
        })
    M.group:insert(scroll)

    local listScroll = WIDGET.newScrollView({
            x = (buttons[28].x + 45 + MAX_X) / 2, y = (buttons[1].y - 45 + MAX_Y - 10) / 2,
            width = MAX_X - buttons[28].x - 65, height = MAX_Y - buttons[1].y + 25,
            hideScrollBar = true, horizontalScrollDisabled = true,
            isBounceEnabled = true, backgroundColor = {0.15, 0.15, 0.17},
        })
    M.group:insert(listScroll)

    local listButtons = {}
    local listButtonsX = listScroll.width / 2
    local listButtonsY = 35
    local listButtonsText = {'var', 'table', 'fun', 'math', 'prop', 'log', 'device'}

    for i = 1, 7 do
        listButtons[i] = display.newRect(listButtonsX, listButtonsY, listScroll.width, 70)
            listButtons[i]:setFillColor(0.11, 0.11, 0.13)
            listButtons[i].isOpen = false
        listScroll:insert(listButtons[i])

        listButtons[i].text = display.newText(STR['editor.list.' .. listButtonsText[i]], 20, listButtonsY, 'ubuntu', 28)
            listButtons[i].text.id = listButtonsText[i]
            listButtons[i].text.anchorX = 0
        listScroll:insert(listButtons[i].text)

        listButtons[i].polygon = display.newPolygon(listScroll.width - 30, listButtonsY, {0, 0, 10, 10, -10, 10})
            listButtonsY = listButtonsY + 70
        listScroll:insert(listButtons[i].polygon)
    end
end

return M

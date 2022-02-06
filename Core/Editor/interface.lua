local BLOCK = require 'Core.Modules.logic-block'
local LISTENER = require 'Core.Editor.listener'
local LIST = require 'Core.Modules.logic-list'
local DATA = require 'Core.Editor.data'
local TEXT = require 'Core.Editor.text'
local INFO = require 'Data.info'
local M = {}

local getFontSize = function(i)
    if CENTER_X == 360 then
        return (i == 1 or i == 2 or i == 6) and 24 or 36
    elseif CENTER_X == 640 then
        return (i == 17 or i == 18 or i == 22) and 24 or 36
    end
end

M.create = function(blockName, blockIndex, paramsData, paramsIndex, newOrientation)
    if newOrientation then
        local index = LISTENER.find(paramsData)
        if index then table.remove(paramsData, index) end
    end

    M.group, M.data = display.newGroup(), COPY_TABLE(paramsData)
    M.restart = {blockName, blockIndex, M.data, paramsIndex}
    BLOCKS.group.isVisible = false

    local data = GET_GAME_CODE(CURRENT_LINK)
        M.vars = {project = data.vars, script = data.scripts[CURRENT_SCRIPT].vars, event = {}}
        M.tables = {project = data.tables, script = data.scripts[CURRENT_SCRIPT].tables, event = {}}
        M.fun, M.math, M.prop, M.log, M.device = DATA.fun, DATA.math, DATA.prop, DATA.log, DATA.device

    for i = blockIndex, 1, -1 do
        if data.scripts[CURRENT_SCRIPT].params[i].event then
            M.vars.event = data.scripts[CURRENT_SCRIPT].params[i].vars
            M.tables.event = data.scripts[CURRENT_SCRIPT].params[i].tables
            break
        end
    end

    local buttonsText = {
        STR['editor.button.text'], STR['editor.button.local'],
        '[', ']', '=', STR['editor.button.hide'], '(', ')',
        1, 2, 3, '+', 4, 5, 6, '-', 7, 8, 9, '*',
        '.', 0, ',', '/', 'C', '<-', '->', 'Ok'
    }

    local title = display.newText(STR['program.editor'], ZERO_X + 10, ZERO_Y + 10, 'ubuntu', 32)
        title.anchorX = 0
        title.anchorY = 0
    M.group:insert(title)

    local list = display.newRoundedRect(MAX_X - 50, ZERO_Y + 34, 80, 60, 10)
        list:setFillColor(0.15, 0.15, 0.17)
        list.text = display.newText('⋮', list.x, list.y - 2, 'ubuntu', 40)
        list.text.id = 'list'
    M.group:insert(list)
    M.group:insert(list.text)

    local undo = display.newRoundedRect(MAX_X - 250, ZERO_Y + 34, 80, 60, 10)
        undo:setFillColor(0.15, 0.15, 0.17)
        undo.text = display.newText('⤺', undo.x, undo.y - 18, 'ubuntu', 80)
        undo.text.id = 'undo'
    M.group:insert(undo)
    M.group:insert(undo.text)

    local redo = display.newRoundedRect(MAX_X - 150, ZERO_Y + 34, 80, 60, 10)
        redo:setFillColor(0.15, 0.15, 0.17)
        redo.text = display.newText('⤺', redo.x, redo.y - 18, 'ubuntu', 80)
        redo.text.id = 'redo'
        redo.text.xScale = -1
    M.group:insert(redo)
    M.group:insert(redo.text)

    if CENTER_X == 640 then
        list.y = ZERO_Y + 38
        undo.y = ZERO_Y + 38
        redo.y = ZERO_Y + 38
        list.text.y = list.y - 2
        undo.text.y = undo.y - 18
        redo.text.y = redo.y - 18
    end

    local target = BLOCKS.group.blocks[blockIndex]
    local length = #INFO.listName[target.data.name] - 1
    local twidth, size = CENTER_X == 640 and (MAX_X - ZERO_X - 844) * 1.2 or target.block.width, CENTER_X == 640 and 1.2 or 1.0
    local polygon = BLOCK.getPolygonParams(target.data.event, twidth, target.data.event and 102 or target.block.height)
    local comment, params, name = target.data.comment, target.data.params, target.data.name
    local height = target.data.event and target.block.height / size + 340 or target.block.height / size + 264
    local width = target.block.width / size + 20 for i = 1, #polygon do polygon[i] = polygon[i] / size end

    local block = LIST.create(target, polygon, length, size, height, width, comment, params, name, twidth)
        block.y = title.y + title.height + 20 + block.height / 2
        block.x = CENTER_X == 640 and (ZERO_X + 799 + MAX_X) / 2 or block.x
    M.group:insert(block)

    for i = 1, length do
        block.params[i].rect:addEventListener('touch', function(e)
            if e.phase == 'began' then
                display.getCurrentStage():setFocus(e.target)
                e.target.click = true
                e.target:setFillColor(0.8, 0.8, 1)
                e.target.alpha = 0.2
            elseif e.phase == 'moved' and (math.abs(e.y - e.yStart) > 20 or math.abs(e.x - e.xStart) > 20) then
                display.getCurrentStage():setFocus(nil)
                e.target.click = false
                e.target:setFillColor(1)
                e.target.alpha = 0.005
            elseif e.phase == 'ended' or e.phase == 'cancelled' then
                display.getCurrentStage():setFocus(nil)
                if e.target.click then
                    e.target.click = false
                    e.target:setFillColor(1)
                    e.target.alpha = 0.005
                    LISTENER.rect(e.target.index, GET_GAME_CODE(CURRENT_LINK), COPY_TABLE(M.restart))
                end
            end

            return true
        end)
    end

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
        scrollHeight = buttonsY - 95 - title.y - title.height
        scrollY = (title.y + title.height + buttonsY - 35) / 2
        scrollWidth, scrollX, block.y = 745, ZERO_X + 404, scrollY
    end

    local scroll = WIDGET.newScrollView({
            x = scrollX, y = scrollY,
            width = scrollWidth, height = scrollHeight,
            hideScrollBar = false, horizontalScrollDisabled = true,
            isBounceEnabled = true, backgroundColor = {0.11, 0.11, 0.13}
        })
    M.group:insert(scroll)

    for i = 1, 28 do
        buttons[i] = display.newRoundedRect(buttonsX, buttonsY, 90, 90, 10)
            buttons[i]:setFillColor(0.15, 0.15, 0.17)
        M.group:insert(buttons[i])

        buttons[i].text = display.newText(buttonsText[i], buttonsX, buttonsY, 'ubuntu', getFontSize(i))
            buttons[i].text.id = i == 28 and 'Ok' or i == 1 and 'Text' or i == 2 and 'Local' or i == 6 and 'Hide' or buttons[i].text.text
        M.group:insert(buttons[i].text)

        if CENTER_X == 640 then
            buttons[i].text.id = i == 28 and 'Ok' or i == 17 and 'Text' or i == 18 and 'Local' or i == 22 and 'Hide' or buttons[i].text.text
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
                    M.data, M.cursor, M.backup = LISTENER[e.target.text.id](M.data, M.cursor, M.backup)

                    if e.target.text.id ~= 'Ok' and e.target.text.id ~= 'Hide' and e.target.text.id ~= 'Text' and e.target.text.id ~= 'Local' then
                        TEXT.set(TEXT.gen(M.data, M.cursor[2]), scroll)
                    end
                end
            end

            return true
        end)
    end

    local listScroll = WIDGET.newScrollView({
            x = (buttons[28].x + 45 + MAX_X) / 2, y = (buttons[1].y - 45 + MAX_Y - 10) / 2,
            width = MAX_X - buttons[28].x - 65, height = MAX_Y - buttons[1].y + 25,
            hideScrollBar = true, horizontalScrollDisabled = true,
            isBounceEnabled = true, backgroundColor = {0.15, 0.15, 0.17},
        }) listScroll.scrollHeight = 0
    M.group:insert(listScroll)

    listScroll.buttons = {}
    local listButtonsX = listScroll.width / 2
    local listButtonsY = 35
    local listButtonsText = {'var', 'table', 'fun', 'math', 'prop', 'log', 'device'}

    for i = 1, 7 do
        listScroll.buttons[i] = display.newRect(listButtonsX, listButtonsY, listScroll.width, 70)
            listScroll.buttons[i]:setFillColor(0.11, 0.11, 0.13)
            listScroll.buttons[i].isOpen = false
            listScroll.buttons[i].count = 0
        listScroll:insert(listScroll.buttons[i])

        listScroll.buttons[i].text = display.newText(STR['editor.list.' .. listButtonsText[i]], 20, listButtonsY, 'ubuntu', 28)
            listScroll.buttons[i].text.id = listButtonsText[i]
            listScroll.buttons[i].text.anchorX = 0
        listScroll:insert(listScroll.buttons[i].text)

        listScroll.buttons[i].polygon = display.newPolygon(listScroll.width - 30, listButtonsY, {0, 0, 10, 10, -10, 10})
            listButtonsY = listButtonsY + 70
        listScroll:insert(listScroll.buttons[i].polygon)

        listScroll.scrollHeight = listScroll.scrollHeight + 70
        listScroll.buttons[i]:addEventListener('touch', require('Core.Editor.list').listener)
    end

    local toolbarListener = function(e)
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
                if e.target.text.id == 'undo' or e.target.text.id == 'redo' then
                    M.backup, M.data, M.cursor = LISTENER.backup(M.backup, e.target.text.id, M.data, M.cursor)
                    TEXT.set(TEXT.gen(M.data, M.cursor[2]), scroll)
                elseif e.target.text.id == 'list' then
                    LISTENER.list(e.target)
                end
            end
        end

        return true
    end

    list:addEventListener('touch', toolbarListener)
    undo:addEventListener('touch', toolbarListener)
    redo:addEventListener('touch', toolbarListener)

    M.data = TEXT.number(M.data)
    M.cursor = {#M.data + 1, 'w'}
    M.data[#M.data + 1] = {'|', '|'}
    M.backup = {{COPY_TABLE(M.data)}, 1}
    TEXT.create(TEXT.gen(M.data, M.cursor[2]), scroll)
end

return M

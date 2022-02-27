local LISTENER = require 'Core.Editor.listener'
local DATA = require 'Core.Editor.data'
local TEXT = require 'Core.Editor.text'
local listeners = {}
local dataButtons = {STR['editor.list.event'], STR['editor.list.script'], STR['editor.list.project']}

listeners.listener = function(e)
    if e.phase == 'began' and ALERT then
        display.getCurrentStage():setFocus(e.target)
        e.target.click = true
    elseif e.phase == 'moved' and (math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 30) and ALERT then
        EDITOR.group[66]:takeFocus(e)
        e.target.click = false
    elseif (e.phase == 'ended' or e.phase == 'cancelled') and ALERT then
        display.getCurrentStage():setFocus(nil)
        if e.target.click then
            e.target.click = false
            if listeners[e.target.text.id] then
                listeners[e.target.text.id](e.target)
            else
                if EDITOR.cursor[2] == 'w' then
                    local thisData = UTF8.sub(e.target.text.id, 1, 1) == '/'
                    local type = e.target.text.ID == 'fun' and 'f' or
                    e.target.text.ID == 'math' and 'm' or
                    e.target.text.ID == 'prop' and 'p' or
                    e.target.text.ID == 'log' and 'l' or
                    e.target.text.ID == 'device' and 'd' or
                    e.target.text.id == '/event' and 'vE' or
                    e.target.text.id == '/script' and 'vS' or
                    e.target.text.id == '/project' and 'vP' or
                    e.target.text.id == '/tevent' and 'uE' or
                    e.target.text.id == '/tscript' and 'uS' or
                    e.target.text.id == '/tproject' and 'uP' or 't'

                    EDITOR.cursor[1] = EDITOR.cursor[1] + 1
                    table.insert(EDITOR.data, EDITOR.cursor[1] - 1, {thisData and e.target.text.text or e.target.text.id, type})
                    DATA.set(type, e.target.text.id)
                    EDITOR.backup = LISTENER.backup(EDITOR.backup, 'add', EDITOR.data)

                    TEXT.set(TEXT.gen(EDITOR.data, EDITOR.cursor[2]), EDITOR.group[9])
                end
            end
        end
    end

    return true
end

local function moveListButtons(buttons, index, height)
    for i = index, #buttons do
        buttons[i].y = buttons[i].y + height
        buttons[i].text.y = buttons[i].text.y + height
        if buttons[i].polygon then buttons[i].polygon.y = buttons[i].polygon.y + height end
    end
end

local function getId(y)
    return (y - 35) / 70 + 1
end

local getFontSize getFontSize = function(width, text, size)
    local checkText = display.newText(text, 0, 5000, 'ubuntu', size)
    if checkText.width > width - 30 then checkText:removeSelf() return getFontSize(width, text, size - 1) else checkText:removeSelf() return size end
end

listeners.set = function(target, buttons, isData, isList)
    if buttons and (isList and #buttons.names > 0 or #buttons > 0) then
        target.isOpen = not target.isOpen
        target.polygon.yScale = target.isOpen and -1 or 1
        buttons = buttons.names and buttons or {names = COPY_TABLE(buttons)}

        if target.isOpen then
            local listScroll = EDITOR.group[66]
            local listButtonsX = listScroll.width / 2
            local listButtonsY = target.y + 70

            for i = 1, #buttons.names do
                local j, i, text = i, i + getId(target.y), buttons.names[i]
                table.insert(listScroll.buttons, i, {})

                listScroll.buttons[i] = display.newRect(listButtonsX, listButtonsY, listScroll.width, 70)
                    if isData then
                        listScroll.buttons[i].isOpen = false
                        listScroll.buttons[i]:setFillColor(0.14, 0.14, 0.16)
                    elseif target.text.id == 'event' or target.text.id == 'script' or target.text.id == 'project'
                    or target.text.id == 'event' or target.text.id == 'script' or target.text.id == 'project' then
                        listScroll.buttons[i]:setFillColor(0.17, 0.17, 0.19)
                    else
                        listScroll.buttons[i]:setFillColor(0.14, 0.14, 0.16)
                    end listScroll.buttons[i].count = 0
                listScroll:insert(listScroll.buttons[i])

                listScroll.buttons[i].text = display.newText(text, 20, listButtonsY, 'ubuntu', getFontSize(listScroll.width, text, 28))
                    if isData then
                        listScroll.buttons[i].text.id = getId(target.y) == 1
                        and (j == 1 and 'event' or j == 2 and 'script' or 'project')
                        or (j == 1 and 'tevent' or j == 2 and 'tscript' or 'tproject')
                    elseif isList then
                        listScroll.buttons[i].text.id = buttons.keys[j]
                        listScroll.buttons[i].text.ID = target.text.id
                    else
                        listScroll.buttons[i].text.id = '/' .. target.text.id
                    end
                    listScroll.buttons[i].text.anchorX = 0
                listScroll:insert(listScroll.buttons[i].text)

                if isData then
                    listScroll.buttons[i].polygon = display.newPolygon(listScroll.width - 30, listButtonsY, {0, 0, 10, 10, -10, 10})
                    listScroll:insert(listScroll.buttons[i].polygon)
                end

                listButtonsY = listButtonsY + 70
                listScroll.scrollHeight = listScroll.scrollHeight + 70
                listScroll.buttons[i]:addEventListener('touch', listeners.listener)
            end

            target.count = #buttons.names
            moveListButtons(listScroll.buttons, #buttons.names + getId(target.y) + 1, #buttons.names * 70)
            listScroll:setScrollHeight(listScroll.scrollHeight)
        else
            local listScroll = EDITOR.group[66]
            local moveY = 0

            for i = getId(target.y) + 1, getId(target.y) + #buttons.names do
                local index = getId(target.y) + 1

                if listScroll.buttons[index].polygon then
                    listScroll.buttons[index].polygon:removeSelf() listScroll.buttons[index].polygon = nil

                    for j = index + 1, index + listScroll.buttons[index].count do
                        moveY = moveY - 70 listScroll.scrollHeight = listScroll.scrollHeight - 70
                        listScroll.buttons[index + 1].text:removeSelf() listScroll.buttons[index + 1].text = nil
                        listScroll.buttons[index + 1]:removeSelf() table.remove(listScroll.buttons, index + 1)
                    end
                end

                moveY = moveY - 70 listScroll.scrollHeight = listScroll.scrollHeight - 70
                listScroll.buttons[index].text:removeSelf() listScroll.buttons[index].text = nil
                listScroll.buttons[index]:removeSelf() table.remove(listScroll.buttons, index)
            end

            target.count = 0
            moveListButtons(listScroll.buttons, getId(target.y) + 1, moveY)
            listScroll:setScrollHeight(listScroll.scrollHeight)
        end
    end
end

listeners.tproject = function(target)
    listeners.set(target, EDITOR.tables.project)
end

listeners.tscript = function(target)
    listeners.set(target, EDITOR.tables.script)
end

listeners.tevent = function(target)
    listeners.set(target, EDITOR.tables.event)
end

listeners.project = function(target)
    listeners.set(target, EDITOR.vars.project)
end

listeners.script = function(target)
    listeners.set(target, EDITOR.vars.script)
end

listeners.event = function(target)
    listeners.set(target, EDITOR.vars.event)
end

listeners.device = function(target)
    listeners.set(target, EDITOR.device, nil, true)
end

listeners.log = function(target)
    listeners.set(target, EDITOR.log, nil, true)
end

listeners.prop = function(target)
    listeners.set(target, EDITOR.prop, nil, true)
end

listeners.math = function(target)
    listeners.set(target, EDITOR.math, nil, true)
end

listeners.fun = function(target)
    listeners.set(target, EDITOR.fun, nil, true)
end

listeners.var = function(target)
    listeners.set(target, dataButtons, true)
end

listeners.table = function(target)
    listeners.set(target, dataButtons, true)
end

return listeners

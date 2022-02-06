local BLOCK = require 'Core.Modules.logic-block'
local M = {}

M.cancel = function()
    ALERT = true
    M.group:removeSelf() M.group = nil
    BLOCKS.group[8]:setIsLocked(false, 'vertical')
    -- BLOCKS.group:removeSelf() BLOCKS.group = nil
    -- BLOCKS.create() BLOCKS.group.isVisible = true
end

M.listener = function(e)
    if e.phase == 'began' then
        display.getCurrentStage():setFocus(e.target)
        e.target.click = true
        e.target:setFillColor(0.16, 0.16, 0.18)
    elseif e.phase == 'moved' and (math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 30) then
        M.scroll:takeFocus(e)
        e.target.click = false
        e.target:setFillColor(0.14, 0.14, 0.16)
    elseif e.phase == 'ended' or e.phase == 'cancelled' then
        display.getCurrentStage():setFocus(nil)
        if e.target.click then
            e.target.click = false
            e.target:setFillColor(0.14, 0.14, 0.16)
            if e.target.isList and not e.target.isNew then
                M.scroll:setIsLocked(true, 'vertical')
                INPUT.new(STR['blocks.entertext'], function(event)
                    if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                        INPUT.remove(true, event.target.text)
                    end
                end, function(event)
                    ALERT = false
                    M.scroll:setIsLocked(false, 'vertical')
                    timer.performWithDelay(1, function() EXITS.add(M.cancel) end)
                    if event.input then M.rename(e.target, event.text) end
                end, e.target.text) native.setKeyboardFocus(INPUT.box)
            else
                if e.target.isNew or (type(e.target.text) == 'table' and e.target.text.isNew) then
                    M.scroll:setIsLocked(true, 'vertical')
                    INPUT.new(STR['blocks.entertext'], function(event)
                        if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                            INPUT.remove(true, event.target.text)
                        end
                    end, function(event)
                        ALERT = false
                        M.scroll:setIsLocked(false, 'vertical')
                        timer.performWithDelay(1, function() EXITS.add(M.cancel) end)
                        if event.input then M.set(event.text) end
                    end) native.setKeyboardFocus(INPUT.box)
                else
                    local blockIndex, paramsIndex = M.params[2], M.params[3]
                    local params = BLOCKS.group.blocks[blockIndex].data.params
                    local mode = M.active == 'event' and 'vE' or M.active == 'script' and 'vS' or 'vP'

                    M.data.scripts[CURRENT_SCRIPT].params[blockIndex].params[paramsIndex] = {{e.target.text.text, mode}}
                    BLOCKS.group.blocks[blockIndex].data.params[paramsIndex] = {{e.target.text.text, mode}}
                    BLOCKS.group.blocks[blockIndex].params[paramsIndex].value.text = BLOCK.getParamsValueText(params, paramsIndex)

                    SET_GAME_CODE(CURRENT_LINK, M.data)
                    M.cancel()
                end
            end
        end
    end

    return true
end

M.set = function(name)
    if M.active == 'project' and name ~= '' then
        for i = 1, #M.data.vars + 1 do
            if M.data.vars[i] == name then
                return
            end

            if i == #M.data.vars + 1 then
                table.insert(M.data.vars, 1, name)
            end
        end
    elseif M.active == 'script' and name ~= '' then
        for i = 1, #M.data.scripts[CURRENT_SCRIPT].vars + 1 do
            if M.data.scripts[CURRENT_SCRIPT].vars[i] == name then
                return
            end

            if i == #M.data.scripts[CURRENT_SCRIPT].vars + 1 then
                table.insert(M.data.scripts[CURRENT_SCRIPT].vars, 1, name)
            end
        end
    elseif M.active == 'event' and name ~= '' then
        for i = 1, #M.data.scripts[CURRENT_SCRIPT].params[M.vars.index].vars + 1 do
            if M.data.scripts[CURRENT_SCRIPT].params[M.vars.index].vars[i] == name then
                return
            end

            if i == #M.data.scripts[CURRENT_SCRIPT].params[M.vars.index].vars + 1 then
                table.insert(M.data.scripts[CURRENT_SCRIPT].params[M.vars.index].vars, 1, name)
            end
        end
    end

    SET_GAME_CODE(CURRENT_LINK, M.data)
    M.remove(CENTER_X, CENTER_Y - 100, DISPLAY_WIDTH / 1.5, DISPLAY_HEIGHT / 2)
    M.gen(M.active, M.scroll)
end

M.rename = function(target, name)
    if M.active == 'project' then
        for i = 1, #M.data.vars do
            if M.data.vars[i] == name then return end
            if M.data.vars[i] == target.text then
                for j = i, #M.data.vars do
                    if M.data.vars[j] == name then
                        return
                    end
                end

                for j = 1, #M.data.scripts do
                    for k = 1, #M.data.scripts[j].params do
                        for u = 1, #M.data.scripts[j].params[k].params do
                            for o = 1, #M.data.scripts[j].params[k].params[u] do
                                if M.data.scripts[j].params[k].params[u][o][2] == 'vP'
                                and M.data.scripts[j].params[k].params[u][o][1] == target.text then
                                    if name == '' then
                                        table.remove(M.data.scripts[j].params[k].params[u], o)
                                        if CURRENT_SCRIPT == j then
                                            BLOCKS.group.blocks[k].data.params = COPY_TABLE(M.data.scripts[CURRENT_SCRIPT].params[k].params)
                                            BLOCKS.group.blocks[k].params[u].value.text = BLOCK.getParamsValueText(BLOCKS.group.blocks[k].data.params, u)
                                        end
                                    else
                                        M.data.scripts[j].params[k].params[u][o][1] = name
                                        if CURRENT_SCRIPT == j then
                                            BLOCKS.group.blocks[k].data.params = COPY_TABLE(M.data.scripts[CURRENT_SCRIPT].params[k].params)
                                            BLOCKS.group.blocks[k].params[u].value.text = BLOCK.getParamsValueText(BLOCKS.group.blocks[k].data.params, u)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                if name == '' then
                    table.remove(M.data.vars, i)
                else
                    M.data.vars[i] = name
                end

                break
            end
        end
    elseif M.active == 'script' then
        for i = 1, #M.data.scripts[CURRENT_SCRIPT].vars do
            if M.data.scripts[CURRENT_SCRIPT].vars[i] == name then return end
            if M.data.scripts[CURRENT_SCRIPT].vars[i] == target.text then
                for j = i, #M.data.scripts[CURRENT_SCRIPT].vars do
                    if M.data.scripts[CURRENT_SCRIPT].vars[j] == name then
                        return
                    end
                end

                for k = 1, #M.data.scripts[CURRENT_SCRIPT].params do
                    for u = 1, #M.data.scripts[CURRENT_SCRIPT].params[k].params do
                        for o = 1, #M.data.scripts[CURRENT_SCRIPT].params[k].params[u] do
                            if M.data.scripts[CURRENT_SCRIPT].params[k].params[u][o][2] == 'vS'
                            and M.data.scripts[CURRENT_SCRIPT].params[k].params[u][o][1] == target.text then
                                if name == '' then
                                    table.remove(M.data.scripts[CURRENT_SCRIPT].params[k].params[u], o)
                                    BLOCKS.group.blocks[k].data.params = COPY_TABLE(M.data.scripts[CURRENT_SCRIPT].params[k].params)
                                    BLOCKS.group.blocks[k].params[u].value.text = BLOCK.getParamsValueText(BLOCKS.group.blocks[k].data.params, u)
                                else
                                    M.data.scripts[CURRENT_SCRIPT].params[k].params[u][o][1] = name
                                    BLOCKS.group.blocks[k].data.params = COPY_TABLE(M.data.scripts[CURRENT_SCRIPT].params[k].params)
                                    BLOCKS.group.blocks[k].params[u].value.text = BLOCK.getParamsValueText(BLOCKS.group.blocks[k].data.params, u)
                                end
                            end
                        end
                    end
                end

                if name == '' then
                    table.remove(M.data.scripts[CURRENT_SCRIPT].vars, i)
                else
                    M.data.scripts[CURRENT_SCRIPT].vars[i] = name
                end

                break
            end
        end
    elseif M.active == 'event' then
        for i = 1, #M.data.scripts[CURRENT_SCRIPT].params[M.vars.index].vars do
            if M.data.scripts[CURRENT_SCRIPT].params[M.vars.index].vars[i] == name then return end
            if M.data.scripts[CURRENT_SCRIPT].params[M.vars.index].vars[i] == target.text then
                for j = i, #M.data.scripts[CURRENT_SCRIPT].params[M.vars.index].vars do
                    if M.data.scripts[CURRENT_SCRIPT].params[M.vars.index].vars[j] == name then
                        return
                    end
                end

                for k = M.vars.index + 1, #M.data.scripts[CURRENT_SCRIPT].params do
                    if M.data.scripts[CURRENT_SCRIPT].params[k].event then
                        break
                    end

                    for u = 1, #M.data.scripts[CURRENT_SCRIPT].params[k].params do
                        for o = 1, #M.data.scripts[CURRENT_SCRIPT].params[k].params[u] do
                            if M.data.scripts[CURRENT_SCRIPT].params[k].params[u][o][2] == 'vE'
                            and M.data.scripts[CURRENT_SCRIPT].params[k].params[u][o][1] == target.text then
                                if name == '' then
                                    table.remove(M.data.scripts[CURRENT_SCRIPT].params[k].params[u], o)
                                    BLOCKS.group.blocks[k].data.params = COPY_TABLE(M.data.scripts[CURRENT_SCRIPT].params[k].params)
                                    BLOCKS.group.blocks[k].params[u].value.text = BLOCK.getParamsValueText(BLOCKS.group.blocks[k].data.params, u)
                                else
                                    M.data.scripts[CURRENT_SCRIPT].params[k].params[u][o][1] = name
                                    BLOCKS.group.blocks[k].data.params = COPY_TABLE(M.data.scripts[CURRENT_SCRIPT].params[k].params)
                                    BLOCKS.group.blocks[k].params[u].value.text = BLOCK.getParamsValueText(BLOCKS.group.blocks[k].data.params, u)
                                end
                            end
                        end
                    end
                end

                if name == '' then
                    table.remove(M.data.scripts[CURRENT_SCRIPT].params[M.vars.index].vars, i)
                else
                    M.data.scripts[CURRENT_SCRIPT].params[M.vars.index].vars[i] = name
                end

                break
            end
        end
    end

    SET_GAME_CODE(CURRENT_LINK, M.data)
    target.newName(name)
end

M.remove = function(x, y, width, height)
    M.scroll:removeSelf() M.clear()
    M.scroll = WIDGET.newScrollView({
            x = x, y = y - 35,
            width = width, height = height - 70,
            hideBackground = true, hideScrollBar = true,
            horizontalScrollDisabled = true, isBounceEnabled = true
        })
    M.group:insert(M.scroll)
end

M.gen = function(mode, scroll)
    local vars = COPY_TABLE(mode == 'event' and M.vars.event or mode == 'script' and M.vars.script or M.vars.project)
    local buttons, buttonsY = {}, 35 vars[#vars + 1] = STR['blocks.createvar']

    for i = 1, #vars do
        buttons[i] = display.newRect(scroll.width / 2, buttonsY, scroll.width, 70)
            buttons[i]:setFillColor(0.14, 0.14, 0.16)
            buttons[i]:addEventListener('touch', M.listener)
        scroll:insert(buttons[i])

        buttons[i].text = display.newText({
                width = buttons[i].width - 70, x = buttons[i].width / 2 - 15, y = buttonsY + 2,
                text = vars[i], font = 'ubuntu', fontSize = 26, height = 40
            }) buttons[i].text.isNew = i == #vars
        scroll:insert(buttons[i].text)

        buttons[i].plus = display.newRect(scroll.width - 35, buttonsY, 70, 70)
            buttons[i].plus.isList = true
            buttons[i].plus.text = vars[i]
            buttons[i].plus.isNew = i == #vars
            buttons[i].plus:setFillColor(0.14, 0.14, 0.16)
            buttons[i].plus:addEventListener('touch', M.listener)
        scroll:insert(buttons[i].plus)

        buttons[i].plus1 = display.newRect(scroll.width - 35, buttonsY, 30, 3)
            buttons[i].plus1:setFillColor(0.8)
        scroll:insert(buttons[i].plus1)

        if buttons[i].text.isNew then
            buttons[#buttons].plus2 = display.newRect(scroll.width - 35, buttonsY, 3, 30)
                buttons[#buttons].plus2:setFillColor(0.8)
            scroll:insert(buttons[#buttons].plus2) break
        end

        buttons[i].plus2 = display.newRect(scroll.width - 35, buttonsY - 10, 30, 3)
            buttons[i].plus2:setFillColor(0.8)
        scroll:insert(buttons[i].plus2)

        buttons[i].plus3 = display.newRect(scroll.width - 35, buttonsY + 10, 30, 3)
            buttons[i].plus3:setFillColor(0.8)
        scroll:insert(buttons[i].plus3)

        buttonsY = buttonsY + 70
        buttons[i].plus.newName = function(name)
            if name == '' then
                M.remove(CENTER_X, CENTER_Y - 100, DISPLAY_WIDTH / 1.5, DISPLAY_HEIGHT / 2)
                M.gen(M.active, M.scroll)
            else
                buttons[i].text.text = name
                buttons[i].plus.text = name
            end
        end
    end
end

M.new = function(mode, blockIndex, paramsIndex, paramsData)
    if not M.group then
        ALERT = false
        M.active = 'event'
        M.group = display.newGroup()
        M.data = GET_GAME_CODE(CURRENT_LINK)
        M.params = {mode, blockIndex, paramsIndex}
        M.vars = {project = M.data.vars, script = M.data.scripts[CURRENT_SCRIPT].vars, event = {}}

        for i = blockIndex, 1, -1 do
            if M.data.scripts[CURRENT_SCRIPT].params[i].event then
                M.vars.index = i
                M.vars.event = M.data.scripts[CURRENT_SCRIPT].params[i].vars
                break
            end
        end

        if paramsData and paramsData[1] and type(paramsData[1]) == 'table' then
            if paramsData[1][2] == 'vE' then
                for i = 1, #M.vars.event do
                    if M.vars.event[i] == paramsData[1][1] then
                        table.remove(M.vars.event, i)
                        table.insert(M.vars.event, 1, paramsData[1][1])
                    end
                end
            elseif paramsData[1][2] == 'vS' then
                M.active = 'script'
                for i = 1, #M.vars.script do
                    if M.vars.script[i] == paramsData[1][1] then
                        table.remove(M.vars.script, i)
                        table.insert(M.vars.script, 1, paramsData[1][1])
                    end
                end
            elseif paramsData[1][2] == 'vP' then
                M.active = 'project'
                for i = 1, #M.vars.project do
                    if M.vars.project[i] == paramsData[1][1] then
                        table.remove(M.vars.project, i)
                        table.insert(M.vars.project, 1, paramsData[1][1])
                    end
                end
            end
        end

        local bg = display.newRect(CENTER_X, CENTER_Y - 100, DISPLAY_WIDTH / 1.5, DISPLAY_HEIGHT / 2)
            bg.y = bg.height < 400 and CENTER_Y or CENTER_Y - 100
            bg.height = bg.height < 400 and DISPLAY_HEIGHT / 1.5 or DISPLAY_HEIGHT / 2
            bg:setFillColor(0.18, 0.18, 0.2)
        M.group:insert(bg)

        M.scroll = WIDGET.newScrollView({
                x = bg.x, y = bg.y - 35,
                width = bg.width, height = bg.height - 70,
                hideBackground = true, hideScrollBar = true,
                horizontalScrollDisabled = true, isBounceEnabled = true
            }) local width, y = M.scroll.width / 3, M.scroll.y + M.scroll.height / 2 + 35
        M.group:insert(M.scroll)

        local buttonEvent = display.newRect(bg.x - width, y, width, 70)
            buttonEvent:addEventListener('touch', M.select)
        M.group:insert(buttonEvent)

        local textEvent = display.newText(STR['editor.list.event'], buttonEvent.x, buttonEvent.y, 'ubuntu', 26)
            buttonEvent.id = 'event'
        M.group:insert(textEvent)

        local buttonScript = display.newRect(bg.x, y, width, 70)
            buttonScript:addEventListener('touch', M.select)
        M.group:insert(buttonScript)

        local textScript = display.newText(STR['editor.list.script'], buttonScript.x, buttonScript.y, 'ubuntu', 26)
            buttonScript.id = 'script'
        M.group:insert(textScript)

        local buttonProject = display.newRect(bg.x + width, y, width, 70)
            buttonProject:addEventListener('touch', M.select)
        M.group:insert(buttonProject)

        local textProject = display.newText(STR['editor.list.project'], buttonProject.x, buttonProject.y, 'ubuntu', 26)
            buttonProject.id = 'project'
        M.group:insert(textProject)

        M.clear = function()
            buttonEvent:setFillColor(0.26, 0.26, 0.28)
            buttonScript:setFillColor(0.26, 0.26, 0.28)
            buttonProject:setFillColor(0.26, 0.26, 0.28)
            if M.active == 'event' then buttonEvent:setFillColor(0.2, 0.2, 0.22) end
            if M.active == 'script' then buttonScript:setFillColor(0.2, 0.2, 0.22) end
            if M.active == 'project' then buttonProject:setFillColor(0.2, 0.2, 0.22) end
        end

        local delimiter1 = display.newRect(bg.x - width / 2, buttonEvent.y, 3, 70)
            delimiter1:setFillColor(0.6)
        M.group:insert(delimiter1)

        local delimiter2 = display.newRect(bg.x + width / 2, buttonScript.y, 3, 70)
            delimiter2:setFillColor(0.6)
        M.group:insert(delimiter2)

        local delimiter2 = display.newRect(bg.x, buttonProject.y - 33.5, bg.width, 3)
            delimiter2:setFillColor(0.6)
        M.group:insert(delimiter2)

        M.clear()
        EXITS.add(M.cancel)
        M.gen(M.active, M.scroll)
    end
end

M.select = function(e)
    if e.phase == 'began' then
        display.getCurrentStage():setFocus(e.target)
        e.target.click = true
    elseif e.phase == 'moved' and (math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 30) then
        display.getCurrentStage():setFocus(nil)
        e.target.click = false
    elseif e.phase == 'ended' or e.phase == 'cancelled' then
        display.getCurrentStage():setFocus(nil)
        if e.target.click then
            e.target.click = false
            M.active = e.target.id
            M.remove(CENTER_X, CENTER_Y - 100, DISPLAY_WIDTH / 1.5, DISPLAY_HEIGHT / 2)
            M.gen(e.target.id, M.scroll)
        end
    end

    return true
end

return M

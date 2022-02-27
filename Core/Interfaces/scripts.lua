local listeners = {}
local LIST = require 'Core.Modules.interface-list'
local MOVE = require 'Core.Modules.interface-move'

listeners.but_add = function(target)
    SCRIPTS.group[8]:setIsLocked(true, 'vertical')
    if SCRIPTS.group.isVisible then
        INPUT.new(STR['scripts.entername'], function(event)
            if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                INPUT.remove(true, event.target.text)
            end
        end, function(e)
            SCRIPTS.group[8]:setIsLocked(false, 'vertical')

            if e.input then
                local data = GET_GAME_CODE(CURRENT_LINK)
                local scrollY = select(2, SCRIPTS.group[8]:getContentPosition())
                local diffY = SCRIPTS.group[8].y - SCRIPTS.group[8].height / 2
                local targetY = math.abs(scrollY) + diffY + CENTER_Y - 150

                for i = 1, #SCRIPTS.group.data do
                    if SCRIPTS.group.data[i].y > targetY then
                        table.insert(data.scripts, i, {title = e.text, params = {}, vars = {}, tables = {}})
                        SET_GAME_CODE(CURRENT_LINK, data)
                        SCRIPTS.new(e.text, i)
                        return
                    end
                end

                table.insert(data.scripts, #data.scripts + 1, {title = e.text, params = {}, vars = {}, tables = {}})
                SET_GAME_CODE(CURRENT_LINK, data)
                SCRIPTS.new(e.text, #SCRIPTS.group.blocks + 1)
            end
        end)
    else
        SCRIPTS.group[8]:setIsLocked(false, 'vertical')
    end
end

listeners.but_play = function(target)
end

listeners.but_list = function(target)
    if #SCRIPTS.group.blocks > 0 then
        SCRIPTS.group[8]:setIsLocked(true, 'vertical')
        if SCRIPTS.group.isVisible then
            LIST.new({STR['button.remove'], STR['button.rename'], STR['button.copy']}, MAX_X, target.y - target.height / 2, 'down', function(e)
                SCRIPTS.group[8]:setIsLocked(false, 'vertical')

                if e.index ~= 0 then
                    ALERT = false
                    INDEX_LIST = e.index

                    SCRIPTS.group[3].isVisible = true
                    SCRIPTS.group[4].isVisible = false
                    SCRIPTS.group[5].isVisible = false
                    SCRIPTS.group[6].isVisible = false
                    SCRIPTS.group[7].isVisible = true
                end

                if e.index == 1 then
                    MORE_LIST = true
                    SCRIPTS.group[3].text = '(' .. STR['button.remove'] .. ')'

                    for i = 1, #SCRIPTS.group.blocks do
                        SCRIPTS.group.blocks[i].checkbox.isVisible = true
                    end
                elseif e.index == 2 then
                    MORE_LIST = false
                    SCRIPTS.group[3].text = '(' .. STR['button.rename'] .. ')'

                    for i = 1, #SCRIPTS.group.blocks do
                        SCRIPTS.group.blocks[i].checkbox.isVisible = true
                    end
                elseif e.index == 3 then
                    MORE_LIST = false
                    SCRIPTS.group[3].text = '(' .. STR['button.copy'] .. ')'

                    for i = 1, #SCRIPTS.group.blocks do
                        SCRIPTS.group.blocks[i].checkbox.isVisible = true
                    end
                end
            end, nil, nil, 1)
        else
            SCRIPTS.group[8]:setIsLocked(false, 'vertical')
        end
    end
end

listeners.but_okay = function(target)
    ALERT = true
    SCRIPTS.group[3].text = ''
    SCRIPTS.group[3].isVisible = false
    SCRIPTS.group[4].isVisible = true
    SCRIPTS.group[5].isVisible = true
    SCRIPTS.group[6].isVisible = true
    SCRIPTS.group[7].isVisible = false

    if INDEX_LIST == 1 then
        for i = #SCRIPTS.group.data, 1, -1 do
            SCRIPTS.group.blocks[i].checkbox.isVisible = false

            if SCRIPTS.group.blocks[i].checkbox.isOn then
                local data = GET_GAME_CODE(CURRENT_LINK)
                table.remove(data.scripts, i)

                SET_GAME_CODE(CURRENT_LINK, data)
                SCRIPTS.group.blocks[i].remove(i)
            end
        end

        for j = 1, #SCRIPTS.group.blocks do
            local y = j == 1 and 75 or SCRIPTS.group.data[j - 1].y + 150
            SCRIPTS.group.blocks[j].y = y
            SCRIPTS.group.blocks[j].text.y = y
            SCRIPTS.group.blocks[j].checkbox.y = y
            SCRIPTS.group.blocks[j].container.y = y
            SCRIPTS.group.data[j].y = y
        end

        SCRIPTS.group[8]:setScrollHeight(150 * #SCRIPTS.group.data)
    elseif INDEX_LIST == 2 then
        for i = #SCRIPTS.group.blocks, 1, -1 do
            SCRIPTS.group.blocks[i].checkbox.isVisible = false

            if SCRIPTS.group.blocks[i].checkbox.isOn then
                SCRIPTS.group.blocks[i].checkbox:setState({isOn=false})
                INPUT.new(STR['scripts.changename'], function(event)
                    if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                        INPUT.remove(true, event.target.text)
                    end
                end, function(e)
                    if e.input then
                        local data = GET_GAME_CODE(CURRENT_LINK)
                        data.scripts[i].title = e.text

                        SET_GAME_CODE(CURRENT_LINK, data)
                        SCRIPTS.group.blocks[i].text.text = e.text
                    end
                end, SCRIPTS.group.blocks[i].text.text)
            end
        end
    elseif INDEX_LIST == 3 then
        for i = #SCRIPTS.group.blocks, 1, -1 do
            SCRIPTS.group.blocks[i].checkbox.isVisible = false

            if SCRIPTS.group.blocks[i].checkbox.isOn then
                SCRIPTS.group.blocks[i].checkbox:setState({isOn=false})
                INPUT.new(STR['scripts.entername'], function(event)
                    if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                        INPUT.remove(true, event.target.text)
                    end
                end, function(e)
                    if e.input then
                        local data = GET_GAME_CODE(CURRENT_LINK)
                        local scrollY = select(2, SCRIPTS.group[8]:getContentPosition())
                        local diffY = SCRIPTS.group[8].y - SCRIPTS.group[8].height / 2
                        local targetY = math.abs(scrollY) + diffY + CENTER_Y - 150

                        for j = 1, #SCRIPTS.group.data do
                            if SCRIPTS.group.data[j].y > targetY then
                                table.insert(data.scripts, j, {
                                    title = e.text, params = data.scripts[i].params,
                                    vars = data.scripts[i].vars, tables = data.scripts[i].tables
                                })

                                SET_GAME_CODE(CURRENT_LINK, data)
                                SCRIPTS.new(e.text, j)
                                return
                            end
                        end

                        table.insert(data.scripts, #data.scripts + 1, {
                            title = e.text, params = data.scripts[i].params,
                            vars = data.scripts[i].vars, tables = data.scripts[i].tables
                        })

                        SET_GAME_CODE(CURRENT_LINK, data)
                        SCRIPTS.new(e.text, #SCRIPTS.group.blocks + 1)
                    end
                end, SCRIPTS.group.blocks[i].text.text)
            end
        end
    end
end

return function(e)
    if SCRIPTS.group.isVisible and (ALERT or e.target.button == 'but_okay') then
        if e.phase == 'began' then
            display.getCurrentStage():setFocus(e.target)
            e.target.click = true
            if e.target.button == 'but_list'
            then e.target.width, e.target.height = 103 / 1.2, 84 / 1.2
            else e.target.alpha = 0.6 end
        elseif e.phase == 'moved' and (math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 30) then
            e.target.click = false
            if e.target.button == 'but_list'
            then e.target.width, e.target.height = 103, 84
            else e.target.alpha = 0.9 end
        elseif e.phase == 'ended' or e.phase == 'cancelled' then
            display.getCurrentStage():setFocus(nil)
            if e.target.click then
                e.target.click = false
                if e.target.button == 'but_list'
                then e.target.width, e.target.height = 103, 84
                else e.target.alpha = 0.9 end
                listeners[e.target.button](e.target)
            end
        end
        return true
    end
end

local listeners = {}
local INPUT = require 'Core.Modules.interface-input'
local LIST = require 'Core.Modules.interface-list'
local MOVE = require 'Core.Modules.interface-move'

listeners.but_add = function(target)
    FONTS.group[8]:setIsLocked(true, 'vertical')
    if FONTS.group.isVisible then
        INPUT.new(STR['fonts.entername'], function(event)
            if event.phase == 'editing' then
                if UTF8.find(event.target.text, '\n') then
                    INPUT.remove(true, event.oldText)
                end
            end
        end, function(e)
            FONTS.group[8]:setIsLocked(false, 'vertical')

            if e.input then
                local numFont = 1
                local path = DOC_DIR .. '/' .. CURRENT_LINK .. '/Fonts'

                local completeImportPicture = function(import)
                    if import.done and import.done == 'ok' then
                        local data = GET_GAME_CODE(CURRENT_LINK)
                        local path = path .. '/Font' .. numFont

                        table.insert(data.resources.fonts, 1, {e.text, 'Font' .. numFont})
                        SET_GAME_CODE(CURRENT_LINK, data)
                        FONTS.new(e.text, 1, 'Font' .. numFont)
                    end
                end

                while true do
                    local file = io.open(path .. '/Font' .. numFont, 'r')
                    if file then
                        numFont = numFont + 1
                        io.close(file)
                    else
                        FILE.pickFile(path, completeImportPicture, 'Font' .. numFont, '', '*/*', nil, nil, nil)
                        break
                    end
                end
            end
        end)
    else
        FONTS.group[8]:setIsLocked(false, 'vertical')
    end
end

listeners.but_play = function(target)
end

listeners.but_list = function(target)
    local list = #FONTS.group.blocks == 0 and {STR['button.find']}
    or {STR['button.remove'], STR['button.rename'], STR['button.find']}

    FONTS.group[8]:setIsLocked(true, 'vertical')
    if FONTS.group.isVisible then
        LIST.new(list, MAX_X, target.y - target.height / 2, 'down', function(e)
            FONTS.group[8]:setIsLocked(false, 'vertical')

            if e.index ~= 0 and e.text ~= STR['button.find'] then
                ALERT = false
                INDEX_LIST = e.index

                FONTS.group[3].isVisible = true
                FONTS.group[4].isVisible = false
                FONTS.group[5].isVisible = false
                FONTS.group[6].isVisible = false
                FONTS.group[7].isVisible = true
            end

            if e.text == STR['button.remove'] then
                MORE_LIST = true
                FONTS.group[3].text = '(' .. STR['button.remove'] .. ')'

                for i = 1, #FONTS.group.blocks do
                    FONTS.group.blocks[i].checkbox.isVisible = true
                end
            elseif e.text == STR['button.rename'] then
                MORE_LIST = false
                FONTS.group[3].text = '(' .. STR['button.rename'] .. ')'

                for i = 1, #FONTS.group.blocks do
                    FONTS.group.blocks[i].checkbox.isVisible = true
                end
            elseif e.text == STR['button.find'] then
                FONTS.group[8]:setIsLocked(true, 'vertical')
                INPUT.new(STR['fonts.entername'], function(event)
                    if event.phase == 'editing' then
                        if UTF8.find(event.target.text, '\n') then
                            INPUT.remove(true, event.oldText)
                        end
                    end
                end, function(e)
                    FONTS.group[8]:setIsLocked(false, 'vertical')

                    if e.input then
                        local data = GET_GAME_CODE(CURRENT_LINK)

                        for i = #FONTS.group.data, 1, -1 do
                            FONTS.group.blocks[i].remove(i)
                        end

                        for index, font_config in pairs(data.resources.fonts) do
                            if UTF8.find(UTF8.lower(font_config[1]), UTF8.lower(e.text)) then
                                FONTS.new(font_config[1], #FONTS.group.blocks + 1, font_config[2])
                            end
                        end
                    end
                end)
            end
        end, nil, nil, 1)
    else
        FONTS.group[8]:setIsLocked(false, 'vertical')
    end
end

listeners.but_okay = function(target)
    ALERT = true
    FONTS.group[3].text = ''
    FONTS.group[3].isVisible = false
    FONTS.group[4].isVisible = true
    FONTS.group[5].isVisible = true
    FONTS.group[6].isVisible = true
    FONTS.group[7].isVisible = false

    if INDEX_LIST == 1 then
        for i = #FONTS.group.data, 1, -1 do
            FONTS.group.blocks[i].checkbox.isVisible = false

            if FONTS.group.blocks[i].checkbox.isOn then
                local data = GET_GAME_CODE(CURRENT_LINK)
                table.remove(data.resources.fonts, i)

                SET_GAME_CODE(CURRENT_LINK, data)
                OS_REMOVE(DOC_DIR .. '/' .. CURRENT_LINK .. '/Fonts/' .. FONTS.group.blocks[i].link)
                FONTS.group.blocks[i].remove(i)
            end
        end

        for j = 1, #FONTS.group.blocks do
            local y = j == 1 and 75 or FONTS.group.data[j - 1].y + 150
            FONTS.group.blocks[j].y = y
            FONTS.group.blocks[j].text.y = y
            FONTS.group.blocks[j].checkbox.y = y
            FONTS.group.blocks[j].container.y = y
            FONTS.group.data[j].y = y
        end

        FONTS.group[8]:setScrollHeight(150 * #FONTS.group.data)
    elseif INDEX_LIST == 2 then
        for i = #FONTS.group.blocks, 1, -1 do
            FONTS.group.blocks[i].checkbox.isVisible = false

            if FONTS.group.blocks[i].checkbox.isOn then
                FONTS.group.blocks[i].checkbox:setState({isOn=false})
                INPUT.new(STR['fonts.changename'], function(event)
                    if event.phase == 'editing' then
                        if UTF8.find(event.target.text, '\n') then
                            INPUT.remove(true, event.oldText)
                        end
                    end
                end, function(e)
                    if e.input then
                        local data = GET_GAME_CODE(CURRENT_LINK)
                        data.resources.fonts[i][1] = e.text

                        SET_GAME_CODE(CURRENT_LINK, data)
                        FONTS.group.blocks[i].text.text = e.text
                    end
                end, FONTS.group.blocks[i].text.text)
            end
        end
    end
end

return function(e)
    if FONTS.group.isVisible and (ALERT or e.target.button == 'but_okay') then
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

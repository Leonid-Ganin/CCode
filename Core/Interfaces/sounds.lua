local listeners = {}
local INPUT = require 'Core.Modules.interface-input'
local LIST = require 'Core.Modules.interface-list'
local MOVE = require 'Core.Modules.interface-move'

listeners.but_add = function(target)
    SOUNDS.group[8]:setIsLocked(true, 'vertical')
    if SOUNDS.group.isVisible then
        INPUT.new(STR['sounds.entername'], function(event)
            if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                INPUT.remove(true, event.target.text)
            end
        end, function(e)
            SOUNDS.group[8]:setIsLocked(false, 'vertical')

            if e.input then
                local numSound = 1
                local path = DOC_DIR .. '/' .. CURRENT_LINK .. '/Sounds'

                local completeImportPicture = function(import)
                    if import.done and import.done == 'ok' then
                        local data = GET_GAME_CODE(CURRENT_LINK)
                        local path = path .. '/Sound' .. numSound

                        table.insert(data.resources.sounds, 1, {e.text, 'Sound' .. numSound})
                        SET_GAME_CODE(CURRENT_LINK, data)
                        SOUNDS.new(e.text, 1, 'Sound' .. numSound)
                    end
                end

                while true do
                    local file = io.open(path .. '/Sound' .. numSound, 'r')
                    if file then
                        numSound = numSound + 1
                        io.close(file)
                    else
                        FILE.pickFile(path, completeImportPicture, 'Sound' .. numSound, '', 'audio/*', nil, nil, nil)
                        break
                    end
                end
            end
        end)
    else
        SOUNDS.group[8]:setIsLocked(false, 'vertical')
    end
end

listeners.but_play = function(target)
end

listeners.but_list = function(target)
    local list = #SOUNDS.group.blocks == 0 and {STR['button.find']}
    or {STR['button.remove'], STR['button.rename'], STR['button.find']}

    SOUNDS.group[8]:setIsLocked(true, 'vertical')
    if SOUNDS.group.isVisible then
        LIST.new(list, MAX_X, target.y - target.height / 2, 'down', function(e)
            SOUNDS.group[8]:setIsLocked(false, 'vertical')

            if e.index ~= 0 and e.text ~= STR['button.find'] then
                ALERT = false
                INDEX_LIST = e.index

                SOUNDS.group[3].isVisible = true
                SOUNDS.group[4].isVisible = false
                SOUNDS.group[5].isVisible = false
                SOUNDS.group[6].isVisible = false
                SOUNDS.group[7].isVisible = true
            end

            if e.text == STR['button.remove'] then
                MORE_LIST = true
                SOUNDS.group[3].text = '(' .. STR['button.remove'] .. ')'

                for i = 1, #SOUNDS.group.blocks do
                    SOUNDS.group.blocks[i].checkbox.isVisible = true
                end
            elseif e.text == STR['button.rename'] then
                MORE_LIST = false
                SOUNDS.group[3].text = '(' .. STR['button.rename'] .. ')'

                for i = 1, #SOUNDS.group.blocks do
                    SOUNDS.group.blocks[i].checkbox.isVisible = true
                end
            elseif e.text == STR['button.find'] then
                SOUNDS.group[8]:setIsLocked(true, 'vertical')
                INPUT.new(STR['sounds.entername'], function(event)
                    if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                        INPUT.remove(true, event.target.text)
                    end
                end, function(e)
                    SOUNDS.group[8]:setIsLocked(false, 'vertical')

                    if e.input then
                        local data = GET_GAME_CODE(CURRENT_LINK)

                        for i = #SOUNDS.group.data, 1, -1 do
                            SOUNDS.group.blocks[i].remove(i)
                        end

                        for index, sound_config in pairs(data.resources.sounds) do
                            if UTF8.find(UTF8.lower(sound_config[1]), UTF8.lower(e.text)) then
                                SOUNDS.new(sound_config[1], #SOUNDS.group.blocks + 1, sound_config[2])
                            end
                        end
                    end
                end)
            end
        end, nil, nil, 1)
    else
        SOUNDS.group[8]:setIsLocked(false, 'vertical')
    end
end

listeners.but_okay = function(target)
    ALERT = true
    SOUNDS.group[3].text = ''
    SOUNDS.group[3].isVisible = false
    SOUNDS.group[4].isVisible = true
    SOUNDS.group[5].isVisible = true
    SOUNDS.group[6].isVisible = true
    SOUNDS.group[7].isVisible = false

    if INDEX_LIST == 1 then
        for i = #SOUNDS.group.data, 1, -1 do
            SOUNDS.group.blocks[i].checkbox.isVisible = false

            if SOUNDS.group.blocks[i].checkbox.isOn then
                local data = GET_GAME_CODE(CURRENT_LINK)
                table.remove(data.resources.sounds, i)

                SET_GAME_CODE(CURRENT_LINK, data)
                OS_REMOVE(DOC_DIR .. '/' .. CURRENT_LINK .. '/Sounds/' .. SOUNDS.group.blocks[i].link)
                SOUNDS.group.blocks[i].remove(i)
            end
        end

        for j = 1, #SOUNDS.group.blocks do
            local y = j == 1 and 75 or SOUNDS.group.data[j - 1].y + 150
            SOUNDS.group.blocks[j].y = y
            SOUNDS.group.blocks[j].text.y = y
            SOUNDS.group.blocks[j].checkbox.y = y
            SOUNDS.group.blocks[j].container.y = y
            SOUNDS.group.data[j].y = y
        end

        SOUNDS.group[8]:setScrollHeight(150 * #SOUNDS.group.data)
    elseif INDEX_LIST == 2 then
        for i = #SOUNDS.group.blocks, 1, -1 do
            SOUNDS.group.blocks[i].checkbox.isVisible = false

            if SOUNDS.group.blocks[i].checkbox.isOn then
                SOUNDS.group.blocks[i].checkbox:setState({isOn=false})
                INPUT.new(STR['sounds.changename'], function(event)
                    if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                        INPUT.remove(true, event.target.text)
                    end
                end, function(e)
                    if e.input then
                        local data = GET_GAME_CODE(CURRENT_LINK)
                        data.resources.sounds[i][1] = e.text

                        SET_GAME_CODE(CURRENT_LINK, data)
                        SOUNDS.group.blocks[i].text.text = e.text
                    end
                end, SOUNDS.group.blocks[i].text.text)
            end
        end
    end
end

return function(e)
    if SOUNDS.group.isVisible and (ALERT or e.target.button == 'but_okay') then
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

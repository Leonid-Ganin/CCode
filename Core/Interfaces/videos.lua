local listeners = {}
local LIST = require 'Core.Modules.interface-list'
local MOVE = require 'Core.Modules.interface-move'

listeners.but_add = function(target)
    VIDEOS.group[8]:setIsLocked(true, 'vertical')
    if VIDEOS.group.isVisible then
        INPUT.new(STR['videos.entername'], function(event)
            if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                INPUT.remove(true, event.target.text)
            end
        end, function(e)
            VIDEOS.group[8]:setIsLocked(false, 'vertical')

            if e.input then
                local numVideo = 1
                local path = DOC_DIR .. '/' .. CURRENT_LINK .. '/Videos'

                local completeImportPicture = function(import)
                    if import.done and import.done == 'ok' then
                        local data = GET_GAME_CODE(CURRENT_LINK)
                        local path = path .. '/Video' .. numVideo

                        table.insert(data.resources.videos, 1, {e.text, 'Video' .. numVideo})
                        SET_GAME_CODE(CURRENT_LINK, data)
                        VIDEOS.new(e.text, 1, 'Video' .. numVideo)
                    end
                end

                while true do
                    local file = io.open(path .. '/Video' .. numVideo, 'r')
                    if file then
                        numVideo = numVideo + 1
                        io.close(file)
                    else
                        FILE.pickFile(path, completeImportPicture, 'Video' .. numVideo, '', 'video/*', nil, nil, nil)
                        break
                    end
                end
            end
        end)
    else
        VIDEOS.group[8]:setIsLocked(false, 'vertical')
    end
end

listeners.but_play = function(target)
end

listeners.but_list = function(target)
    local list = #VIDEOS.group.blocks == 0 and {STR['button.find']}
    or {STR['button.remove'], STR['button.rename'], STR['button.find']}

    VIDEOS.group[8]:setIsLocked(true, 'vertical')
    if VIDEOS.group.isVisible then
        LIST.new(list, MAX_X, target.y - target.height / 2, 'down', function(e)
            VIDEOS.group[8]:setIsLocked(false, 'vertical')

            if e.index ~= 0 and e.text ~= STR['button.find'] then
                ALERT = false
                INDEX_LIST = e.index

                VIDEOS.group[3].isVisible = true
                VIDEOS.group[4].isVisible = false
                VIDEOS.group[5].isVisible = false
                VIDEOS.group[6].isVisible = false
                VIDEOS.group[7].isVisible = true
            end

            if e.text == STR['button.remove'] then
                MORE_LIST = true
                VIDEOS.group[3].text = '(' .. STR['button.remove'] .. ')'

                for i = 1, #VIDEOS.group.blocks do
                    VIDEOS.group.blocks[i].checkbox.isVisible = true
                end
            elseif e.text == STR['button.rename'] then
                MORE_LIST = false
                VIDEOS.group[3].text = '(' .. STR['button.rename'] .. ')'

                for i = 1, #VIDEOS.group.blocks do
                    VIDEOS.group.blocks[i].checkbox.isVisible = true
                end
            elseif e.text == STR['button.find'] then
                VIDEOS.group[8]:setIsLocked(true, 'vertical')
                INPUT.new(STR['videos.entername'], function(event)
                    if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                        INPUT.remove(true, event.target.text)
                    end
                end, function(e)
                    VIDEOS.group[8]:setIsLocked(false, 'vertical')

                    if e.input then
                        local data = GET_GAME_CODE(CURRENT_LINK)

                        for i = #VIDEOS.group.data, 1, -1 do
                            VIDEOS.group.blocks[i].remove(i)
                        end

                        for index, video_config in pairs(data.resources.videos) do
                            if UTF8.find(UTF8.lower(video_config[1]), UTF8.lower(e.text)) then
                                VIDEOS.new(video_config[1], #VIDEOS.group.blocks + 1, video_config[2])
                            end
                        end
                    end
                end)
            end
        end, nil, nil, 1)
    else
        VIDEOS.group[8]:setIsLocked(false, 'vertical')
    end
end

listeners.but_okay = function(target)
    ALERT = true
    VIDEOS.group[3].text = ''
    VIDEOS.group[3].isVisible = false
    VIDEOS.group[4].isVisible = true
    VIDEOS.group[5].isVisible = true
    VIDEOS.group[6].isVisible = true
    VIDEOS.group[7].isVisible = false

    if INDEX_LIST == 1 then
        for i = #VIDEOS.group.data, 1, -1 do
            VIDEOS.group.blocks[i].checkbox.isVisible = false

            if VIDEOS.group.blocks[i].checkbox.isOn then
                local data = GET_GAME_CODE(CURRENT_LINK)
                table.remove(data.resources.videos, i)

                SET_GAME_CODE(CURRENT_LINK, data)
                OS_REMOVE(DOC_DIR .. '/' .. CURRENT_LINK .. '/Videos/' .. VIDEOS.group.blocks[i].link)
                VIDEOS.group.blocks[i].remove(i)
            end
        end

        for j = 1, #VIDEOS.group.blocks do
            local y = j == 1 and 75 or VIDEOS.group.data[j - 1].y + 150
            VIDEOS.group.blocks[j].y = y
            VIDEOS.group.blocks[j].text.y = y
            VIDEOS.group.blocks[j].checkbox.y = y
            VIDEOS.group.blocks[j].container.y = y
            VIDEOS.group.data[j].y = y
        end

        VIDEOS.group[8]:setScrollHeight(150 * #VIDEOS.group.data)
    elseif INDEX_LIST == 2 then
        for i = #VIDEOS.group.blocks, 1, -1 do
            VIDEOS.group.blocks[i].checkbox.isVisible = false

            if VIDEOS.group.blocks[i].checkbox.isOn then
                VIDEOS.group.blocks[i].checkbox:setState({isOn=false})
                INPUT.new(STR['videos.changename'], function(event)
                    if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                        INPUT.remove(true, event.target.text)
                    end
                end, function(e)
                    if e.input then
                        local data = GET_GAME_CODE(CURRENT_LINK)
                        data.resources.videos[i][1] = e.text

                        SET_GAME_CODE(CURRENT_LINK, data)
                        VIDEOS.group.blocks[i].text.text = e.text
                    end
                end, VIDEOS.group.blocks[i].text.text)
            end
        end
    end
end

return function(e)
    if VIDEOS.group.isVisible and (ALERT or e.target.button == 'but_okay') then
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

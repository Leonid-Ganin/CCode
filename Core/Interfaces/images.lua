local listeners = {}
local INPUT = require 'Core.Modules.interface-input'
local LIST = require 'Core.Modules.interface-list'
local MOVE = require 'Core.Modules.interface-move'

listeners.but_add = function(target)
    IMAGES.group[8]:setIsLocked(true, 'vertical')
    if IMAGES.group.isVisible then
        INPUT.new(STR['images.entername'], function(event)
            if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                INPUT.remove(true, event.target.text)
            end
        end, function(e)
            IMAGES.group[8]:setIsLocked(false, 'vertical')

            if e.input then
                local numImage = 1
                local path = DOC_DIR .. '/' .. CURRENT_LINK .. '/Images'

                local completeImportPicture = function(import)
                    if import.done and import.done == 'ok' then
                        local data = GET_GAME_CODE(CURRENT_LINK)
                        local path = path .. '/Image' .. numImage

                        table.insert(data.resources.images, 1, {e.text, 'linear', 'Image' .. numImage})
                        SET_GAME_CODE(CURRENT_LINK, data)
                        IMAGES.new(e.text, 1, '', 'Image' .. numImage)
                    end
                end

                while true do
                    local file = io.open(path .. '/Image' .. numImage, 'r')
                    if file then
                        numImage = numImage + 1
                        io.close(file)
                    else
                        FILE.pickFile(path, completeImportPicture, 'Image' .. numImage, '', 'image/*', nil, nil, nil)
                        break
                    end
                end
            end
        end)
    else
        IMAGES.group[8]:setIsLocked(false, 'vertical')
    end
end

listeners.but_play = function(target)
end

listeners.but_list = function(target)
    local list = #IMAGES.group.blocks == 0 and {STR['button.find']}
    or {STR['button.remove'], STR['button.rename'], STR['button.find']}

    IMAGES.group[8]:setIsLocked(true, 'vertical')
    if IMAGES.group.isVisible then
        LIST.new(list, MAX_X, target.y - target.height / 2, 'down', function(e)
            IMAGES.group[8]:setIsLocked(false, 'vertical')

            if e.index ~= 0 and e.text ~= STR['button.find'] then
                ALERT = false
                INDEX_LIST = e.index

                IMAGES.group[3].isVisible = true
                IMAGES.group[4].isVisible = false
                IMAGES.group[5].isVisible = false
                IMAGES.group[6].isVisible = false
                IMAGES.group[7].isVisible = true
            end

            if e.text == STR['button.remove'] then
                MORE_LIST = true
                IMAGES.group[3].text = '(' .. STR['button.remove'] .. ')'

                for i = 1, #IMAGES.group.blocks do
                    IMAGES.group.blocks[i].checkbox.isVisible = true
                end
            elseif e.text == STR['button.rename'] then
                MORE_LIST = false
                IMAGES.group[3].text = '(' .. STR['button.rename'] .. ')'

                for i = 1, #IMAGES.group.blocks do
                    IMAGES.group.blocks[i].checkbox.isVisible = true
                end
            elseif e.text == STR['button.find'] then
                IMAGES.group[8]:setIsLocked(true, 'vertical')
                INPUT.new(STR['images.entername'], function(event)
                    if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                        INPUT.remove(true, event.target.text)
                    end
                end, function(e)
                    IMAGES.group[8]:setIsLocked(false, 'vertical')

                    if e.input then
                        local data = GET_GAME_CODE(CURRENT_LINK)

                        for i = #IMAGES.group.data, 1, -1 do
                            IMAGES.group.blocks[i].remove(i)
                        end

                        timer.performWithDelay(10, function()
                            for index, image_config in pairs(data.resources.images) do
                                if UTF8.find(UTF8.lower(image_config[1]), UTF8.lower(e.text)) then
                                    IMAGES.new(image_config[1], #IMAGES.group.blocks + 1, image_config[2], image_config[3])
                                end
                            end
                        end)
                    end
                end)
            end
        end, nil, nil, 1)
    else
        IMAGES.group[8]:setIsLocked(false, 'vertical')
    end
end

listeners.but_okay = function(target)
    ALERT = true
    IMAGES.group[3].text = ''
    IMAGES.group[3].isVisible = false
    IMAGES.group[4].isVisible = true
    IMAGES.group[5].isVisible = true
    IMAGES.group[6].isVisible = true
    IMAGES.group[7].isVisible = false

    if INDEX_LIST == 1 then
        for i = #IMAGES.group.data, 1, -1 do
            IMAGES.group.blocks[i].checkbox.isVisible = false

            if IMAGES.group.blocks[i].checkbox.isOn then
                local data = GET_GAME_CODE(CURRENT_LINK)
                table.remove(data.resources.images, i)

                SET_GAME_CODE(CURRENT_LINK, data)
                OS_REMOVE(DOC_DIR .. '/' .. CURRENT_LINK .. '/Images/' .. IMAGES.group.blocks[i].link)
                IMAGES.group.blocks[i].remove(i)
            end
        end

        for j = 1, #IMAGES.group.blocks do
            local y = j == 1 and 75 or IMAGES.group.data[j - 1].y + 150
            IMAGES.group.blocks[j].y = y
            IMAGES.group.blocks[j].text.y = y
            IMAGES.group.blocks[j].checkbox.y = y
            IMAGES.group.blocks[j].container.y = y
            IMAGES.group.data[j].y = y
        end

        IMAGES.group[8]:setScrollHeight(150 * #IMAGES.group.data)
    elseif INDEX_LIST == 2 then
        for i = #IMAGES.group.blocks, 1, -1 do
            IMAGES.group.blocks[i].checkbox.isVisible = false

            if IMAGES.group.blocks[i].checkbox.isOn then
                IMAGES.group.blocks[i].checkbox:setState({isOn=false})
                INPUT.new(STR['images.changename'], function(event)
                    if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                        INPUT.remove(true, event.target.text)
                    end
                end, function(e)
                    if e.input then
                        local data = GET_GAME_CODE(CURRENT_LINK)
                        data.resources.images[i][1] = e.text

                        SET_GAME_CODE(CURRENT_LINK, data)
                        IMAGES.group.blocks[i].text.text = e.text
                    end
                end, IMAGES.group.blocks[i].text.text)
            end
        end
    end
end

return function(e)
    if IMAGES.group.isVisible and (ALERT or e.target.button == 'but_okay') then
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

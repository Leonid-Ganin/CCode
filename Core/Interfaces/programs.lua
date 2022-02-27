local listeners = {}
local LIST = require 'Core.Modules.interface-list'

listeners.but_add = function(target)
    PROGRAMS.group[8]:setIsLocked(true, 'vertical')
    INPUT.new(STR['programs.entername'], function(event)
        if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
            INPUT.remove(true, event.target.text)
        end
    end, function(e)
        PROGRAMS.group[8]:setIsLocked(false, 'vertical')

        if e.input then
            local numApp = 1
            while true do
                local file = io.open(DOC_DIR .. '/App' .. numApp .. '/game.json', 'r')
                if file then
                    numApp = numApp + 1
                    io.close(file)
                else
                    LOCAL.apps[#LOCAL.apps + 1] = 'App' .. numApp
                    LFS.mkdir(DOC_DIR .. '/App' .. numApp)
                    LFS.mkdir(DOC_DIR .. '/App' .. numApp .. '/Documents')
                    LFS.mkdir(DOC_DIR .. '/App' .. numApp .. '/Temps')
                    LFS.mkdir(DOC_DIR .. '/App' .. numApp .. '/Images')
                    LFS.mkdir(DOC_DIR .. '/App' .. numApp .. '/Sounds')
                    LFS.mkdir(DOC_DIR .. '/App' .. numApp .. '/Videos')
                    LFS.mkdir(DOC_DIR .. '/App' .. numApp .. '/Fonts')

                    NEW_DATA()
                    SET_GAME_SAVE('App' .. numApp, {})
                    SET_GAME_CODE('App' .. numApp, NEW_APP_CODE(e.text, 'App' .. numApp))
                    PROGRAMS.new(e.text, 'App' .. numApp)

                    break
                end
            end
        end
    end)
end

listeners.but_import = function(target)
end

listeners.but_list = function(target)
    if #PROGRAMS.group.blocks > 0 then
        PROGRAMS.group[8]:setIsLocked(true, 'vertical')
        LIST.new({STR['button.remove'], STR['button.rename']--[[, STR['button.copy']]}, MAX_X, target.y - target.height / 2, 'down', function(e)
            PROGRAMS.group[8]:setIsLocked(false, 'vertical')

            if e.index ~= 0 then
                ALERT = false
                INDEX_LIST = e.index

                PROGRAMS.group[3].isVisible = true
                PROGRAMS.group[4].isVisible = false
                PROGRAMS.group[5].isVisible = false
                PROGRAMS.group[6].isVisible = false
                PROGRAMS.group[7].isVisible = true
            end

            if e.index == 1 then
                MORE_LIST = true
                PROGRAMS.group[3].text = '(' .. STR['button.remove'] .. ')'

                for i = 1, #PROGRAMS.group.blocks do
                    PROGRAMS.group.blocks[i].checkbox.isVisible = true
                end
            elseif e.index == 2 then
                MORE_LIST = false
                PROGRAMS.group[3].text = '(' .. STR['button.rename'] .. ')'

                for i = 1, #PROGRAMS.group.blocks do
                    PROGRAMS.group.blocks[i].checkbox.isVisible = true
                end
            elseif e.index == 3 then
                -- MORE_LIST = false
                -- PROGRAMS.group[3].text = '(' .. STR['button.copy'] .. ')'
                --
                -- for i = 1, #PROGRAMS.group.blocks do
                --     PROGRAMS.group.blocks[i].checkbox.isVisible = true
                -- end
            end
        end, nil, nil, 1)
    end
end

listeners.but_okay = function(target)
    ALERT = true
    PROGRAMS.group[3].text = ''
    PROGRAMS.group[3].isVisible = false
    PROGRAMS.group[4].isVisible = true
    PROGRAMS.group[5].isVisible = true
    PROGRAMS.group[6].isVisible = true
    PROGRAMS.group[7].isVisible = false

    if INDEX_LIST == 1 then
        for i = #PROGRAMS.group.blocks, 1, -1 do
            PROGRAMS.group.blocks[i].checkbox.isVisible = false

            if PROGRAMS.group.blocks[i].checkbox.isOn then
                for j = 1, #LOCAL.apps do
                    if LOCAL.apps[j] == PROGRAMS.group.blocks[i].link then
                        table.remove(LOCAL.apps, j)
                    end
                end

                if PROGRAMS.group.blocks[i].text.text == LOCAL.last then
                    LOCAL.last = ''
                    MENU.group[9].text = STR['menu.continue']
                end

                NEW_DATA()
                OS_REMOVE(DOC_DIR .. '/' .. PROGRAMS.group.blocks[i].link, true)
                PROGRAMS.group.blocks[i].remove(i)
            end
        end

        for j = 1, #PROGRAMS.group.blocks do
            local y = j == 1 and 75 or PROGRAMS.group.data[j - 1].y + 150
            PROGRAMS.group.blocks[j].y = y
            PROGRAMS.group.blocks[j].text.y = y
            PROGRAMS.group.blocks[j].container.y = y
            PROGRAMS.group.blocks[j].checkbox.y = y
            PROGRAMS.group.data[j].y = y
        end
    elseif INDEX_LIST == 2 then
        for i = #PROGRAMS.group.blocks, 1, -1 do
            PROGRAMS.group.blocks[i].checkbox.isVisible = false

            if PROGRAMS.group.blocks[i].checkbox.isOn then
                PROGRAMS.group.blocks[i].checkbox:setState({isOn=false})
                INPUT.new(STR['programs.changename'], function(event)
                    if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                        INPUT.remove(true, event.target.text)
                    end
                end, function(e)
                    if e.input then
                        local data = GET_GAME_CODE(PROGRAMS.group.blocks[i].link)
                        data.title = e.text

                        if PROGRAMS.group.blocks[i].text.text == LOCAL.last then
                            LOCAL.last = e.text
                            MENU.group[9].text = e.text
                        end

                        NEW_DATA()
                        SET_GAME_CODE(PROGRAMS.group.blocks[i].link, data)
                        PROGRAMS.group.blocks[i].text.text = e.text
                    end
                end, PROGRAMS.group.blocks[i].text.text)
            end
        end
    elseif INDEX_LIST == 3 then
        -- for i = #PROGRAMS.group.blocks, 1, -1 do
        --     PROGRAMS.group.blocks[i].checkbox.isVisible = false
        --
        --     if PROGRAMS.group.blocks[i].checkbox.isOn then
        --         PROGRAMS.group.blocks[i].checkbox:setState({isOn=false})
        --         INPUT.new(STR['programs.entername'], function(event)
        --             if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
        --                 INPUT.remove(true, event.target.text)
        --             end
        --         end, function(e)
        --             if e.input then
        --                 local numApp = 1
        --                 while true do
        --                     local file = io.open(DOC_DIR .. '/App' .. numApp .. '/game.json', 'r')
        --                     if file then
        --                         numApp = numApp + 1
        --                         io.close(file)
        --                     else
        --                         local data = GET_GAME_CODE(PROGRAMS.group.blocks[i].link)
        --                         data.link = 'App' .. numApp
        --                         data.title = e.text
        --
        --                         LOCAL.apps[#LOCAL.apps + 1] = 'App' .. numApp
        --                         LFS.mkdir(DOC_DIR .. '/App' .. numApp)
        --                         OS_COPY(DOC_DIR .. '/' .. PROGRAMS.group.blocks[i].link, DOC_DIR .. '/App' .. numApp)
        --
        --                         NEW_DATA()
        --                         SET_GAME_CODE('App' .. numApp, data)
        --                         PROGRAMS.new(e.text, 'App' .. numApp)
        --
        --                         break
        --                     end
        --                 end
        --             end
        --         end, PROGRAMS.group.blocks[i].text.text)
        --     end
        -- end
    end
end

return function(e)
    if PROGRAMS.group.isVisible and (ALERT or e.target.button == 'but_okay') then
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

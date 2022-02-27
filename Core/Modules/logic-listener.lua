local LISTENER = require 'Core.Interfaces.blocks'
local LIST = require 'Core.Modules.logic-list'
local INFO = require 'Data.info'
local M = {}

function onCheckboxPress(e)
    local last_checkbox = e.target.getIndex(e.target)
    local name = BLOCKS.group.blocks[last_checkbox].data.name
    local notEnd = UTF8.sub(name, UTF8.len(name) - 2, UTF8.len(name)) ~= 'End'

    if notEnd then
        if LAST_CHECKBOX ~= 0 and BLOCKS.group.blocks[LAST_CHECKBOX].data.event and last_checkbox ~= LAST_CHECKBOX and not MORE_LIST then
            for i = LAST_CHECKBOX + 1, #BLOCKS.group.blocks do
                local name = BLOCKS.group.blocks[i].data.name
                local notEnd = UTF8.sub(name, UTF8.len(name) - 2, UTF8.len(name)) ~= 'End'

                if BLOCKS.group.blocks[i].data.event then break end
                BLOCKS.group.blocks[i].checkbox.isVisible = notEnd
                BLOCKS.group.blocks[i].checkbox:setState({isOn = false})
            end
        elseif LAST_CHECKBOX ~= 0 and BLOCKS.group.blocks[LAST_CHECKBOX].data.nested and last_checkbox ~= LAST_CHECKBOX and not MORE_LIST then
            local endIndex = #INFO.listNested[BLOCKS.group.blocks[LAST_CHECKBOX].data.name]
            local nestedEndIndex = 1

            if #BLOCKS.group.blocks[LAST_CHECKBOX].data.nested == 0 then
                for i = LAST_CHECKBOX + 1, #BLOCKS.group.blocks do
                    local name = BLOCKS.group.blocks[i].data.name
                    local notEnd = UTF8.sub(name, UTF8.len(name) - 2, UTF8.len(name)) ~= 'End'
                    local notNested = not (BLOCKS.group.blocks[i].data.nested and #BLOCKS.group.blocks[i].data.nested > 0)
                    BLOCKS.group.blocks[i].checkbox.isVisible = notEnd
                    BLOCKS.group.blocks[i].checkbox:setState({isOn = false})

                    if name == BLOCKS.group.blocks[LAST_CHECKBOX].data.name and notNested then
                        nestedEndIndex = nestedEndIndex + 1
                    elseif name == INFO.listNested[BLOCKS.group.blocks[LAST_CHECKBOX].data.name][endIndex] then
                        nestedEndIndex = nestedEndIndex - 1
                        if nestedEndIndex == 0 then break end
                    end
                end
            end
        end

        if LAST_CHECKBOX ~= 0 then
            e.target.checkbox:setState({isOn = not e.target.checkbox.isOn})
            if LAST_CHECKBOX ~= last_checkbox and not MORE_LIST then
                BLOCKS.group.blocks[LAST_CHECKBOX].checkbox:setState({isOn = false})
            end LAST_CHECKBOX = last_checkbox
        else
            e.target.checkbox:setState({isOn = true}) LAST_CHECKBOX = last_checkbox
        end

        if e.target.data.event and last_checkbox == LAST_CHECKBOX then
            for i = last_checkbox + 1, #BLOCKS.group.blocks do
                local name = BLOCKS.group.blocks[i].data.name
                local notEnd = UTF8.sub(name, UTF8.len(name) - 2, UTF8.len(name)) ~= 'End'
                if BLOCKS.group.blocks[i].data.event then break end

                BLOCKS.group.blocks[i].checkbox.isVisible = notEnd and not e.target.checkbox.isOn or false
                BLOCKS.group.blocks[i].checkbox:setState({isOn = e.target.checkbox.isOn})
            end
        elseif e.target.data.nested and last_checkbox == LAST_CHECKBOX then
            local endIndex = #INFO.listNested[e.target.data.name]
            local nestedEndIndex = 1

            if #e.target.data.nested == 0 then
                for i = last_checkbox + 1, #BLOCKS.group.blocks do
                    local name = BLOCKS.group.blocks[i].data.name
                    local notEnd = UTF8.sub(name, UTF8.len(name) - 2, UTF8.len(name)) ~= 'End'
                    local notNested = not (BLOCKS.group.blocks[i].data.nested and #BLOCKS.group.blocks[i].data.nested > 0)
                    BLOCKS.group.blocks[i].checkbox.isVisible = notEnd and not e.target.checkbox.isOn or false
                    BLOCKS.group.blocks[i].checkbox:setState({isOn = e.target.checkbox.isOn})

                    if name == e.target.data.name and notNested then
                        nestedEndIndex = nestedEndIndex + 1
                    elseif name == INFO.listNested[e.target.data.name][endIndex] then
                        nestedEndIndex = nestedEndIndex - 1
                        if nestedEndIndex == 0 then break end
                    end
                end
            end
        end
    end
end

function newMoveLogicBlock(e, group, scroll, isNewBlock, isCopy)
    if #group.blocks > 1 then
        if ALERT then
            if e.target.data.event then
                for i = 2, #group.blocks do
                    if group.blocks[i].data.event then
                        break
                    elseif i == #group.blocks then
                        e.target.move = false
                        return
                    end
                end
            end

            local scrollY, diffScrollY = select(2, scroll:getContentPosition()), isCopy and 0 or select(2, scroll:getContentPosition())
            M.isEnd = UTF8.sub(e.target.data.name, UTF8.len(e.target.data.name) - 2, UTF8.len(e.target.data.name)) == 'End'
            M.index = e.target.getIndex(e.target)
            M.nestedClose = {}
            M.countClose = 0

            if e.target.data.event then
                for i = 1, #group.blocks do
                    if group.blocks[i] and group.blocks[i].data.nested and #group.blocks[i].data.nested == 0 and not group.blocks[i].data.event then
                        INDEX_LIST = 4
                        M.countClose = M.countClose + 1
                        M.nestedClose[tostring(group.blocks[i])] = true
                        onCheckboxPress({target =  group.blocks[i]}) ALERT = true
                        LISTENER({target = {button = 'but_okay', click = true}, phase = 'ended'})
                    elseif not group.blocks[i] then
                        break
                    end
                end

                for i = 1, #group.blocks do
                    group.blocks[i].x = group.blocks[i].x + 20 * M.countClose
                end
            end

            if M.isEnd then
                local nestedName = UTF8.sub(e.target.data.name, 1, UTF8.len(e.target.data.name) - 3)
                local nestedEndIndex = 1

                for i = M.index - 1, 1, -1 do
                    local name = group.blocks[i].data.name
                    local notNested = not (group.blocks[i].data.nested and #group.blocks[i].data.nested > 0)

                    if name == nestedName and notNested then
                        nestedEndIndex = nestedEndIndex - 1
                        if nestedEndIndex == 0 then M.stopY, M.stopT, M.stopI = group.blocks[i].y, tostring(group.blocks[i]), i break end
                    elseif name == e.target.data.name then
                        nestedEndIndex = nestedEndIndex + 1
                    end
                end

                local nestedEndIndex = 1

                for i = M.index + 1, #group.blocks do
                    local name = group.blocks[i].data.name
                    local isEnd = UTF8.sub(name, UTF8.len(name) - 2, UTF8.len(name)) == 'End'
                    local notNested = not (group.blocks[i].data.nested and #group.blocks[i].data.nested > 0)

                    if INFO.listNested[name] and notNested then
                        nestedEndIndex = nestedEndIndex + 1
                    elseif isEnd then
                        nestedEndIndex = nestedEndIndex - 1
                        if nestedEndIndex == 0 then M.stopY2, M.stopT2, M.stopI2 = group.blocks[i].y, tostring(group.blocks[i]), i break end
                    end

                    if group.blocks[i].data.event then
                        M.stopY2, M.stopT2, M.stopI2 = group.blocks[i].y, tostring(group.blocks[i]), i
                        break
                    end
                end

                for i = M.stopI + 1, M.stopI2 and M.stopI2 - 1 or #group.blocks do
                    if group.blocks[i] and group.blocks[i].data.nested and #group.blocks[i].data.nested == 0 and not group.blocks[i].data.event then
                        if tostring(group.blocks[i]) ~= M.stopT then
                            INDEX_LIST = 4
                            M.countClose = M.countClose + 1
                            M.nestedClose[tostring(group.blocks[i])] = true
                            onCheckboxPress({target =  group.blocks[i]}) ALERT = true
                            LISTENER({target = {button = 'but_okay', click = true}, phase = 'ended'})
                        end
                    elseif not group.blocks[i] then
                        break
                    end
                end

                for i = 1, #group.blocks do
                    group.blocks[i].x = group.blocks[i].x + 20 * M.countClose
                    if tostring(group.blocks[i]) == M.stopT2 then M.stopY2 = group.blocks[i].y end
                end
            end

            ALERT = false
            scroll:setIsLocked(true, 'vertical')
            display.getCurrentStage():setFocus(e.target)
            M.index = e.target.getIndex(e.target)
            M.data = GET_GAME_CODE(CURRENT_LINK)
            M.nestedBlocks, M.nestedData = {}, {}
            M.diffY = scroll.y - scroll.height / 2
            e.target.y = e.y or e.target.y
            e.target.x = e.target.x + 40

            if e.target.data.event and group.blocks[M.index - 1] then
                local diffBlockY = group.blocks[M.index - 1].y - group.blocks[M.index - 1].height / 2
                diffScrollY = M.diffY - diffBlockY + scroll.height / 2
                scroll:scrollToPosition({y = diffScrollY > 0 and 0 or diffScrollY, time = 0})
            end

            e.target.y = (e.y or e.target.y) - (diffScrollY > 0 and 0 or diffScrollY) - M.diffY
            M.lastY = e.target.y
            e.target:toFront()

            if e.target.data.nested then
                local y = 0
                local count = 0
                local endIndex = 1
                local nestedEndIndex = 1

                if not e.target.data.event then
                    endIndex = #INFO.listNested[e.target.data.name]
                end

                if #e.target.data.nested == 0 or e.target.data.event then
                    if not e.target.data.event or not isNewBlock then
                        for i = M.index + 1, #group.blocks do
                            local name = group.blocks[M.index + 1].data.name
                            local notNested = not (group.blocks[M.index + 1].data.nested and #group.blocks[M.index + 1].data.nested > 0)

                            if e.target.data.event and group.blocks[M.index + 1].data.event then
                                break
                            end

                            y = y + group.blocks[M.index + 1].block.height - 4
                            table.insert(M.nestedData, M.data.scripts[CURRENT_SCRIPT].params[M.index + 1])
                            table.insert(M.nestedBlocks, group.blocks[M.index + 1])
                            table.remove(M.data.scripts[CURRENT_SCRIPT].params, M.index + 1)
                            table.remove(group.blocks, M.index + 1)

                            if not e.target.data.event then
                                if name == e.target.data.name and notNested then
                                    nestedEndIndex = nestedEndIndex + 1
                                elseif name == INFO.listNested[e.target.data.name][endIndex] then
                                    nestedEndIndex = nestedEndIndex - 1
                                    if nestedEndIndex == 0 then break end
                                end
                            end
                        end
                    end
                end

                for i = M.index + 1, #group.blocks do
                    group.blocks[i].y = group.blocks[i].y - y
                end

                for i = 1, #M.nestedBlocks do
                    M.nestedBlocks[i].isVisible = false
                end
            end
        else
            e.target.move = false
        end
    end
end

local function updMoveLogicBlock(e, group, scroll)
    if #group.blocks > 1 then
        local scrollY = select(2, scroll:getContentPosition())
        local addHeight = e.target.data.event and 24 or 0

        e.target.y = e.y - scrollY - M.diffY
        e.target:toFront()

        if e.y > group[4].y - 120 and scrollY + 100 > scroll.height - group.scrollHeight then
            scroll:scrollToPosition({y = scrollY - 15, time = 0})
        elseif e.y < group[3].y + 120 and scrollY < 0 then
            scroll:scrollToPosition({y = scrollY + 15, time = 0})
        end

        if not M.stopY or e.target.y > M.stopY then
            if not M.stopY2 or e.target.y < M.stopY2 then
                if e.target.y > M.lastY then
                    if group.blocks[M.index + 1] then
                        local countBlocksReplace = 0
                        local block = M.data.scripts[CURRENT_SCRIPT].params[M.index]

                        for i = M.index + 1, #group.blocks do
                            if group.blocks[i] and group.blocks[i].y < e.target.y then
                                group.blocks[i].y = group.blocks[i].y - (e.target.block.height - 4 + addHeight)
                                countBlocksReplace = countBlocksReplace + 1
                            else break end
                        end

                        M.index = M.index + countBlocksReplace
                        table.remove(M.data.scripts[CURRENT_SCRIPT].params, M.index - countBlocksReplace)
                        table.insert(group.blocks, M.index + 1, e.target)
                        table.remove(group.blocks, M.index - countBlocksReplace)
                        table.insert(M.data.scripts[CURRENT_SCRIPT].params, M.index, block)
                    end
                elseif e.target.y < M.lastY then
                    if group.blocks[M.index - 1] then
                        local countBlocksReplace = 0
                        local block = M.data.scripts[CURRENT_SCRIPT].params[M.index]

                        for i = M.index - 1, 1, -1 do
                            if group.blocks[i] and group.blocks[i].y > e.target.y and (i > 1 or e.target.data.event) then
                                group.blocks[i].y = group.blocks[i].y + (e.target.block.height - 4 + addHeight)
                                countBlocksReplace = countBlocksReplace + 1
                            else break end
                        end

                        M.index = M.index - countBlocksReplace
                        table.remove(M.data.scripts[CURRENT_SCRIPT].params, M.index + countBlocksReplace)
                        table.insert(group.blocks, M.index, e.target)
                        table.remove(group.blocks, M.index + countBlocksReplace + 1)
                        table.insert(M.data.scripts[CURRENT_SCRIPT].params, M.index, block)
                    end
                end
            end
        end

        M.lastY = e.target.y
    end
end

local function stopMoveLogicBlock(e, group, scroll)
    if #group.blocks > 1 then
        local y = M.index == 1 and 50 or group.blocks[M.index - 1].y + group.blocks[M.index - 1].block.height / 2 + e.target.block.height / 2 - 4
        e.target.x, e.target.y = e.target.x - 40, e.target.data.event and y + 24 or y
        M.stopY, M.stopY2, M.stopT, M.stopT2, M.stopI, M.stopI2 = nil, nil, nil, nil, nil, nil

        if e.target.data.nested and #M.nestedBlocks > 0 then
            local y, index = 0, M.index + #M.nestedBlocks

            for i = 1, #M.nestedBlocks do
                y = y + M.nestedBlocks[1].block.height - 4
                table.insert(M.data.scripts[CURRENT_SCRIPT].params, M.index + i, M.nestedData[1])
                table.insert(group.blocks, M.index + i, M.nestedBlocks[1])
                table.remove(M.nestedBlocks, 1)
                table.remove(M.nestedData, 1)

                local y = group.blocks[M.index + i - 1].y + group.blocks[M.index + i - 1].block.height / 2 + group.blocks[M.index + i].block.height / 2 - 4
                group.blocks[M.index + i].isVisible, group.blocks[M.index + i].y = true, y
            end

            for i = index + 1, #group.blocks do
                group.blocks[i].y = group.blocks[i].y + y
            end
        end

        SET_GAME_CODE(CURRENT_LINK, M.data)

        if M.countClose > 0 then
            for i = #group.blocks, 1, -1 do
                if M.nestedClose[tostring(group.blocks[i])] then
                    INDEX_LIST = 4
                    M.nestedClose[tostring(group.blocks[i])] = nil
                    onCheckboxPress({target =  group.blocks[i]}) ALERT = true
                    LISTENER({target = {button = 'but_okay', click = true}, phase = 'ended'})
                end
            end

            for i = 1, #group.blocks do
                group.blocks[i].x = i == 1 and group.blocks[1].x + 20 * M.countClose or group.blocks[1].x
            end
        end

        ALERT = true
        scroll:setIsLocked(false, 'vertical')

        if M.countClose > 0 then
            local diffBlockY = e.target.y - e.target.height / 2
            local diffScrollY = M.diffY - diffBlockY + scroll.height / 2
            scroll:scrollToPosition({y = diffScrollY > 0 and 0 or diffScrollY, time = 0})
        end
    end
end

return function(e)
    if BLOCKS.group.isVisible then
        if e.phase == 'began' then
            display.getCurrentStage():setFocus(e.target)
            e.target.click = true

            if ALERT and #BLOCKS.group.blocks > 1 then
                e.target.timer = timer.performWithDelay(300, function()
                    e.target.move = true
                    newMoveLogicBlock(e, BLOCKS.group, BLOCKS.group[8])
                end)
            end
        elseif e.phase == 'moved' then
            if math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 30 then
                if not e.target.move then
                    BLOCKS.group[8]:takeFocus(e)
                    e.target.click = false

                    if e.target.timer then
                        if not e.target.timer._removed then
                            timer.cancel(e.target.timer)
                        end
                    end
                end
            end

            if e.target.move then
                updMoveLogicBlock(e, BLOCKS.group, BLOCKS.group[8])
            end
        elseif e.phase == 'ended' or e.phase == 'cancelled' then
            display.getCurrentStage():setFocus(nil)
            if e.target.click then
                e.target.click = false

                if not ALERT then
                    if e.target.checkbox.isVisible then
                        onCheckboxPress(e)
                    elseif e.target.move then
                        e.target.move = false
                        stopMoveLogicBlock(e, BLOCKS.group, BLOCKS.group[8])
                    end
                else
                    LIST.new(e.target)
                end

                if e.target.timer then
                    if not e.target.timer._removed then
                        timer.cancel(e.target.timer)
                    end
                end
            end
        end return true
    end
end

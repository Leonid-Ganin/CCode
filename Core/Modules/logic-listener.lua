local function onCheckboxPress(e)
    local last_checkbox = e.target.getIndex(e.target)

    if LAST_CHECKBOX ~= 0 and BLOCKS.group.blocks[LAST_CHECKBOX].data.event and last_checkbox ~= LAST_CHECKBOX then
        if not MORE_LIST then
            for i = LAST_CHECKBOX + 1, #BLOCKS.group.blocks do
                if BLOCKS.group.blocks[i].data.event then break end
                BLOCKS.group.blocks[i].checkbox.isVisible = true
                BLOCKS.group.blocks[i].checkbox:setState({isOn = false})
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
            if BLOCKS.group.blocks[i].data.event then break end
            BLOCKS.group.blocks[i].checkbox.isVisible = not e.target.checkbox.isOn
            BLOCKS.group.blocks[i].checkbox:setState({isOn = e.target.checkbox.isOn})
        end
    end
end

local M = {}

function newMoveLogicBlock(e, group, scroll, isNewBlock)
    if #group.blocks > 1 then
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

        ALERT = false
        scroll:setIsLocked(true, 'vertical')
        M.index = e.target.getIndex(e.target)
        M.data = GET_GAME_CODE(CURRENT_LINK)
        M.nestedBlocks, M.nestedData = {}, {}
        M.diffY = scroll.y - scroll.height / 2
        e.target.x, M.lastY = e.target.x + 40, e.target.y

        if e.target.data.event and not isNewBlock then
            local y = 0

            for i = M.index + 1, #group.blocks do
                if group.blocks[M.index + 1].data.event then
                    break
                end

                y = y + group.blocks[M.index + 1].block.height - 4
                table.insert(M.nestedData, M.data.scripts[CURRENT_SCRIPT].params[M.index + 1])
                table.insert(M.nestedBlocks, group.blocks[M.index + 1])
                table.remove(M.data.scripts[CURRENT_SCRIPT].params, M.index + 1)
                table.remove(group.blocks, M.index + 1)
            end

            for i = M.index + 1, #group.blocks do
                group.blocks[i].y = group.blocks[i].y - y
            end

            for i = 1, #M.nestedBlocks do
                M.nestedBlocks[i].isVisible = false
            end
        end
    end
end

local function updMoveLogicBlock(e, group, scroll)
    if #group.blocks > 1 then
        local scrollY = select(2, scroll:getContentPosition())
        local addHeight = e.target.data.event and 24 or 0

        e.target.y = e.y - scrollY - M.diffY
        e.target:toFront()

        if e.y > group[4].y - 120 and (math.abs(scrollY) < 120 * (#group.blocks) - scroll.height + 50 or scrollY > 0) then
            scroll:scrollToPosition({y = scrollY - 15, time = 0})
        elseif e.y < group[3].y + 120 and scrollY < 0 then
            scroll:scrollToPosition({y = scrollY + 15, time = 0})
        end

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
            if group.blocks[M.index - 1] and (M.index ~= 2 or e.target.data.event) then
                local countBlocksReplace = 0
                local block = M.data.scripts[CURRENT_SCRIPT].params[M.index]

                for i = M.index - 1, 1, -1 do
                    if group.blocks[i] and group.blocks[i].y > e.target.y then
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

        M.lastY = e.target.y
    end
end

local function stopMoveLogicBlock(e, group, scroll)
    if #group.blocks > 1 then
        local y = M.index == 1 and 50 or group.blocks[M.index - 1].y + group.blocks[M.index - 1].block.height / 2 + e.target.block.height / 2 - 4
        e.target.x, e.target.y = e.target.x - 40, e.target.data.event and y + 24 or y

        if e.target.data.event and #M.nestedBlocks > 0 then
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

        ALERT = true
        scroll:setIsLocked(false, 'vertical')
        SET_GAME_CODE(CURRENT_LINK, M.data)
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

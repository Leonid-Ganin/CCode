local M = {}

M.new = function(buttons, x, y, direction, listener, first, second, anchorX)
    if not M.group then
        ALERT = false
        M.listener = listener
        M.group = display.newGroup()

        if first then
            for i = 1, #buttons do
                if buttons[i] == first then
                    table.remove(buttons, i)
                    table.insert(buttons, 1, first)
                    break
                end
            end
        end

        if second then
            for i = 1, #buttons do
                if buttons[i] == second then
                    table.remove(buttons, i)
                    table.insert(buttons, 2, second)
                    break
                end
            end
        end

        M.listBg = display.newRect(CENTER_X, CENTER_Y, 5000, 5000)
            M.listBg:setFillColor(1, 0.005)
        M.group:insert(M.listBg)

        M.listBg:addEventListener('touch', function(e)
            if e.phase == 'began' then
                display.getCurrentStage():setFocus(e.target)
                e.target.click = true
            elseif e.phase == 'ended' or e.phase == 'cancelled' then
                display.getCurrentStage():setFocus(nil)
                if e.target.click then M.remove(0) end
            end return true
        end)

        local width = 0
        for i = 1, #buttons do
            local text = display.newText({
                    text = buttons[i], x = 5000, y = y,
                    font = 'ubuntu', fontSize = 40,
                    height = 50, align = 'left'
                })
            if text.width > width then width = text.width end
            if width + 20 > DISPLAY_WIDTH then width = DISPLAY_WIDTH end
            text:removeSelf()
        end

        M.bg = display.newRoundedRect(x, y, width + 40, 80 * #buttons + 30, 20)
            M.bg:setFillColor(0.2, 0.2, 0.22)
            M.bg.anchorY = direction == 'up' and 1 or 0
            M.bg.anchorX = anchorX or 0.5
        M.group:insert(M.bg)

        M.scroll = WIDGET.newScrollView({
                x = x, y = y,
                width = width + 40, height = 80 * #buttons + 30,
                hideBackground = true, hideScrollBar = true,
                horizontalScrollDisabled = true, isBounceEnabled = true
            })
            M.scroll.anchorY = direction == 'up' and 1 or 0
            M.scroll.anchorX = anchorX or 0.5
        M.group:insert(M.scroll)

        local y = 55
        local x = (width + 40) / 2
        for i = 1, #buttons do
            local but = display.newRect(x, y, width + 40, 80)
                but:setFillColor(0.2, 0.2, 0.22, 0.05)
                but.num = i
            M.scroll:insert(but)

            local text = display.newText({
                    text = buttons[i], x = x, y = y,
                    font = 'ubuntu', fontSize = 40,
                    height = 50, width = width, align = 'left'
                })
            M.scroll:insert(text)

            but:addEventListener('touch', function(e)
                if e.phase == 'began' then
                    display.getCurrentStage():setFocus(e.target)
                    e.target.click = true
                    e.target:setFillColor(0.22, 0.22, 0.24)
                elseif e.phase == 'moved' then
                    local dy = math.abs(e.y - e.yStart)
                    if dy > 20 then
                        M.scroll:takeFocus(e)
                        e.target.click = false
                        e.target:setFillColor(0.2, 0.2, 0.22, 0.05)
                    end
                elseif e.phase == 'ended' or e.phase == 'cancelled' then
                    display.getCurrentStage():setFocus(nil)
                    e.target:setFillColor(0.2, 0.2, 0.22, 0.05)
                    if e.target.click then M.remove(e.target.num, buttons[e.target.num]) end
                end return true
            end) y = y + 80
        end

        EXITS.add(M.remove, 0)
    end
end

M.remove = function(index, text)
    if M and M.group then
        ALERT = true
        M.listener({index = index, text = text})
        M.group:removeSelf()
        M.group = nil
    end
end

return M

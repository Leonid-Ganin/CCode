local M = {}

M.new = function(title, textListener, inputListener, oldText)
    if not M.group then
        ALERT = false
        M.listener = inputListener
        M.timer = timer.performWithDelay(0, function() M.group:toFront() end, 0)
        M.group = display.newGroup()

        M.bg = display.newRoundedRect(CENTER_X, CENTER_Y - 100, DISPLAY_WIDTH - 100, 100, 20)
            M.bg:setFillColor(0.2, 0.2, 0.22)
        M.group:insert(M.bg)

        M.box = native.newTextField(5000, CENTER_Y - 110, DISPLAY_WIDTH - 150, system.getInfo 'environment' ~= 'simulator' and 36 or 72)
            timer.performWithDelay(0, function()
                if not ALERT then
                    M.box.x = CENTER_X
                    M.box.isEditable = true
                    M.box.hasBackground = false
                    M.box.placeholder = title
                    M.box.font = native.newFont('ubuntu.ttf', 36)
                    M.box.text = type(oldText) == 'string' and oldText or ''

                    if system.getInfo 'platform' == 'android' and system.getInfo 'environment' ~= 'simulator' then
                        M.box:setTextColor(0.9)
                    else
                        M.box:setTextColor(0.1)
                    end
                end
            end) M.box:addEventListener('userInput', textListener)
        M.group:insert(M.box)

        M.line = display.newRect(M.group, CENTER_X, CENTER_Y - 75, DISPLAY_WIDTH - 150, 2)
        M.group:insert(M.line)
    end
end

M.remove = function(input, text)
    if M.group then
        ALERT = true
        native.setKeyboardFocus(nil)
        M.listener({input = input, text = text})
        timer.cancel(M.timer)
        M.group:removeSelf()
        M.group = nil
    end
end

Runtime:addEventListener('key', function(event)
    if (event.keyName == 'back' or event.keyName == 'escape') and event.phase == 'up' then
        if not ALERT and M and M.group then
            M.remove(false)
        end
    end
end)

return M

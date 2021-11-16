local M = {}

local listener = function(e, scroll, group, type)
    if e.phase == 'began' then
        display.getCurrentStage():setFocus(e.target)
        e.target.click = true
        e.target.alpha = 0.6
    elseif e.phase == 'moved' and (math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 30) then
        scroll:takeFocus(e)
        e.target.click = false
        e.target.alpha = 0.9
    elseif e.phase == 'ended' or e.phase == 'cancelled' then
        display.getCurrentStage():setFocus(nil)
        if e.target.click then
            e.target.click = false
            e.target.alpha = 0.9

            if type == 'programs' then
                group.isVisible = false
                PROGRAM = PROGRAM or require 'Interfaces.program'
                if not PROGRAM.group then PROGRAM.create(e.target.text) end
                PROGRAM.group.isVisible = true
            elseif type == 'program' then
                -- todo
            end
        end
    end
end

M.new = function(app, scroll, group, type)
    local y = #group.data == 0 and 75 or group.data[#group.data].y + 150

    local block = display.newRoundedRect(CENTER_X, y, DISPLAY_WIDTH - 100, 125, 20)
        block.text = app
        block.alpha = 0.9
        block.index = #group.data + 1
        block:setFillColor(25/255, 26/255, 32/255)
    scroll:insert(block)

    local text = display.newText({
            text = app, x = CENTER_X + 114, y = y,
            font = 'ubuntu', fontSize = 40,
            width = block.width - 60, height = 50,
            align = 'left'
        })
    scroll:insert(text)

    local icon = SVG.newImage({
            filename = 'Sprites/icon.svg',
            x = CENTER_X - block.width / 2 + 14, y = y,
            width = 100, height = 100
        })
        icon.anchorX = 0
    scroll:insert(icon)

    block:addEventListener('touch', function(e)
        if group.isVisible then
            listener(e, scroll, group, type)
            return true
        end
    end)

    group.data[#group.data + 1] = {x = block.x, y = block.y, text = app}
end

return M

local BLOCK = require 'Core.Modules.logic-block'
local M = {}

local genBlocks = function(data)
    for i = 1, #data.scripts[CURRENT_SCRIPT].params do
        local params = data.scripts[CURRENT_SCRIPT].params[i]
        M.new(params.name, M.scroll, M.group, i, params.event, params.params)
    end
end

M.new = function(name, scroll, group, index, event, params)
    BLOCK.new(name, scroll, group, index, event, params)
end

M.create = function()
    M.group = display.newGroup()
    M.group.isVisible = false
    M.group.blocks = {}

    local bg = display.newImage('Sprites/bg.png', CENTER_X, CENTER_Y)
        bg.width = DISPLAY_WIDTH
        bg.height = DISPLAY_HEIGHT
    M.group:insert(bg)

    local data = GET_GAME_CODE(CURRENT_LINK)
    local title = display.newText(data.scripts[CURRENT_SCRIPT].title, ZERO_X + 40, ZERO_Y + 30, 'ubuntu', 50)
        title.anchorX = 0
        title.anchorY = 0
    M.group:insert(title)

    local title_list = display.newText('', CENTER_X, ZERO_Y + 62, 'ubuntu', 26)
        title_list.x = (title.x + title.width + MAX_X) / 2
        title_list.isVisible = false
    M.group:insert(title_list)

    local but_add = display.newImage('Sprites/add.png', ZERO_X + 190, MAX_Y - 95)
        but_add.alpha = 0.9
        but_add.button = 'but_add'
        but_add:addEventListener('touch', require 'Core.Interfaces.blocks')
    M.group:insert(but_add)

    local but_play = display.newImage('Sprites/play.png', MAX_X - 190, MAX_Y - 95)
        but_play.alpha = 0.9
        but_play.button = 'but_play'
        but_play:addEventListener('touch', require 'Core.Interfaces.blocks')
    M.group:insert(but_play)

    local but_list = display.newImage('Sprites/listopenbut.png', MAX_X - 80, ZERO_Y + 62)
        but_list.width, but_list.height = 103, 84
        but_list.button = 'but_list'
        but_list:addEventListener('touch', require 'Core.Interfaces.blocks')
    M.group:insert(but_list)

    local but_okay = display.newImage('Sprites/okay.png', MAX_X - 190, MAX_Y - 95)
        but_okay.alpha = 0.9
        but_okay.isVisible = false
        but_okay.button = 'but_okay'
        but_okay:addEventListener('touch', require 'Core.Interfaces.blocks')
    M.group:insert(but_okay)

    M.scroll = WIDGET.newScrollView({
            x = CENTER_X, y = (but_add.y - but_add.height / 2 - 30 + but_list.y + 72) / 2,
            width = DISPLAY_WIDTH, height = but_add.y - but_add.height / 2 - but_list.y - 102,
            hideBackground = true, hideScrollBar = true,
            horizontalScrollDisabled = true, isBounceEnabled = true
        })
    M.group:insert(M.scroll)

    genBlocks(data)
end

return M

local BLOCK = require 'Core.Modules.interface-block'
local M = {}

local genBlocks = function(scroll)
    for i = 1, #LOCAL.apps do
        BLOCK.new(GET_GAME_CODE(LOCAL.apps[i]).title, scroll, M.group, 'programs')
    end
end

M.create = function()
    M.group = display.newGroup()
    M.group.isVisible = false
    M.group.data = {}

    local bg = display.newImage('Sprites/bg.png', CENTER_X, CENTER_Y)
        bg.width = DISPLAY_WIDTH
        bg.height = DISPLAY_HEIGHT
    M.group:insert(bg)

    local title = display.newText(STR['programs.title'], ZERO_X + 40, ZERO_Y + 30, 'ubuntu', 50)
        title.anchorX = 0
        title.anchorY = 0
    M.group:insert(title)

    local but_add = display.newImage('Sprites/add.png', ZERO_X + 190, MAX_Y - 95)
        but_add.alpha = 0.9
        but_add.button = 'but_add'
        but_add:addEventListener('touch', require 'Core.Interfaces.programs')
    M.group:insert(but_add)

    local but_import = display.newImage('Sprites/import.png', MAX_X - 190, MAX_Y - 95)
        but_import.alpha = 0.9
        but_import.button = 'but_import'
        but_import:addEventListener('touch', require 'Core.Interfaces.programs')
    M.group:insert(but_import)

    local but_list = display.newImage('Sprites/listopenbut.png', MAX_X - 80, ZERO_Y + 62)
        but_list.width, but_list.height = 103, 84
        but_list.button = 'but_list'
        but_list:addEventListener('touch', require 'Core.Interfaces.programs')
    M.group:insert(but_list)

    local but_okay = display.newImage('Sprites/okay.png', MAX_X - 190, MAX_Y - 95)
        but_okay.alpha = 0.9
        but_okay.isVisible = false
        but_okay.button = 'but_okay'
        but_okay:addEventListener('touch', require 'Core.Interfaces.programs')
    M.group:insert(but_okay)

    local scroll = WIDGET.newScrollView({
            x = CENTER_X, y = (but_add.y - but_add.height / 2 - 30 + but_list.y + 72) / 2,
            width = DISPLAY_WIDTH, height = but_add.y - but_add.height / 2 - but_list.y - 102,
            hideBackground = true, hideScrollBar = true,
            horizontalScrollDisabled = true, isBounceEnabled = true
        })
    M.group:insert(scroll)

    genBlocks(scroll)
end

return M

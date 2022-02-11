local BLOCK = require 'Core.Modules.logic-block'
local M = {}

local genBlocks = function(data)
    for i = 1, #data.scripts[CURRENT_SCRIPT].params do
        local params = data.scripts[CURRENT_SCRIPT].params[i]
        M.new(params.name, i, params.event, params.params, params.comment, params.nested, params.vars, params.tables)
    end
end

M.new = function(name, index, event, params, comment, nested, vars, tables)
    BLOCK.new(name, M.scroll, M.group, index, event, params, comment, nested, vars, tables)
end

M.create = function()
    M.group = display.newGroup()
    M.group.isVisible = false
    M.group.blocks = {}
    M.group.scrollHeight = 10

    local bg = display.newImage('Sprites/bg.png', CENTER_X, CENTER_Y)
        bg.width = CENTER_X == 640 and DISPLAY_HEIGHT or DISPLAY_WIDTH
        bg.height = CENTER_X == 640 and DISPLAY_WIDTH or DISPLAY_HEIGHT
        bg.rotation = CENTER_X == 640 and 90 or 0
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

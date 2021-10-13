local M = {}

M.create = function()
    M.group = display.newGroup()
    M.group.isVisible = false

    local bg = display.newImage('Sprites/menu.png', CENTER_X, CENTER_Y)
        bg.width = DISPLAY_WIDTH
        bg.height = DISPLAY_HEIGHT
    M.group:insert(bg)

    local title = display.newText('CCode', CENTER_X, ZERO_Y + 182, 'ubuntu', 70)
    M.group:insert(title)

    local testers = display.newText('', CENTER_X, title.y + 75, 'ubuntu', 30)
        testers.text = TESTERS[system.getInfo('deviceID')] or ''
    M.group:insert(testers)

    local but_social = SVG.newImage({
            filename = 'Sprites/social.svg',
            x = ZERO_X + 47, y = MAX_Y - 60,
            width = 95 / 1.2, height = 126 / 1.2
        })
        but_social.button = 'but_social'
        but_social:addEventListener('touch', require 'Core.Interfaces.menu')
    M.group:insert(but_social)

    local but_myprogram = display.newImage('Sprites/menubut.png', CENTER_X, CENTER_Y, 396, 138)
        but_myprogram.alpha = 0.9
        but_myprogram.button = 'but_myprogram'
        but_myprogram:addEventListener('touch', require 'Core.Interfaces.menu')
    M.group:insert(but_myprogram)

    local text_myprogram = display.newText({
            text = STR['menu.myprogram'],
            x = CENTER_X, y = but_myprogram.y,
            font = 'ubuntu', fontSize = 42,
            width = but_myprogram.width - 10, height = but_myprogram.height / 2.7,
            align = 'center'
        })
    M.group:insert(text_myprogram)

    local delimiter1 = display.newRect(CENTER_X, CENTER_Y - 100, 300, 5)
        delimiter1:setFillColor(0.3)
    M.group:insert(delimiter1)

    local but_continue = display.newImage('Sprites/menubut.png', CENTER_X, CENTER_Y - 200, 396, 138)
        but_continue.alpha = 0.9
        but_continue.button = 'but_continue'
        but_continue:addEventListener('touch', require 'Core.Interfaces.menu')
    M.group:insert(but_continue)

    local text_continue = display.newText({
            text = STR['menu.continue'],
            x = CENTER_X, y = but_continue.y,
            font = 'ubuntu', fontSize = 42,
            width = but_myprogram.width - 10, height = but_myprogram.height / 2.7,
            align = 'center'
        })
    M.group:insert(text_continue)

    local delimiter2 = display.newRect(CENTER_X, CENTER_Y + 100, 300, 5)
        delimiter2:setFillColor(0.3)
    M.group:insert(delimiter2)

    local but_settings = display.newImage('Sprites/menubut.png', CENTER_X, CENTER_Y + 200, 396, 138)
        but_settings.alpha = 0.9
        but_settings.button = 'but_settings'
        but_settings:addEventListener('touch', require 'Core.Interfaces.menu')
    M.group:insert(but_settings)

    local text_continue = display.newText({
            text = STR['menu.settings'],
            x = CENTER_X, y = but_settings.y,
            font = 'ubuntu', fontSize = 42,
            width = but_myprogram.width - 10, height = but_myprogram.height / 2.7,
            align = 'center'
        })
    M.group:insert(text_continue)

    local build = display.newText('Build: ' .. BUILD, MAX_X - 100, MAX_Y - 40, 'sans', 27)
    M.group:insert(build)
end

return M

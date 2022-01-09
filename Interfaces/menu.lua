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
        if TESTERS[system.getInfo('deviceID')] and (TESTERS[system.getInfo('deviceID')] == 'Ganin' or TESTERS[system.getInfo('deviceID')] == 'Danіl Nik') then
            testers.text = STR['menu.developers'] .. '  ' .. TESTERS[system.getInfo('deviceID')]
        elseif TESTERS[system.getInfo('deviceID')] then
            testers.text = STR['menu.testers'] .. '  ' .. TESTERS[system.getInfo('deviceID')]
        end
    M.group:insert(testers)

    local but_social = SVG.newImage({
            filename = 'Sprites/social.svg',
            x = ZERO_X + 47, y = MAX_Y - 60,
            width = 95 / 1.2, height = 126 / 1.2
        })
        but_social.button = 'but_social'
        but_social:addEventListener('touch', require 'Core.Interfaces.menu')
    M.group:insert(but_social)

    local but_myprogram = display.newImage('Sprites/menubut.png', CENTER_X, title.y + 550, 396, 138)
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

    local delimiter1 = display.newRect(CENTER_X, title.y + 450, 300, 5)
        delimiter1:setFillColor(0.3)
    M.group:insert(delimiter1)

    local but_continue = display.newImage('Sprites/menubut.png', CENTER_X, title.y + 350, 396, 138)
        but_continue.alpha = 0.9
        but_continue.button = 'but_continue'
        but_continue:addEventListener('touch', require 'Core.Interfaces.menu')
    M.group:insert(but_continue)

    local text_continue = display.newText({
            text = (LOCAL.last and LOCAL.last ~= '') and LOCAL.last or STR['menu.continue'],
            x = CENTER_X, y = but_continue.y,
            font = 'ubuntu', fontSize = 42,
            width = but_myprogram.width - 10, height = but_myprogram.height / 2.7,
            align = 'center'
        })
    M.group:insert(text_continue)

    local delimiter2 = display.newRect(CENTER_X, title.y + 650, 300, 5)
        delimiter2:setFillColor(0.3)
    M.group:insert(delimiter2)

    local but_settings = display.newImage('Sprites/menubut.png', CENTER_X, title.y + 750, 396, 138)
        but_settings.alpha = 0.9
        but_settings.button = 'but_settings'
        but_settings:addEventListener('touch', require 'Core.Interfaces.menu')
    M.group:insert(but_settings)

    local text_settings = display.newText({
            text = STR['menu.settings'],
            x = CENTER_X, y = but_settings.y,
            font = 'ubuntu', fontSize = 42,
            width = but_myprogram.width - 10, height = but_myprogram.height / 2.7,
            align = 'center'
        })
    M.group:insert(text_settings)

    local build = display.newText('Build: ' .. BUILD, MAX_X - 100, MAX_Y - 40, 'sans', 27)
    M.group:insert(build)

    local snowflakes = display.newImage('Sprites/snowflakes.png', CENTER_X, CENTER_Y)
        snowflakes.alpha = 0.6
        snowflakes.width = DISPLAY_HEIGHT > DISPLAY_WIDTH and DISPLAY_HEIGHT or DISPLAY_WIDTH
        snowflakes.height = DISPLAY_HEIGHT > DISPLAY_WIDTH and DISPLAY_HEIGHT or DISPLAY_WIDTH
    M.group:insert(snowflakes)

    local hat = display.newImage('Sprites/hat.png', title.x - title.width / 2 + 20, title.y - title.height + 30)
        hat.alpha = 0.9
        hat.height = hat.height / 5
        hat.width = hat.width / 5
    M.group:insert(hat)

    snowflakes:toBack()
    bg:toBack()

    if CENTER_X == 640 then
        title.y = ZERO_Y + 82 + 220
        title.x = CENTER_X - 350
        but_social.y = ZERO_Y + 45
        but_social.x = ZERO_X + 10
        build.x, build.y = MAX_X - 100, MAX_Y - 40
        testers.y, testers.x = title.y + 75, title.x
        hat.x = title.x - title.width / 2 + 20
        hat.y = title.y - title.height + 30
        but_continue.y = title.y + 50 - 200
        but_continue.x = CENTER_X + but_continue.width - 100
        text_continue.y = but_continue.y
        text_continue.x = but_continue.x
        delimiter1.y = title.y + 150 - 200
        delimiter1.x = but_continue.x
        but_myprogram.y = title.y + 250 - 200
        but_myprogram.x = CENTER_X + but_myprogram.width - 100
        text_myprogram.y = but_myprogram.y
        text_myprogram.x = but_myprogram.x
        delimiter2.y = title.y + 350 - 200
        delimiter2.x = but_myprogram.x
        but_settings.y = title.y + 450 - 200
        but_settings.x = CENTER_X + but_settings.width - 100
        text_settings.y = but_settings.y
        text_settings.x = but_settings.x
    end
end

return M

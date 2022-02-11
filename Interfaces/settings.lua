local LISTENER = require 'Core.Interfaces.settings'
local M = {}

M.create = function()
    M.group = display.newGroup()
    M.group.isVisible = false

    local bg = display.newImage('Sprites/bg.png', CENTER_X, CENTER_Y)
        bg.width = CENTER_X == 640 and DISPLAY_HEIGHT or DISPLAY_WIDTH
        bg.height = CENTER_X == 640 and DISPLAY_WIDTH or DISPLAY_HEIGHT
        bg.rotation = CENTER_X == 640 and 90 or 0
    M.group:insert(bg)

    local title = display.newText(STR['menu.settings'], ZERO_X + 40, ZERO_Y + 30, 'ubuntu', 50)
        title.anchorX = 0
        title.anchorY = 0
    M.group:insert(title)

    local lang_text = display.newText(STR['settings.applang'], 20, title.y + 120, 'ubuntu', 30)
        lang_text.anchorX = 0
    M.group:insert(lang_text)

    local lang_button = display.newRect((lang_text.width + MAX_X) / 2 + 10, lang_text.y, MAX_X - lang_text.width - 100, 60)
        lang_button:setFillColor(0, 0, 0, 0.005)
        lang_button.text = display.newText(STR['lang.' .. LOCAL.lang], lang_button.x, lang_button.y, 'ubuntu', 30)
    M.group:insert(lang_button)
    M.group:insert(lang_button.text)

    local confirm_text = display.newText(STR['settings.confirmdelete'], 20, lang_text.y + 70, 'ubuntu', 30)
        confirm_text.anchorX = 0
    M.group:insert(confirm_text)

    local confirm_button = display.newRect((confirm_text.width + MAX_X) / 2 + 10, confirm_text.y, MAX_X - confirm_text.width - 100, 60)
        confirm_button:setFillColor(0, 0, 0, 0.005)
        confirm_button.text = display.newText(LOCAL.confirm and STR['button.yes'] or STR['button.no'], confirm_button.x, confirm_button.y, 'ubuntu', 30)
    M.group:insert(confirm_button)
    M.group:insert(confirm_button.text)

    lang_button:addEventListener('touch', function(e) LISTENER(e, 'lang') end)
    confirm_button:addEventListener('touch', function(e) LISTENER(e, 'confirm') end)
end

return M

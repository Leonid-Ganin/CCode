local M = {}

M.create = function()
    M.group = display.newGroup()
    M.group.isVisible = false

    local bg = display.newImage('Sprites/bg.png', CENTER_X, CENTER_Y)
        bg.width = DISPLAY_WIDTH
        bg.height = DISPLAY_HEIGHT
    M.group:insert(bg)

    local title = display.newText(STR['menu.settings'], ZERO_X + 40, ZERO_Y + 30, 'ubuntu', 50)
        title.anchorX = 0
        title.anchorY = 0
    M.group:insert(title)

    local lang_button = display.newImage('Sprites/amogus.png', CENTER_X, CENTER_Y)
        lang_button.width, lang_button.height = lang_button.width * 2, lang_button.height * 2
    M.group:insert(lang_button)

    local lang_text = display.newText(LOCAL.lang, CENTER_X, CENTER_Y - lang_button.height, 'ubuntu', 50)
    M.group:insert(lang_text)

    lang_button:addEventListener('touch', function(e)
        if e.phase == 'ended' then
            display.getCurrentStage():setFocus(nil)

            LOCAL.lang = LOCAL.lang == 'en' and 'ru' or 'en'
            lang_text.text = LOCAL.lang
            STR = LANG[LOCAL.lang]

            title.text = STR['menu.settings']
            MENU.group[6].text = STR['menu.myprogram']
            MENU.group[12].text = STR['menu.settings']
            MENU.group[9].text = (LOCAL.last and LOCAL.last ~= '') and LOCAL.last or STR['menu.continue']

            NEW_DATA()
        end
    end)
end

return M

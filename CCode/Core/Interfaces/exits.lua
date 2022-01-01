local listeners = {}

listeners.programs = function()
    PROGRAMS.group:removeSelf()
    MENU.group.isVisible = true
end

listeners.program = function()
    PROGRAM.group:removeSelf()
    PROGRAMS.group.isVisible = true
end

listeners.scripts = function()
    SCRIPTS.group:removeSelf()
    PROGRAM.group.isVisible = true
end

listeners.images = function()
    IMAGES.group:removeSelf()
    PROGRAM.group.isVisible = true
end

listeners.sounds = function()
    SOUNDS.group:removeSelf()
    PROGRAM.group.isVisible = true
end

listeners.videos = function()
    VIDEOS.group:removeSelf()
    PROGRAM.group.isVisible = true
end

listeners.fonts = function()
    FONTS.group:removeSelf()
    PROGRAM.group.isVisible = true
end

listeners.settings = function()
    SETTINGS.group:removeSelf()
    MENU.group.isVisible = true
end

listeners.blocks = function()
    BLOCKS.group:removeSelf()
    SCRIPTS = require 'Interfaces.scripts'
    SCRIPTS.create()
    SCRIPTS.group.isVisible = true
end

Runtime:addEventListener('key', function(event)
    if (event.keyName == 'back' or event.keyName == 'escape') and event.phase == 'up' and ALERT then
        if PROGRAMS and PROGRAMS.group and PROGRAMS.group.isVisible then
            listeners.programs()
        elseif PROGRAM and PROGRAM.group and PROGRAM.group.isVisible then
            listeners.program()
        elseif SCRIPTS and SCRIPTS.group and SCRIPTS.group.isVisible then
            listeners.scripts()
        elseif IMAGES and IMAGES.group and IMAGES.group.isVisible then
            listeners.images()
        elseif SOUNDS and SOUNDS.group and SOUNDS.group.isVisible then
            listeners.sounds()
        elseif VIDEOS and VIDEOS.group and VIDEOS.group.isVisible then
            listeners.videos()
        elseif FONTS and FONTS.group and FONTS.group.isVisible then
            listeners.fonts()
        elseif SETTINGS and SETTINGS.group and SETTINGS.group.isVisible then
            listeners.settings()
        elseif BLOCKS and BLOCKS.group and BLOCKS.group.isVisible then
            listeners.blocks()
        end
    end

    if (event.keyName == 'back' or event.keyName == 'escape') and event.phase == 'up' then
        return true
    end
end)

return true

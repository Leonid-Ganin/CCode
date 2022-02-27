local listeners = {}

listeners.programs = function()
    PROGRAMS.group:removeSelf()
    PROGRAMS.group = nil
    MENU.group.isVisible = true
end

listeners.program = function()
    PROGRAM.group:removeSelf()
    PROGRAM.group = nil
    PROGRAMS.group.isVisible = true
end

listeners.scripts = function()
    SCRIPTS.group:removeSelf()
    SCRIPTS.group = nil
    PROGRAM.group.isVisible = true
end

listeners.images = function()
    IMAGES.group:removeSelf()
    IMAGES.group = nil
    PROGRAM.group.isVisible = true
end

listeners.sounds = function()
    SOUNDS.group:removeSelf()
    SOUNDS.group = nil
    PROGRAM.group.isVisible = true
end

listeners.videos = function()
    VIDEOS.group:removeSelf()
    VIDEOS.group = nil
    PROGRAM.group.isVisible = true
end

listeners.fonts = function()
    FONTS.group:removeSelf()
    FONTS.group = nil
    PROGRAM.group.isVisible = true
end

listeners.settings = function()
    SETTINGS.group:removeSelf()
    SETTINGS.group = nil
    MENU.group.isVisible = true
end

listeners.blocks = function()
    BLOCKS.group:removeSelf()
    BLOCKS.group = nil
    SCRIPTS.group.isVisible = true
end

listeners.new_block = function()
    NEW_BLOCK.group:removeSelf()
    NEW_BLOCK.group = nil
    BLOCKS.group.isVisible = true
    if LOCAL.show_ads then ADMOB.show('banner', {bgColor = '#0f0f11', y = LOCAL.pos_top_ads and 'top' or 'bottom'}) end
end

listeners.editor = function()
    EDITOR.group:removeSelf()
    EDITOR.group = nil
    BLOCKS.group.isVisible = true
    if LOCAL.show_ads then ADMOB.show('banner', {bgColor = '#0f0f11', y = LOCAL.pos_top_ads and 'top' or 'bottom'}) end
end

listeners.game = function()
    GAME.remove()
    BLOCKS.group.isVisible = true
    if LOCAL.show_ads then ADMOB.show('banner', {bgColor = '#0f0f11', y = LOCAL.pos_top_ads and 'top' or 'bottom'}) end
end

listeners.add = function(listener, arg)
    listeners.listener = function() listener(arg) end
end

listeners.lis = function(event)
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
        elseif NEW_BLOCK and NEW_BLOCK.group and NEW_BLOCK.group.isVisible then
            listeners.new_block()
        elseif EDITOR and EDITOR.group and EDITOR.group.isVisible then
            listeners.editor()
        elseif GAME and GAME.group and GAME.group.isVisible then
            listeners.game()
        end
    elseif (event.keyName == 'back' or event.keyName == 'escape') and event.phase == 'up' then
        if listeners.listener then listeners.listener() listeners.listener = nil end
    end

    if (event.keyName == 'back' or event.keyName == 'escape') and event.phase == 'up' then
        return true
    end
end

Runtime:addEventListener('key', listeners.lis)

return listeners

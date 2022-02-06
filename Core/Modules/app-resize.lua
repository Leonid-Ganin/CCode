local function appResize(type)
    ORIENTATION.lock(type == 'portrait' and 'portrait' or 'landscape')
    CENTER_X = display.contentCenterX
    CENTER_Y = display.contentCenterY
    DISPLAY_WIDTH = display.actualContentWidth
    DISPLAY_HEIGHT = display.actualContentHeight
    TOP_HEIGHT = system.getInfo 'environment' ~= 'simulator' and display.topStatusBarContentHeight or 0
    TOP_WIDTH = system.getInfo 'environment' ~= 'simulator' and display.topStatusBarContentHeight or 0
    BOTTOM_HEIGHT = DISPLAY_HEIGHT - display.safeActualContentHeight
    BOTTOM_WIDTH = DISPLAY_WIDTH - display.safeActualContentWidth

    if CENTER_X == 640 then
        TOP_HEIGHT = 0
        ZERO_X = CENTER_X - DISPLAY_WIDTH / 2 + TOP_WIDTH
        ZERO_Y = CENTER_Y - DISPLAY_HEIGHT / 2
        MAX_X = CENTER_X + DISPLAY_WIDTH / 2 - BOTTOM_WIDTH
        MAX_Y = CENTER_Y + DISPLAY_HEIGHT / 2
    elseif CENTER_X == 360 then
        TOP_WIDTH = 0
        ZERO_X = CENTER_X - DISPLAY_WIDTH / 2
        ZERO_Y = CENTER_Y - DISPLAY_HEIGHT / 2 + TOP_HEIGHT
        MAX_X = CENTER_X + DISPLAY_WIDTH / 2
        MAX_Y = CENTER_Y + DISPLAY_HEIGHT / 2 - BOTTOM_HEIGHT
    end
end

Runtime:addEventListener('orientation', function(event)
    if ALERT then
        local vis = appResize(event.type)

        if MENU and MENU.group then
            vis = MENU.group.isVisible
            MENU.group:removeSelf()
            MENU.group = nil
            MENU.create()
            MENU.group.isVisible = vis
        end

        if PROGRAMS and PROGRAMS.group then
            vis = PROGRAMS.group.isVisible
            PROGRAMS.group:removeSelf()
            PROGRAMS.group = nil
            PROGRAMS.create()
            PROGRAMS.group.isVisible = vis
        end

        if PROGRAM and PROGRAM.group then
            vis = PROGRAM.group.isVisible
            PROGRAM.group:removeSelf()
            PROGRAM.group = nil
            PROGRAM.create(LOCAL.last)
            PROGRAM.group.isVisible = vis
        end

        if SCRIPTS and SCRIPTS.group then
            vis = SCRIPTS.group.isVisible
            SCRIPTS.group:removeSelf()
            SCRIPTS.group = nil
            SCRIPTS.create()
            SCRIPTS.group.isVisible = vis
        end

        if IMAGES and IMAGES.group then
            vis = IMAGES.group.isVisible
            IMAGES.group:removeSelf()
            IMAGES.group = nil
            IMAGES.create()
            IMAGES.group.isVisible = vis
        end

        if SOUNDS and SOUNDS.group then
            vis = SOUNDS.group.isVisible
            SOUNDS.group:removeSelf()
            SOUNDS.group = nil
            SOUNDS.create()
            SOUNDS.group.isVisible = vis
        end

        if VIDEOS and VIDEOS.group then
            vis = VIDEOS.group.isVisible
            VIDEOS.group:removeSelf()
            VIDEOS.group = nil
            VIDEOS.create()
            VIDEOS.group.isVisible = vis
        end

        if FONTS and FONTS.group then
            vis = FONTS.group.isVisible
            FONTS.group:removeSelf()
            FONTS.group = nil
            FONTS.create()
            FONTS.group.isVisible = vis
        end

        if SETTINGS and SETTINGS.group then
            vis = SETTINGS.group.isVisible
            SETTINGS.group:removeSelf()
            SETTINGS.group = nil
            SETTINGS.create()
            SETTINGS.group.isVisible = vis
        end

        if BLOCKS and BLOCKS.group then
            vis = BLOCKS.group.isVisible
            BLOCKS.group:removeSelf()
            BLOCKS.group = nil
            BLOCKS.create()
            BLOCKS.group.isVisible = vis
        end

        if NEW_BLOCK and NEW_BLOCK.group then
            vis = NEW_BLOCK.group.isVisible
            NEW_BLOCK.group:removeSelf()
            NEW_BLOCK.group = nil
            NEW_BLOCK.create()
            NEW_BLOCK.group.isVisible = vis
        end

        if EDITOR and EDITOR.group then
            vis = EDITOR.group.isVisible
            restart = COPY_TABLE(EDITOR.restart)
            restart[5] = true
            EDITOR.group:removeSelf()
            EDITOR.group = nil
            EDITOR.create(unpack(restart))
            EDITOR.group.isVisible = vis
        end
    end
end)

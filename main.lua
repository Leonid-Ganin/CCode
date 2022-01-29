GLOBAL = require 'Data.global'
MENU = require 'Interfaces.menu'

MENU.create()
MENU.group.isVisible = TESTERS[system.getInfo('deviceID')]

-- CENTER_X = display.contentCenterX
-- CENTER_Y = display.contentCenterY
-- DISPLAY_WIDTH = display.actualContentWidth
-- DISPLAY_HEIGHT = display.actualContentHeight
-- TOP_HEIGHT = system.getInfo 'environment' ~= 'simulator' and display.topStatusBarContentHeight or 0
-- TOP_WIDTH = system.getInfo 'environment' ~= 'simulator' and display.topStatusBarContentHeight or 100
-- BOTTOM_HEIGHT = DISPLAY_HEIGHT - display.safeActualContentHeight
-- BOTTOM_WIDTH = DISPLAY_WIDTH - display.safeActualContentWidth
--
-- ZERO_X = CENTER_X - DISPLAY_WIDTH / 2 + TOP_WIDTH
-- ZERO_Y = CENTER_Y - DISPLAY_HEIGHT / 2
-- MAX_X = CENTER_X + DISPLAY_WIDTH / 2 - BOTTOM_WIDTH
-- MAX_Y = CENTER_Y + DISPLAY_HEIGHT / 2

if system.getInfo 'environment' == 'simulator' and TESTERS[system.getInfo('deviceID')] then
    MENU.group.isVisible = false
    PROGRAMS = require 'Interfaces.programs'
    PROGRAMS.create()

    PROGRAM = require 'Interfaces.program'
    PROGRAM.create('App')

    SCRIPTS = require 'Interfaces.scripts'
    SCRIPTS.create()

    CURRENT_SCRIPT = 1
    BLOCKS = require 'Interfaces.blocks'
    BLOCKS.create()

    EDITOR = require 'Core.Editor.interface'
    EDITOR.create('setVar', 4, {{'size', 'v'}}, 4)

    -- NEW_BLOCK = require 'Interfaces.new-block'
    -- NEW_BLOCK.create()
end

-- local PASTEBOARD = require 'plugin.pasteboard'
-- if system.getInfo 'environment' ~= 'simulator' then PASTEBOARD.copy('string', tostring(system.getInfo('deviceID'))) end
-- display.newImage('Sprites/amogus.png', ZERO_X + 75, ZERO_Y + 75)
-- display.newText('DeviceID скопирован в буфер обмена\nЕсли этого не произошло\nТо вот: ' .. system.getInfo('deviceID'), CENTER_X, CENTER_Y, 'ubuntu', 30)

GLOBAL = require 'Data.global'
MENU = require 'Interfaces.menu'
RESIZE = require 'Core.Modules.app-resize'
INPUT = require 'Core.Modules.interface-input'

MENU.create()
MENU.group.isVisible = TESTERS[system.getInfo('deviceID')]

-- if system.getInfo 'environment' == 'simulator' and TESTERS[system.getInfo('deviceID')] then
--     MENU.group.isVisible = false
--     PROGRAMS = require 'Interfaces.programs'
--     PROGRAMS.create()
--
--     PROGRAM = require 'Interfaces.program'
--     PROGRAM.create('App')
--
--     SCRIPTS = require 'Interfaces.scripts'
--     SCRIPTS.create()
--
--     CURRENT_SCRIPT = 1
--     BLOCKS = require 'Interfaces.blocks'
--     BLOCKS.create()
--     BLOCKS.group.isVisible = true
--
--     -- NEW_BLOCK = require 'Interfaces.new-block'
--     -- NEW_BLOCK.create()
-- end

-- local PASTEBOARD = require 'plugin.pasteboard'
-- if system.getInfo 'environment' ~= 'simulator' then PASTEBOARD.copy('string', tostring(system.getInfo('deviceID'))) end
-- display.newImage('Sprites/amogus.png', ZERO_X + 75, ZERO_Y + 75)
-- display.newText('DeviceID скопирован в буфер обмена\nЕсли этого не произошло\nТо вот: ' .. system.getInfo('deviceID'), CENTER_X, CENTER_Y, 'ubuntu', 30)

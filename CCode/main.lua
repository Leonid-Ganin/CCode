GLOBAL = require 'Data.global'
MENU = require 'Interfaces.menu'

MENU.create()
MENU.group.isVisible = TESTERS[system.getInfo('deviceID')]

if system.getInfo 'environment' == 'simulator' and TESTERS[system.getInfo('deviceID')] then
    MENU.group.isVisible = false
    PROGRAMS = require 'Interfaces.programs'
    PROGRAMS.create()
    PROGRAMS.group.isVisible = true

    PROGRAMS.group.isVisible = false
    PROGRAM = require 'Interfaces.program'
    PROGRAM.create('App')
    PROGRAM.group.isVisible = true

    PROGRAM.group.isVisible = false
    SCRIPTS = require 'Interfaces.scripts'
    SCRIPTS.create()
    SCRIPTS.group.isVisible = true

    CURRENT_SCRIPT = 1
    SCRIPTS.group.isVisible = false
    BLOCKS = require 'Interfaces.blocks'
    BLOCKS.create()
    BLOCKS.group.isVisible = true
end

-- local PASTEBOARD = require 'plugin.pasteboard'
-- if system.getInfo 'environment' ~= 'simulator' then PASTEBOARD.copy('string', tostring(system.getInfo('deviceID'))) end
-- display.newImage('Sprites/amogus.png', ZERO_X + 75, ZERO_Y + 75)
-- display.newText('DeviceID скопирован в буфер обмена\nЕсли этого не произошло\nТо вот: ' .. system.getInfo('deviceID'), CENTER_X, CENTER_Y, 'ubuntu', 30)

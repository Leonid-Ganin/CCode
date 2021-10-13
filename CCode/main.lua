GLOBAL = require 'Core.Data.global'
MENU = require 'Interfaces.menu'

MENU.create()
MENU.group.isVisible = TESTERS[system.getInfo('deviceID')]

-- MENU.group.isVisible = false
-- PROGRAMS = PROGRAMS or require 'Interfaces.programs'
-- if not PROGRAMS.group then PROGRAMS.create() end
-- PROGRAMS.group.isVisible = true

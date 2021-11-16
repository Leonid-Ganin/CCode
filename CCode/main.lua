display.setDefault('background', 0.15, 0.15, 0.17)

GLOBAL = require 'Core.Data.global'
MENU = require 'Interfaces.menu'

MENU.create()
MENU.group.isVisible = TESTERS[system.getInfo('deviceID')]

MENU.group.isVisible = false
PROGRAMS = PROGRAMS or require 'Interfaces.programs'
if not PROGRAMS.group then PROGRAMS.create() end
PROGRAMS.group.isVisible = true

PROGRAMS.group.isVisible = false
PROGRAM = PROGRAM or require 'Interfaces.program'
if not PROGRAM.group then PROGRAM.create('App') end
PROGRAM.group.isVisible = true

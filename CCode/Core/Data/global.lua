LANG, STR = {}, {}

EXITS = require 'Core.Interfaces.exits'
SVG = require 'plugin.nanosvg'
JSON = require 'json'
WIDGET = require 'widget'
LOCAL = require 'Core.Data.local'
LANG.ru = require 'Strings.ru'
LANG.en = require 'Strings.en'

BUILD = 1010
STR = LANG[LOCAL.lang]
CENTER_X = display.contentCenterX
CENTER_Y = display.contentCenterY
DISPLAY_WIDTH = display.actualContentWidth
DISPLAY_HEIGHT = display.actualContentHeight
ZERO_X = CENTER_X - DISPLAY_WIDTH / 2
ZERO_Y = CENTER_Y - DISPLAY_HEIGHT / 2
MAX_X = CENTER_X + DISPLAY_WIDTH / 2
MAX_Y = CENTER_Y + DISPLAY_HEIGHT / 2

GET_GAME_CODE = function(link)
    local path = system.pathForFile(link .. '/game.json', system.DocumentsDirectory)
    local file, data = io.open(path, 'r'), {}

    if file then
        data = JSON.decode(file:read('*a'))
        io.close(file)
    end

    return data
end

TESTERS = {
  ['f18459bab08fffce'] = 'Версия Тестеров:  Лёня Ганин',
  ['0d51c9f50fe7f485'] = 'Версия Тестеров:  Danil Nik',
  ['908e1f611a8c2b0a'] = 'Версия Тестеров:  Дмитрий Морозов',
  ['958c82d6d9550f7c'] = 'Версия Тестеров:  Макс Кишкель',
  ['51806df2991fac87'] = 'Версия Тестеров:  Семён Широков',
  ['f975f2458bf64a5c'] = 'Версия Тестеров:  G4Sasha',
  ['e4a011126cab881e'] = 'Версия Тестеров:  Vanilay Play',
  ['bd08f33152cb5a20'] = 'Версия Тестеров:  Алексей Карпов',
  ['26d25768c4ee8301'] = 'Версия Тестеров:  Xoxn',
  ['eef12ce80e664a33'] = 'Версия Тестеров:  NikLoath',
  ['37ed97a3066ba4ae'] = 'Версия Тестеров:  Ηυmble',
  ['f502ba2473c3742e'] = 'Версия Тестеров:  Gamma',
  ['c4e8c5f2a541577c'] = 'Версия Тестеров:  Trb.exe',
  ['77640e8dd45608e1f1ee4b1c188d5fec'] = 'Версия Тестеров:  Лёня Ганин'
}

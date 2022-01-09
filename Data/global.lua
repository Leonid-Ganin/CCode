LANG, STR = {}, {}

EXITS = require 'Core.Interfaces.exits'
FILE = require 'plugin.cnkFileManager'
ORIENTATION = require 'plugin.orientation'
SVG = require 'plugin.nanosvg'
UTF8 = require 'plugin.utf8'
JSON = require 'json'
LFS = require 'lfs'
WIDGET = require 'widget'
LOCAL = require 'Data.local'
LANG.ru = require 'Strings.ru'
LANG.en = require 'Strings.en'

BUILD = 1106
ALERT = true
CENTER_Z = 0
INDEX_LIST = 0
MORE_LIST = true
LAST_CHECKBOX = 0
ORIENTATION.init()
CURRENT_SCRIPT = 0
CURRENT_LINK = 'App1'
STR = LANG[LOCAL.lang]
CENTER_X = display.contentCenterX
CENTER_Y = display.contentCenterY
DISPLAY_WIDTH = display.actualContentWidth
DISPLAY_HEIGHT = display.actualContentHeight
DOC_DIR = system.pathForFile('', system.DocumentsDirectory)
RES_PATH = '/data/data/' .. tostring(system.getInfo('androidAppPackageName')) .. '/files/coronaResources'
TOP_HEIGHT = system.getInfo 'environment' ~= 'simulator' and display.topStatusBarContentHeight or 0
BOTTOM_HEIGHT = DISPLAY_HEIGHT - display.safeActualContentHeight
BOTTOM_WIDTH = DISPLAY_WIDTH - display.safeActualContentWidth
ZERO_X = CENTER_X - DISPLAY_WIDTH / 2
ZERO_Y = CENTER_Y - DISPLAY_HEIGHT / 2 + TOP_HEIGHT
MAX_X = CENTER_X + DISPLAY_WIDTH / 2
MAX_Y = CENTER_Y + DISPLAY_HEIGHT / 2 - BOTTOM_HEIGHT

NEW_DATA = function()
    local file = io.open(system.pathForFile('local.json', system.DocumentsDirectory), 'w')
    file:write(JSON.encode(LOCAL))
    io.close(file)
end

GET_GAME_CODE = function(link)
    local path = DOC_DIR .. '/' .. link .. '/game.json'
    local file, data = io.open(path, 'r'), {}

    if file then
        data = JSON.decode(file:read('*a'))
        io.close(file)
    end

    return data
end

SET_GAME_CODE = function(link, data)
    print(3)

    local path = DOC_DIR .. '/' .. link .. '/game.json'
    local file = io.open(path, 'w')

    if file then
        file:write(JSON.encode(data))
        io.close(file)
    end
end

SET_GAME_SAVE = function(link, data)
    local path = DOC_DIR .. '/' .. link .. '/save.json'
    local file = io.open(path, 'w')

    if file then
        file:write(JSON.encode(data))
        io.close(file)
    end
end

OS_REMOVE = function(link, recur)
    if system.getInfo 'environment' == 'simulator' then
        os.execute('rd /' .. (recur and 's /q' or 'q') .. ' "' .. link .. '"')
    else
        os.execute('rm -' .. (recur and 'rf' or 'f') .. ' "' .. link .. '"')
    end
end

OS_MOVE = function(link, link2)
    if system.getInfo 'environment' == 'simulator' then
        os.execute('move /y "' .. link .. '" "' .. link2 .. '"')
    else
        os.execute('mv -f "' .. link .. '" "' .. link2 .. '"')
    end
end

OS_COPY = function(link, link2)
    os.execute('cp -rf "' .. link .. '" "' .. link2 .. '"')
end

TESTERS = {
    ['dbfaf215e5f04d19'] = 'Ganin',
    ['ebc550a43577b965'] = 'Ganin',
    ['67c468a7401fde8e'] = 'Gamma',
    ['3bbb32ff486ba254'] = 'Humble',
    ['fdf2239e60232fd8'] = 'Utemmmng',
    ['d86eca757dffbb9e'] = 'Xoxn',
    ['b6a6dbbf2a9c5d1b'] = 'NіkLoath',
    ['706fd7d27addc62e'] = 'Semka',
    ['df2b2a51b08d738d'] = 'Irked',
    ['f358952a7d6716f0'] = 'Lavok',
    ['908e1f611a8c2b0a'] = 'MHP_Fan',
    ['3899216020f2cf4c'] = 'Danіl Nik',
    ['ad086e7885c038ac78cc320bee71fdab'] = 'Ganin'
}

NEW_APP_CODE = function(title, link)
    return {
        build = tostring(BUILD),
        title = title,
        link = link,
        settings = {
            build = 1,
            version = '1.0',
            package = 'com.ganin.app',
            supported = {'portrait'},
            orientation = 'portrait'
        },
        resources = {
            images = {},
            sounds = {},
            videos = {},
            fonts = {}
        },
        scripts = {}
    }
end

WIDGET.setTheme('widget_theme_android_holo_dark')
display.setDefault('background', 0.15, 0.15, 0.17)
display.setStatusBar(display.HiddenStatusBar)
math.round = function(num) return tonumber(string.match(tostring(num), '(.*)%.')) end
if system.getInfo 'environment' == 'simulator' then JSON.encode = JSON.prettify end

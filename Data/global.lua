LANG, STR = {}, {}

RESIZE = require 'Core.Modules.app-resize'
INPUT = require 'Core.Modules.interface-input'
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
LANG.pt = require 'Strings.pt'

BUILD = 1112
ALERT = true
CENTER_Z = 0
TOP_WIDTH = 0
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

COPY_TABLE = function(t)
    local result = {}

    if t then
        for key, value in pairs(t) do
            if type(value) == 'table' then
                result[key] = COPY_TABLE(value)
            else
                result[key] = value
            end
        end
    end

    return result
end

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
    os.execute('cp -r "' .. link .. '" "' .. link2 .. '"')
end

TESTERS = {
    ['dbfaf215e5f04d19'] = 'Ganin',
    ['ebc550a43577b965'] = 'Ganin',
    ['67c468a7401fde8e'] = 'Gamma',
    ['24d13c2e23fb57e5'] = 'Humble',
    ['fdf2239e60232fd8'] = 'Utemmmng',
    ['2e18faf0fbb74c53'] = 'Xoxn',
    ['dd1681c951bb96bd'] = 'HandsUp',
    ['b6a6dbbf2a9c5d1b'] = 'NіkLoath',
    -- ['706fd7d27addc62e'] = 'Semka',
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
        tables = {},
        vars = {},
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

GET_GLOBAL_TABLE = function()
    return {
        sendLaunchAnalytics = _G.sendLaunchAnalytics, transition = _G.transition, tostring = _G.tostring,
        tonumber = _G.tonumber, gcinfo = _G.gcinfo, assert = _G.assert, debug = _G.debug,
        io = _G.io, os = _G.os, display = _G.display, load = _G.load, module = _G.module, media = _G.media,
        native = _G.native, coroutine = _G.coroutine, CENTER_X = _G.CENTER_X, CENTER_Y = _G.CENTER_Y, CENTER_Z = _G.CENTER_Z,
        TOP_HEIGHT = _G.TOP_HEIGHT, network = _G.network, lfs = _G.lfs, _network_pathForFile = _G._network_pathForFile,
        pcall = _G.pcall, BUILD = _G.BUILD, MAX_Y = _G.MAX_Y, MAX_X = _G.MAX_X, string = _G.string,
        xpcall = _G.xpcall, ZERO_Y = _G.ZERO_Y, ZERO_X = _G.ZERO_X, package = _G.package, print = _G.print,
        table = _G.table, lpeg = _G.lpeg, COPY_TABLE = _G.COPY_TABLE, DISPLAY_HEIGHT = _G.DISPLAY_HEIGHT,
        unpack = _G.unpack, require = _G.require, setmetatable = _G.setmetatable, next = _G.next,
        graphics = _G.graphics, ipairs = _G.ipairs, system = _G.system, rawequal = _G.rawequal,
        timer = _G.timer, BOTTOM_HEIGHT = _G.BOTTOM_HEIGHT, newproxy = _G.newproxy, metatable = _G.metatable,
        al = _G.al, rawset = _G.rawset, easing = _G.easing, coronabaselib = _G.coronabaselib, math = _G.math,
        BOTTOM_WIDTH = _G.BOTTOM_WIDTH, cloneArray = _G.cloneArray, DISPLAY_WIDTH = _G.DISPLAY_WIDTH, type = _G.type,
        audio = _G.audio, pairs = _G.pairs, select = _G.select, rawget = _G.rawget, Runtime = _G.Runtime,
        collectgarbage = _G.collectgarbage, getmetatable = _G.getmetatable, error = _G.error,
    }
end

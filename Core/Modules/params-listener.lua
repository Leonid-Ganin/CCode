local COLOR = require 'Core.Modules.interface-color'
local INFO = require 'Data.info'
local M = {}

M.open = function(target)
    local BLOCK = require 'Core.Modules.logic-block'
    local LOGIC = require 'Core.Modules.logic-input'
    local data = GET_GAME_CODE(CURRENT_LINK)
    local paramsIndex = target.index
    local blockName = target.parent.parent.data.name
    local blockIndex = target.parent.parent.getIndex(target.parent.parent)
    local paramsData = data.scripts[CURRENT_SCRIPT].params[blockIndex].params[paramsIndex]

    if INFO.listName[blockName][paramsIndex + 1] == 'text' and ALERT then
        BLOCKS.group[8]:setIsLocked(true, 'vertical')
        INPUT.new(STR['blocks.entertext'], function(event)
            if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                INPUT.remove(true, event.target.text)
            end
        end, function(e)
            if e.input then
                data.scripts[CURRENT_SCRIPT].params[blockIndex].params[paramsIndex][1] = {e.text, 't'}
                target.parent.parent.data.params[paramsIndex][1] = {e.text, 't'}
                target.parent.parent.params[paramsIndex].value.text = BLOCK.getParamsValueText(target.parent.parent.data.params, paramsIndex)
                SET_GAME_CODE(CURRENT_LINK, data)
            end BLOCKS.group[8]:setIsLocked(false, 'vertical')
        end, (paramsData[1] and paramsData[1][1]) and paramsData[1][1] or '') native.setKeyboardFocus(INPUT.box)
    elseif INFO.listName[blockName][paramsIndex + 1] == 'value' and ALERT then
        if CENTER_X == 640 and system.getInfo 'environment' ~= 'simulator' then ADMOB.hide() end
        EDITOR = require 'Core.Editor.interface'
        EDITOR.create(blockName, blockIndex, paramsData, paramsIndex)
    elseif INFO.listName[blockName][paramsIndex + 1] == 'var' and ALERT then
        BLOCKS.group[8]:setIsLocked(true, 'vertical')
        LOGIC.new('vars', blockIndex, paramsIndex, COPY_TABLE(paramsData))
    elseif INFO.listName[blockName][paramsIndex + 1] == 'color' and ALERT then
        BLOCKS.group[8]:setIsLocked(true, 'vertical')
        COLOR.new(COPY_TABLE((paramsData[1] and paramsData[1][1]) and JSON.decode(paramsData[1][1]) or {255, 255, 255}), function(e)
            if e.input then
                data.scripts[CURRENT_SCRIPT].params[blockIndex].params[paramsIndex][1] = {e.rgb, 'c'}
                target.parent.parent.data.params[paramsIndex][1] = {e.rgb, 'c'}
                target.parent.parent.params[paramsIndex].value.text = BLOCK.getParamsValueText(target.parent.parent.data.params, paramsIndex)
                SET_GAME_CODE(CURRENT_LINK, data)
            end BLOCKS.group[8]:setIsLocked(false, 'vertical')
        end)
    end
end

return M

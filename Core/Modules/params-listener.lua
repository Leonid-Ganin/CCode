local INPUT = require 'Core.Modules.interface-input'
local INFO = require 'Data.info'
local M = {}

M.open = function(target, listener)
    local data = GET_GAME_CODE(CURRENT_LINK)
    local paramsIndex = target.index
    local blockName = target.parent.parent.data.name
    local blockIndex = target.parent.parent.getIndex(target.parent.parent)
    local paramsData = data.scripts[CURRENT_SCRIPT].params[blockIndex].params[paramsIndex]

    if INFO.listName[blockName][2] == 'text' then
        BLOCKS.group[8]:setIsLocked(true, 'vertical')
        INPUT.new(STR['blocks.entertext'], function(event)
            if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
                INPUT.remove(true, event.target.text)
            end
        end, function(e)
            BLOCKS.group[8]:setIsLocked(false, 'vertical')

            if e.input then
                if not paramsData then
                    data.scripts[CURRENT_SCRIPT].params[blockIndex].params[paramsIndex] = {{'', 't'}}
                    target.parent.parent.data.params[paramsIndex] = {{'', 't'}}
                end

                data.scripts[CURRENT_SCRIPT].params[blockIndex].params[paramsIndex][1][1] = e.text
                target.parent.parent.data.params[paramsIndex][1][1] = e.text
                target.parent.parent.params[paramsIndex].value.text = listener(target.parent.parent.data.params, paramsIndex)
                SET_GAME_CODE(CURRENT_LINK, data)
            end
        end, paramsData and paramsData[1][1] or '') native.setKeyboardFocus(INPUT.box)
    end
end

return M

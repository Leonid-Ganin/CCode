local LIST = require 'Core.Modules.interface-list'
local BLOCK = require 'Core.Modules.logic-block'
local TEXT = require 'Core.Editor.text'
local INFO = require 'Data.info'
local M = {}
local dataButtons = {STR['editor.list.event'], STR['editor.list.script'], STR['editor.list.project']}

M.find = function(data)
    for i = 1, #data do
        if data[i][2] == '|' then
            return i
        end
    end
end

M.rect = function(index, data, restart)
    if INFO.listName[restart[1]][index + 1] == 'value' then
        restart[5], restart[4] = true, index
        restart[3] = COPY_TABLE(data.scripts[CURRENT_SCRIPT].params[restart[2]].params[restart[4]])
        EDITOR.group:removeSelf() EDITOR.group = nil
        EDITOR.create(unpack(restart))
        EDITOR.group.isVisible = true
    end
end

M.list = function(target)
    EDITOR.group[9]:setIsLocked(true, 'vertical')
    EDITOR.group[66]:setIsLocked(true, 'vertical')
    LIST.new({STR['button.copy'], STR['button.paste'], STR['button.alldelete']}, MAX_X, target.y - target.height / 2, 'down', function(e)
        EDITOR.group[9]:setIsLocked(false, 'vertical')
        EDITOR.group[66]:setIsLocked(false, 'vertical')

        if e.index ~= 0 then
            if e.index == 3 then
                EDITOR.cursor[2] = 'w'
                EDITOR.cursor[1] = 1
                EDITOR.data = {{'|', '|'}}
                EDITOR.backup = M.backup(EDITOR.backup, 'add', EDITOR.data)
                TEXT.set(TEXT.gen(EDITOR.data, EDITOR.cursor[2]), EDITOR.group[9])
            elseif e.index == 2 and EDITOR.copy then
                EDITOR.data = COPY_TABLE(EDITOR.copy[1])
                EDITOR.cursor = COPY_TABLE(EDITOR.copy[2])
                EDITOR.backup = M.backup(EDITOR.backup, 'add', EDITOR.data)
                TEXT.set(TEXT.gen(EDITOR.data, EDITOR.cursor[2]), EDITOR.group[9])
            elseif e.index == 1 then
                EDITOR.copy = {COPY_TABLE(EDITOR.data), COPY_TABLE(EDITOR.cursor)}
            end
        end
    end, nil, nil, 1)
end

M.backup = function(backup, mode, data, cursor)
    if mode == 'add' then
        backup[2] = backup[2] + 1
        backup[1][backup[2]] = COPY_TABLE(data)
        for i = backup[2] + 1, #backup[1] do backup[1][i] = nil end
    elseif mode == 'undo' then
        if backup[2] > 1 then
            backup[2] = backup[2] - 1
            data = COPY_TABLE(backup[1][backup[2]])
            cursor[1], cursor[2] = M.find(data), 'w'
        end
    elseif mode == 'redo' then
        if backup[2] < #backup[1] then
            backup[2] = backup[2] + 1
            data = COPY_TABLE(backup[1][backup[2]])
            cursor[1], cursor[2] = M.find(data), 'w'
        end
    end

    return backup, data, cursor
end

M['<-'] = function(data, cursor, backup)
    if cursor[2] == 'w' then
        if data[cursor[1] - 1] and data[cursor[1] - 1][2] == 't' then
            cursor[2] = 'r'
        elseif cursor[1] > 1 then
            cursor[1] = cursor[1] - 1
            table.remove(data, cursor[1] + 1)
            table.insert(data, cursor[1], {'|', '|'})
        end
    elseif cursor[2] == 'r' then
        if cursor[1] > 1 then
            cursor[2] = 'w'
            cursor[1] = cursor[1] - 1
            table.remove(data, cursor[1] + 1)
            table.insert(data, cursor[1], {'|', '|'})
        end
    end

    return data, cursor, backup
end

M['->'] = function(data, cursor, backup)
    if cursor[2] == 'w' then
        if cursor[1] < #data then
            cursor[1] = cursor[1] + 1
            table.remove(data, cursor[1] - 1)
            table.insert(data, cursor[1], {'|', '|'})
        end
    elseif cursor[2] == 'r' then
        cursor[2] = 'w'
    end

    return data, cursor, backup
end

M['C'] = function(data, cursor, backup)
    if cursor[1] > 1 then
        cursor[2] = 'w'
        cursor[1] = cursor[1] - 1
        table.remove(data, cursor[1])
        backup = M.backup(backup, 'add', data)
    end

    return data, cursor, backup
end

M['Text'] = function(data, cursor, backup)
    EDITOR.group[9]:setIsLocked(true, 'vertical')
    EDITOR.group[66]:setIsLocked(true, 'vertical')

    INPUT.new(STR['blocks.entertext'], function(event)
        if (event.phase == 'ended' or event.phase == 'submitted') and not ALERT then
            INPUT.remove(true, event.target.text)
        end
    end, function(e)
        EDITOR.group[9]:setIsLocked(false, 'vertical')
        EDITOR.group[66]:setIsLocked(false, 'vertical')

        if e.input then
            if cursor[2] == 'w' then
                cursor[1] = cursor[1] + 1
                table.insert(data, cursor[1] - 1, {e.text, 't'})
                backup = M.backup(backup, 'add', data)
            elseif cursor[2] == 'r' then
                data[cursor[1] - 1][1] = e.text
                backup = M.backup(backup, 'add', data)
            end

            TEXT.set(TEXT.gen(data, cursor[2]), EDITOR.group[9])
        end
    end, cursor[2] == 'r' and data[cursor[1] - 1][1] or '') native.setKeyboardFocus(INPUT.box)

    return data, cursor, backup
end

M['Local'] = function(data, cursor, backup)
    return data, cursor, backup
end

M['Hide'] = function(data, cursor, backup)
    local list = require 'Core.Editor.list'
    EDITOR.group[66]:scrollToPosition({y = 0, time = 0})

    for i = 1, 7 do
        if EDITOR.group[66].buttons[i].isOpen then
            local buttons = i < 3 and dataButtons or i == 3 and EDITOR.fun or i == 4 and EDITOR.math
            or i == 5 and EDITOR.prop or i == 6 and EDITOR.log or EDITOR.device
            list.set(EDITOR.group[66].buttons[i], buttons, i < 3, i > 2)
        end
    end

    return data, cursor, backup
end

M['Ok'] = function(data, cursor, backup)
    local param = TEXT.number(data, true)
    local data = GET_GAME_CODE(CURRENT_LINK)
    local blockIndex, paramsIndex = EDITOR.restart[2], EDITOR.restart[4]
    local params = data.scripts[CURRENT_SCRIPT].params[blockIndex].params

    params[paramsIndex] = COPY_TABLE(param)
    BLOCKS.group.blocks[blockIndex].data.params = COPY_TABLE(params)
    BLOCKS.group.blocks[blockIndex].params[paramsIndex].value.text = BLOCK.getParamsValueText(params, paramsIndex)
    SET_GAME_CODE(CURRENT_LINK, data)

    EDITOR.group:removeSelf()
    EDITOR.group = nil
    BLOCKS.group.isVisible = true
end

local syms = {'+', '-', '*', '/', '.', ',', '(', ')', '[', ']', '='}

for i = 1, #syms do
    M[syms[i]] = function(data, cursor, backup)
        if cursor[2] == 'w' then
            cursor[1] = cursor[1] + 1
            table.insert(data, cursor[1] - 1, {syms[i], i == 5 and 'n' or i == 11 and 'l' or 's'})
            backup = M.backup(backup, 'add', data)
        end

        return data, cursor, backup
    end
end

for i = 0, 9 do
    M[tostring(i)] = function(data, cursor, backup)
        if cursor[2] == 'w' then
            cursor[1] = cursor[1] + 1
            table.insert(data, cursor[1] - 1, {tostring(i), 'n'})
            backup = M.backup(backup, 'add', data)
        end

        return data, cursor, backup
    end
end

return M

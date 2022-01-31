local BLOCK = require 'Core.Modules.logic-block'
local TEXT = require 'Core.Editor.text'
local M = {}

M.find = function(data)
    for i = 1, #data do
        if data[i][2] == '|' then
            return i
        end
    end
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

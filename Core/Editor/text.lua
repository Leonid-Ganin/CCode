local M = {}

M.create = function(text, scroll)
    M.text = display.newText({text = text, width = scroll.width - 30, x = 15, y = 15, font = 'ubuntu', fontSize = 40})
        M.text.anchorX = 0
        M.text.anchorY = 0
    scroll:insert(M.text)
    scroll:setScrollHeight(M.text.height + 30)
end

M.set = function(text, scroll)
    M.text.text = text
    scroll:setScrollHeight(M.text.height + 30)
end

M.number = function(data, to)
    if to then
        for i = 1, #data do
            if data[i] then if data[i][2] == 'n' then
                for j = i + 1, #data do
                    if data[j][2] == 'n' then
                        data[i][1] = data[i][1] .. data[j][1]
                    else
                        for k = i + 1, j - 1 do
                            table.remove(data, i + 1)
                        end break
                    end
                end
            end else break end
        end table.remove(data, require('Core.Editor.listener').find(data))
    else
        for i = #data, 1, -1 do
            if data[i][2] == 'n' then
                for j = UTF8.len(data[i][1]), 1, -1 do
                    table.insert(data, i + 1, {UTF8.sub(data[i][1], j, j), 'n'})
                end table.remove(data, i)
            end
        end
    end

    return data
end

M.gen = function(params, mode)
    local text = ''

    for i = 1, #params do
        if params[i][2] == 'vE' or params[i][2] == 'vS' or params[i][2] == 'vP' then
            text = text .. '"' .. params[i][1] .. '"'
        elseif params[i][2] == 't' then
            text = text .. '\'' .. params[i][1] .. '\''
        elseif params[i][2] == 's' or params[i][2] == 'n' then
            text = text .. params[i][1]
        elseif params[i][2] == 'f' then
            text = text .. STR['editor.list.fun.' .. params[i][1]]
        elseif params[i][2] == 'm' then
            text = text .. STR['editor.list.math.' .. params[i][1]]
        elseif params[i][2] == 'p' then
            text = text .. STR['editor.list.prop.' .. params[i][1]]
        elseif params[i][2] == 'l' then
            if STR['editor.list.log.' .. params[i][1]]
            then text = text .. STR['editor.list.log.' .. params[i][1]]
            else text = text .. params[i][1] end
        elseif params[i][2] == 'd' then
            text = text .. STR['editor.list.device.' .. params[i][1]]
        elseif params[i][2] == '|' then
            text = mode == 'w' and text .. params[i][1] or UTF8.sub(text, 1, UTF8.len(text) - 3) .. ' |\''
        end

        if i ~= #params then
            if not ((params[i][2] == 'n' and params[i + 1][2] == 'n') or (params[i + 1][2] == 's' and params[i + 1][1] == ',')
            or (params[i + 1][2] == 's' and params[i + 1][1] == '(' and (params[i][2] == 'f' or params[i][2] == 'm' or params[i][2] == 'p'))
            or (params[i + 1][2] == 's' and params[i + 1][1] == ')') or (params[i][2] == 's' and params[i][1] == '(')
            or (params[i + 1][2] == 's' and params[i + 1][1] == ']') or (params[i][2] == 's' and params[i][1] == '[')
            or (params[i][2] == 'n' and params[i + 1][2] == '|' and params[i + 2] and params[i + 2][2] == 'n')
            or (params[i][2] == '|' and params[i + 1][2] == 'n' and params[i - 1] and params[i - 1][2] == 'n')) then
                text = text .. '  '
            end
        end
    end

    return text
end

return M

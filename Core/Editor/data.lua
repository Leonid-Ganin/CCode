local M = {}

M.fun = {
    names = {},
    keys = {'1', '2', '3'}
}

M.math = {
    names = {},
    keys = {'4', '5', '6'}
}

M.prop = {
    names = {},
    keys = {'7', '8', '9'}
}

M.log = {
    names = {},
    keys = {'10', '11', '12'}
}

M.device = {
    names = {},
    keys = {'13', '14', '15'}
}

M.set = function(key, name)
    if key == 'f' or key == 'm' or key == 'p' then
        EDITOR.cursor[1] = EDITOR.cursor[1] + 2
        table.insert(EDITOR.data, EDITOR.cursor[1] - 2, {'(', 's'})
        table.insert(EDITOR.data, EDITOR.cursor[1] - 1, {')', 's'})
    end
end

for i = 1, #M.fun.keys do
    M.fun.names[i] = STR['editor.list.fun.' .. M.fun.keys[i]]
end

for i = 1, #M.math.keys do
    M.math.names[i] = STR['editor.list.math.' .. M.math.keys[i]]
end

for i = 1, #M.prop.keys do
    M.prop.names[i] = STR['editor.list.prop.' .. M.prop.keys[i]]
end

for i = 1, #M.log.keys do
    M.log.names[i] = STR['editor.list.log.' .. M.log.keys[i]]
end

for i = 1, #M.device.keys do
    M.device.names[i] = STR['editor.list.device.' .. M.device.keys[i]]
end

return M

local M = {}

M.fun = {
    names = {},
    keys = {
        'key', 'get_text', 'random_str', 'tonumber', 'tostring', 'gsub',
        'sub', 'len', 'find', 'match', 'color_pixel', 'unix_time'
    }
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
    keys = {'true', 'false', '~=', '>', '<', '>=', '<=', 'and', 'or', 'not'}
}

M.device = {
    names = {},
    keys = {
        'fps', 'device_id', 'width_screen', 'height_screen', 'top_point_screen', 'bottom_point_screen', 'right_point_screen',
        'left_point_screen', 'height_top', 'height_bottom', 'finger_touching_screen', 'finger_touching_screen_x', 'finger_touching_screen_y'
    }
}

M.set = function(key, name)
    if (key == 'f' or key == 'm' or key == 'p' or name == 'finger_touching_screen_x' or name == 'finger_touching_screen_y') and name ~= 'unix_time' then
        EDITOR.cursor[1] = EDITOR.cursor[1] + 2
        table.insert(EDITOR.data, EDITOR.cursor[1] - 2, {'(', 's'})

        if name == 'gsub' or name == 'sub' then
            EDITOR.cursor[1] = EDITOR.cursor[1] + 2
            table.insert(EDITOR.data, EDITOR.cursor[1] - 3, {',', 's'})
            table.insert(EDITOR.data, EDITOR.cursor[1] - 2, {',', 's'})
        elseif name == 'find' or name == 'match' or name == 'color_pixel' then
            EDITOR.cursor[1] = EDITOR.cursor[1] + 1
            table.insert(EDITOR.data, EDITOR.cursor[1] - 2, {',', 's'})
        end

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

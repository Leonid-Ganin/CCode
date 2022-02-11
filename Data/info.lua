local M = {}

M.listType = {
    'everyone',
    'events',
    'vars',
    'control',
    'none',
    'none',
    'none',
    'none',
    'none',
    'none',
    'none',
    'none',
    'none',
    'none',
    'none',
    'none',
    'none',
    'none',
    'none',
    'none'
}

M.listBlock = {
    ['events'] = {
        'onStart',
    },

    ['vars'] = {
        'setVar',
        'newText',
    },

    ['control'] = {
        'requestApi',
        'ifEnd',
        'if',
        'forEnd',
        'for',
    }
}

M.listName = {
    -- events
    ['onStart'] = {'events', 'text'},

    -- vars
    ['setVar'] = {'vars', 'var', 'value'},
    ['newText'] = {'vars', 'value', 'value', 'value', 'value', 'value', 'value'},

    -- control
    ['requestApi'] = {'control', 'text'},
    ['if'] = {'control', 'value'},
    ['ifEnd'] = {'control'},
    ['for'] = {'control', 'value'},
    ['forEnd'] = {'control'},
}

M.listNested = {
    ['if'] = {'ifEnd'},
    ['for'] = {'forEnd'},
}

M.listBlock.everyone = {}

for k in pairs(M.listName) do
    table.insert(M.listBlock.everyone, k)
end

M.getType = function(name)
    return M.listName[name][1]
end

M.getBlockColor = function(name, comment, type)
    local type = type or M.getType(name)
    if comment or type == 'none' then return 0.6 end

    if type == 'events' then
        return 0.1, 0.6, 0.65
    elseif type == 'vars' then
        return 0.75, 0.6, 0.3
    elseif type == 'control' then
        return 0.6, 0.55, 0.4
    elseif type == 'everyone' then
        return 0.15, 0.55, 0.4
    end
end

return M

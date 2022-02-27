local M = {}

M.listType = {
    'everyone',
    'events',
    'vars',
    'objects',
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
    'none'
}

M.listBlock = {
    ['events'] = {
        'onStart'
    },

    ['vars'] = {
        'setVar',
        'updVar',
        'newText',
        'newText2',
        'setTextPos',
        'setTextPosX',
        'setTextPosY',
        'setTextRotation',
        'setTextAlpha',
        'updTextPosX',
        'updTextPosY',
        'updTextRotation',
        'updTextAlpha'
    },

    ['objects'] = {
        'newObject',
        'setPos',
        'setPosX',
        'setPosY',
        'setSize',
        'setRotation',
        'setAlpha',
        'setWidth',
        'setHeight',
        'updPosX',
        'updPosY',
        'updSize',
        'updRotation',
        'updAlpha',
        'updWidth',
        'updHeight'
    },

    ['control'] = {
        'requestApi',
        'ifEnd',
        'if',
        'forEnd',
        'for'
    }
}

M.listName = {
    -- events
    ['onStart'] = {'events', 'text'},

    -- vars
    ['setVar'] = {'vars', 'var', 'value'},
    ['updVar'] = {'vars', 'var', 'value'},
    ['newText'] = {'vars', 'value', 'value', 'value', 'value', 'color', 'value', 'value', 'value'},
    ['newText2'] = {'vars', 'value', 'value', 'value', 'value', 'color', 'value', 'value', 'value', 'value', 'value'},
    ['setTextPos'] = {'vars', 'value', 'value', 'value'},
    ['setTextPosX'] = {'vars', 'value', 'value'},
    ['setTextPosY'] = {'vars', 'value', 'value'},
    ['setTextRotation'] = {'vars', 'value', 'value'},
    ['setTextAlpha'] = {'vars', 'value', 'value'},
    ['updTextPosX'] = {'vars', 'value', 'value'},
    ['updTextPosY'] = {'vars', 'value', 'value'},
    ['updTextRotation'] = {'vars', 'value', 'value'},
    ['updTextAlpha'] = {'vars', 'value', 'value'},

    -- objects
    ['newObject'] = {'objects', 'value', 'value', 'value', 'value'},
    ['setPos'] = {'objects', 'value', 'value', 'value'},
    ['setPosX'] = {'objects', 'value', 'value'},
    ['setPosY'] = {'objects', 'value', 'value'},
    ['setSize'] = {'objects', 'value', 'value'},
    ['setRotation'] = {'objects', 'value', 'value'},
    ['setAlpha'] = {'objects', 'value', 'value'},
    ['setWidth'] = {'objects', 'value', 'value'},
    ['setHeight'] = {'objects', 'value', 'value'},
    ['updPosX'] = {'objects', 'value', 'value'},
    ['updPosY'] = {'objects', 'value', 'value'},
    ['updSize'] = {'objects', 'value', 'value'},
    ['updRotation'] = {'objects', 'value', 'value'},
    ['updAlpha'] = {'objects', 'value', 'value'},
    ['updWidth'] = {'objects', 'value', 'value'},
    ['updHeight'] = {'objects', 'value', 'value'},

    -- control
    ['requestApi'] = {'control', 'text'},
    ['if'] = {'control', 'value'},
    ['ifEnd'] = {'control'},
    ['for'] = {'control', 'value'},
    ['forEnd'] = {'control'}
}

M.listNested = {
    ['if'] = {'ifEnd'},
    ['for'] = {'forEnd'}
}

M.listBlock.everyone = {'onStart', 'newObject', 'setPos', 'setSize', 'setVar', 'updVar', 'newText', 'newText2', 'setTextPos'}
M.listBlock._everyone = 'onStart, newObject, setPos, setSize, setVar, updVar, newText, newText2, setTextPos'

for k in pairs(M.listName) do
    if UTF8.sub(k, UTF8.len(k) - 2, UTF8.len(k)) ~= 'End'and k ~= 'setTextPos' and not UTF8.find(M.listBlock._everyone, k .. ', ') then
        table.insert(M.listBlock.everyone, k)
    end
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
    elseif type == 'objects' then
        return 0.41, 0.68, 0.3
    elseif type == 'control' then
        return 0.6, 0.55, 0.4
    elseif type == 'everyone' then
        return 0.15, 0.55, 0.4
    end
end

return M

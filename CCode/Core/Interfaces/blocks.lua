local listeners = {}
local INPUT = require 'Core.Modules.interface-input'
local LIST = require 'Core.Modules.interface-list'
local MOVE = require 'Core.Modules.logic-move'

listeners.but_add = function(target)
end

listeners.but_play = function(target)
end

listeners.but_list = function(target)
    if #BLOCKS.group.blocks == 0 then
        local list = {STR['button.remove'], STR['button.rename'], STR['button.copy']}
    end
end

listeners.but_okay = function(target)
    ALERT = true

    if INDEX_LIST == 1 then
    end
end

return function(e)
    if BLOCKS.group.isVisible and (ALERT or e.target.button == 'but_okay') then
        if e.phase == 'began' then
            display.getCurrentStage():setFocus(e.target)
            e.target.click = true
            if e.target.button == 'but_list'
            then e.target.width, e.target.height = 103 / 1.2, 84 / 1.2
            else e.target.alpha = 0.6 end
        elseif e.phase == 'moved' and (math.abs(e.x - e.xStart) > 30 or math.abs(e.y - e.yStart) > 30) then
            e.target.click = false
            if e.target.button == 'but_list'
            then e.target.width, e.target.height = 103, 84
            else e.target.alpha = 0.9 end
        elseif e.phase == 'ended' or e.phase == 'cancelled' then
            display.getCurrentStage():setFocus(nil)
            if e.target.click then
                e.target.click = false
                if e.target.button == 'but_list'
                then e.target.width, e.target.height = 103, 84
                else e.target.alpha = 0.9 end
                listeners[e.target.button](e.target)
            end
        end
        return true
    end
end

local listeners = {}

listeners.programs = function()
    PROGRAMS.group.isVisible = false
    MENU.group.isVisible = true
end

Runtime:addEventListener('key', function(event)
    if (event.keyName == 'back' or event.keyName == 'escape') and event.phase == 'up' then
        if PROGRAMS and PROGRAMS.group and PROGRAMS.group.isVisible then
            listeners.programs()
        end
    end
end)

return true

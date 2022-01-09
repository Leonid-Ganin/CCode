local M = {}

M.new = function(e, scroll, group, type)
    if #group.blocks > 1 then
        ALERT = false
        scroll:setIsLocked(true, 'vertical')
        M.index = e.target.getIndex(e.target)
        M.data = GET_GAME_CODE(CURRENT_LINK)
        M.diffY = scroll.y - scroll.height / 2

        e.target.alpha = 1
        e.target.x = e.target.x + 40
        e.target.text.x = e.target.text.x + 40
        e.target.container.x = e.target.container.x + 40
        e.target.checkbox.x = e.target.checkbox.x + 40
    end
end

M.upd = function(e, scroll, group, type)
    if #group.blocks > 1 then
        local scrollY = select(2, scroll:getContentPosition())

        e.target.y = e.y - scrollY - M.diffY
        e.target.text.y = e.y - scrollY - M.diffY
        e.target.container.y = e.y - scrollY - M.diffY
        e.target.checkbox.y = e.y - scrollY - M.diffY

        e.target:toFront()
        e.target.text:toFront()
        e.target.container:toFront()
        e.target.checkbox:toFront()

        if e.y > group[4].y - 150 and (math.abs(scrollY) < 150 * (#group.data) - scroll.height + 50 or scrollY > 0) then
            scroll:scrollToPosition({y = scrollY - 15, time = 0})
        elseif e.y < group[3].y + 150 and scrollY < 0 then
            scroll:scrollToPosition({y = scrollY + 15, time = 0})
        end

        if e.target.y - group.data[M.index].y > 150 then
            if group.data[M.index + 1] then
                local diffY = math.round((e.target.y - group.data[M.index].y) / 150)
                local x, y, text = group.data[M.index].x, group.data[M.index].y, group.data[M.index].text
                local script = M.data.scripts[M.index]
                local image = M.data.resources.images[M.index]
                local sound = M.data.resources.sounds[M.index]
                local video = M.data.resources.videos[M.index]
                local font = M.data.resources.fonts[M.index]

                if not diffY then
                    diffY = math.round((e.target.y - group.data[M.index].y) / 150)
                end

                if M.index + diffY > #group.data then
                    diffY = #group.data - M.index
                end

                for i = 1, diffY do
                    group.blocks[M.index + i].y = group.blocks[M.index + i].y - 150
                    group.blocks[M.index + i].text.y = group.blocks[M.index + i].text.y - 150
                    group.blocks[M.index + i].container.y = group.blocks[M.index + i].container.y - 150
                    group.blocks[M.index + i].checkbox.y = group.blocks[M.index + i].checkbox.y - 150
                    group.data[M.index + i].y = group.blocks[M.index + i].y
                end

                if type == 'scripts' then table.remove(M.data.scripts, M.index) end
                if type == 'images' then table.remove(M.data.resources.images, M.index) end
                if type == 'sounds' then table.remove(M.data.resources.sounds, M.index) end
                if type == 'videos' then table.remove(M.data.resources.videos, M.index) end
                if type == 'fonts' then table.remove(M.data.resources.fonts, M.index) end
                table.remove(group.data, M.index)

                M.index = M.index + diffY
                table.insert(group.blocks, M.index + 1, e.target)
                table.remove(group.blocks, M.index - diffY)

                if type == 'scripts' then table.insert(M.data.scripts, M.index, script) end
                if type == 'images' then table.insert(M.data.resources.images, M.index, image) end
                if type == 'sounds' then table.insert(M.data.resources.sounds, M.index, image) end
                if type == 'videos' then table.insert(M.data.resources.videos, M.index, image) end
                if type == 'fonts' then table.insert(M.data.resources.fonts, M.index, image) end
                table.insert(group.data, M.index, {x = x, y = group.data[M.index - 1].y + 150, text = text})
            end
        elseif group.data[M.index].y - e.target.y > 150 then
            if group.data[M.index - 1] then
                local diffY = math.round((group.data[M.index].y - e.target.y) / 150)
                local x, y, text = group.data[M.index].x, group.data[M.index].y, group.data[M.index].text
                local script = M.data.scripts[M.index]
                local image = M.data.resources.images[M.index]
                local sound = M.data.resources.sounds[M.index]
                local video = M.data.resources.videos[M.index]
                local font = M.data.resources.fonts[M.index]

                if not diffY then
                    diffY = math.round((group.data[M.index].y - e.target.y) / 150)
                end

                if M.index - diffY < 1 then
                    diffY = M.index - 1
                end

                for i = 1, diffY do
                    group.blocks[M.index - i].y = group.blocks[M.index - i].y + 150
                    group.blocks[M.index - i].text.y = group.blocks[M.index - i].text.y + 150
                    group.blocks[M.index - i].container.y = group.blocks[M.index - i].container.y + 150
                    group.blocks[M.index - i].checkbox.y = group.blocks[M.index - i].checkbox.y + 150
                    group.data[M.index - i].y = group.blocks[M.index - i].y
                end

                if type == 'scripts' then table.remove(M.data.scripts, M.index) end
                if type == 'images' then table.remove(M.data.resources.images, M.index) end
                if type == 'sounds' then table.remove(M.data.resources.sounds, M.index) end
                if type == 'videos' then table.remove(M.data.resources.videos, M.index) end
                if type == 'fonts' then table.remove(M.data.resources.fonts, M.index) end
                table.remove(group.data, M.index)

                M.index = M.index - diffY
                table.insert(group.blocks, M.index, e.target)
                table.remove(group.blocks, M.index + diffY + 1)

                if type == 'scripts' then table.insert(M.data.scripts, M.index, script) end
                if type == 'images' then table.insert(M.data.resources.images, M.index, image) end
                if type == 'sounds' then table.insert(M.data.resources.sounds, M.index, image) end
                if type == 'videos' then table.insert(M.data.resources.videos, M.index, image) end
                if type == 'fonts' then table.insert(M.data.resources.fonts, M.index, image) end
                table.insert(group.data, M.index, {x = x, y = M.index == 1 and 75 or group.data[M.index - 1].y + 150, text = text})
            end
        end
    end
end

M.stop = function(e, scroll, group, type)
    if #group.blocks > 1 then
        ALERT = true
        scroll:setIsLocked(false, 'vertical')
        SET_GAME_CODE(CURRENT_LINK, M.data)

        e.target.alpha = 0.9
        e.target.x = e.target.x - 40
        e.target.text.x = e.target.text.x - 40
        e.target.container.x = e.target.container.x - 40
        e.target.checkbox.x = e.target.checkbox.x - 40

        e.target.y = group.data[M.index].y
        e.target.text.y = group.data[M.index].y
        e.target.container.y = group.data[M.index].y
        e.target.checkbox.y = group.data[M.index].y
    end
end

return M

return function(params, default)
    local result = #params == 0 and ' 0' or ''

    for i = 1, #params do
        if params[i][2] == 'n' then
            result = result .. ' ' .. params[i][1]
        elseif params[i][2] == 'c' then
            result = result .. ' JSON.decode(\'' .. params[i][1] .. '\')'
        elseif params[i][2] == 'l' then
            result = result .. ' ' .. params[i][1]
            if params[i][1] == '=' then result = result .. '=' end
        elseif params[i][2] == 'd' or params[i][2] == 'f' or params[i][2] == 'm' or params[i][2] == 'p' then
            result = result .. ' ' .. params[i][1]
        elseif params[i][2] == 's' then
            if (params[i - 1] and params[i - 1][2] == 't') or (params[i + 1] and params[i + 1][2] == 't') then
                if params[i][1] == '+' then
                    result = result .. ' ..'
                end
            else
                result = result .. ' ' .. params[i][1]
            end
        elseif params[i][2] == 't' then
            params[i][1] = UTF8.gsub(params[i][1], '\'', '"')
            result = result .. ' \'' .. params[i][1] .. '\''
        elseif params[i][2] == 'vE' then
            result = result .. ' varsE[\'' .. params[i][1] .. '\']'
        elseif params[i][2] == 'vS' then
            result = result .. ' varsS[\'' .. params[i][1] .. '\']'
        elseif params[i][2] == 'vP' then
            result = result .. ' varsP[\'' .. params[i][1] .. '\']'
        end
    end

    return (#params == 0 and default) and default or UTF8.sub(result, 2, UTF8.len(result))
end

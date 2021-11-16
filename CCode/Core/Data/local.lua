local data = {}
local file = io.open(system.pathForFile('local.json', system.DocumentsDirectory), 'r')

if file then
    data = JSON.decode(file:read('*a'))
    io.close(file)
else
    local file = io.open(system.pathForFile('local.json', system.DocumentsDirectory), 'w')
    local language = system.getPreference('locale', 'language')

    data = {
        lang = language,
        last = '',
        status = false,
        first = true,
        ui = true,
        apps = {},
        repository = {}
    }

    file:write(JSON.encode(data))
    io.close(file)
end

return data

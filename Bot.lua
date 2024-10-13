local discordia = require('discordia')
local client = discordia.Client()
local json = require('json') -- Make sure you have a JSON library

local function SendEmbed(message, filePath, Title, imagepath, Link)
    local file = io.open(filePath, "r")
    local fileContent = ""

    if file then
        fileContent = file:read("*all")
        file:close()
    else
        fileContent = "Error: Could not read the memory store file."
    end

    local embed = {
        title = "**" .. Title .. "**",
        description = fileContent,
        author = {
            name = "",
        },
        color = 0x6c9db4,
    }

    if imagepath and Link then
        embed.image = { url = Link }
    end

    message:reply {
        embed = embed,
        files = imagepath and {imagepath} or nil
    }
end

-- Load commands from JSON
local function loadCommands()
    local file = io.open("commands.json", "r")
    local commands = {}

    if file then
        local content = file:read("*all")
        commands = json.decode(content)
        file:close()
    else
        print("Error: Could not read commands JSON file.")
    end

    return commands
end

-- Store the loaded commands
local commands = loadCommands()

client:on('ready', function()
    print('Logged in as ' .. client.user.username)
    client:setStatus("Coding in LUA")
end)

client:on('messageCreate', function(message)
    local content = message.content:lower()
    local command = commands[content]

    if command then
        SendEmbed(message, command.filePath, command.title, command.imagePath, command.link)
        print(content .. " has been run")
    end
end)


local file2 = io.open("token.txt", "r")
if not file2 then
    print("Error: Could not read token file.")
    return
end
local content2 = file2:read("*all")
file2:close()

client:run('Bot ' .. content2)

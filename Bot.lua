local discordia = require('discordia')
local json = require('json')
local DIC = require("discordia-interactions")
local tools = require("discordia-slash").util.tools()
local CLIENT = discordia.Client():useApplicationCommands()


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

local commands = loadCommands()

CLIENT:on('ready', function()
    print('Logged in as ' .. CLIENT.user.username)
    CLIENT:setStatus("Coding in LUA")

    local slashCommand = tools.slashCommand("help", "Get help with the bot")

    CLIENT:createGlobalApplicationCommand(slashCommand)
  
    CLIENT:info("Bot is ready and the 'hello' command has been registered!")
  
end)

CLIENT:on("slashCommand", function(interaction, command, args)
    if command.name == "help" then
        interaction:reply("Please use R? to get started with Roblox coding. For further assistance, search for Roblox coding terms.", true)
    end
end)


CLIENT:on('messageCreate', function(message)
    local content = message.content:lower()
    local command = commands[content]

    if command then
        SendEmbed(message, command.filePath, command.title, command.imagePath, command.link)
        print(content .. " has been run")
    end
end)

CLIENT:on("messageCommand", function(interaction, command, message)

  end)
  
  CLIENT:on("userCommand", function(interaction, command, member)

  end)

local file2 = io.open("token.txt", "r")
if not file2 then
    print("Error: Could not read token file.")
    return
end
local content2 = file2:read("*all")
file2:close()

CLIENT:run('Bot ' .. content2)

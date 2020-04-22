--[[----------------------------------------------

    Discord bot developed by SaturdaysHeroes.xyz

--]]----------------------------------------------
local discordia = require("discordia")
local client = discordia.Client()
_G.config = {}
_G.util = {}
_G.api = {}
_G.lang = {}
_G.languages = {}

-- Additonal extensions. 
discordia.extensions()

-- Lua modules. 
require("./modules/util.lua")(client)
require("./config.lua")(client)
require("./modules/api.lua")(client)
require("./modules/language.lua")(client)
require("./modules/commands.lua")(client)

client:on("ready", function()
    client:setGame(config.activity.." | "..client.guilds:count().." Servers")
    print("----------------------------------------------------------------------------")
    lang.RegisterLanguage("polish", "pl")
    lang.RegisterLanguage("english", "en")
end)
client:run("Bot "..config.token)
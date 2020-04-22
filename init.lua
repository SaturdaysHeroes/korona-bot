--[[----------------------------------------------

    Discord bot developed by SaturdaysHeroes.xyz

--]]----------------------------------------------
local discordia = require("discordia")
local client = discordia.Client()
_G.config = {}
_G.util = {}
_G.api = {}

-- Additonal extensions. 
discordia.extensions()

-- Config variables/tables.
config.prefix = ">"
config.token = ""
config.activity = ">help"
config.apiurl = "https://api.covid19api.com/"
config.devmode = false

-- Lua modules. 
require("./modules/util.lua")(client)
require("./modules/api.lua")(client)
require("./modules/timer.lua")(client)
require("./modules/commands.lua")(client)

client:on("ready", function()
    client:setGame(config.activity)
    print("----------------------------------------------------------------------------")
end)
client:run("Bot "..config.token)
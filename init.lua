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
config.token = "NzAyMjY5MzE0NzU3MDM0MDU1.Xp_r_Q.pdrToDCh_wL2_a2gv159NqNjw6o"
config.activity = ">help"
config.apiurl = "https://api.covid19api.com/"
config.devmode = false

-- Lua modules. 
require("./modules/util.lua")(client)
require("./modules/api.lua")(client)
require("./modules/timer.lua")(client)
require("./modules/commands.lua")(client)

client:on("ready", function()
    client:setGame(config.activity.." | "..client.guilds:count().." Serwerów")
    print("----------------------------------------------------------------------------")
end)
client:run("Bot "..config.token)
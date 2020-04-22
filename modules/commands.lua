return function(client)
    client:on("messageCreate", function(message) 
        local strContent = message.content
        local mAuthor = message.author 
        local cChannel = message.channel    
        local tblArgs = strContent:split(" ")

        if string.lower(tblArgs[1]) == config.prefix.."help" then
            message:reply { 
                embed = {
                    author = {
                        name = lang.GetPhrase("Help_Header", config.language),
                        icon_url = "https://i.imgur.com/Wtzvol9.png"
                    },
                    description = lang.GetPhrase("Help_Description", config.language),
                    fields = {
                        {
                            name = config.prefix..lang.GetPhrase("Help_ReportName", config.language), 
                            value = lang.GetPhrase("Help_ReportDesc", config.language),
                            inline = false
                        }, 
                    },
                    color = 3447003,
                    footer = {
                        text = "By SaturdaysHeroes.xyz#4859",
                        icon_url = "https://i.imgur.com/EFSYABZ.png"
                    }
                }
            }
        end

        if string.lower(tblArgs[1]) == config.prefix.."routes" then
            if not config.devmode then return end

            message:reply("Fetching...")
            api.GetRoutes(function(tblData)
                message:delete()
                if tblData == "ERROR" then message:reply("Failed to get API routes...") return end

                local a = {}
                local b = 0

                for i, v in pairs(tblData) do
                    a[b + 1] = {}
                    a[b + 1].name = v["Path"]
                    a[b + 1].value = v["Description"]
                    a[b + 1].inline = false

                    b = b + 1
                end

                message:reply { 
                    embed = {
                        author = {
                            name = "API Routes",
                            icon_url = "https://i.imgur.com/Wtzvol9.png"
                        },
                        description = "All API routes available, purely for development purposes.",
                        fields = a,
                        color = 3447003
                    }
                }
            end)
        end

        if string.lower(tblArgs[1]) == config.prefix..lang.GetPhrase("Report_Command", config.language) then 
            if tblArgs[2] == nil then message:reply(lang.GetPhrase("Report_NoCountry", config.language)) return end
            if tblArgs[3] ~= nil then strInput = string.lower(tblArgs[2]).." "..string.lower(tblArgs[3]) end

            api.GetSummary(function(tblData) 
                local strInput = string.lower(tblArgs[2])
                local strCountry, strCode = util.MatchCountry(strInput)
                local tblInfo = util.GetCountryFromSummary(strCode, tblData)

                if tblData == "ERROR" then message:reply(lang.GetPhrase("Report_Error", config.language)) return end
                if tblInfo == nil then message:reply(lang.GetPhrase("Report_NotFound", config.language)) return end

                message:reply { 
                    embed = {
                        author = {
                            name = string.format(lang.GetPhrase("Report_Header", config.language), tblInfo["Country"] == nil and "Świat" or tblInfo["Country"], os.date("%H:%M")),
                            icon_url = "https://i.imgur.com/Wtzvol9.png"
                        },
                        description = string.format(lang.GetPhrase("Report_Description", config.language), tblInfo["Country"] == nil and "Świat" or tblInfo["Country"]),
                        fields = {
                            {
                                name = "😷 "..lang.GetPhrase("Report_ActiveCases", config.language),
                                value = string.format("%s (+%s)", util.CommaNumber(tblInfo["TotalConfirmed"]), util.CommaNumber(tblInfo["NewConfirmed"])),
                                inline = true
                            }, 
                            {
                                name = "👨‍⚕️ "..lang.GetPhrase("Report_Cured", config.language),
                                value = string.format("%s (+%s)", util.CommaNumber(tblInfo["TotalRecovered"]), util.CommaNumber(tblInfo["NewRecovered"])),
                                inline = true
                            },
                            {
                                name = "💀 "..lang.GetPhrase("Report_Deaths", config.language),
                                value = string.format("%s (+%s)", util.CommaNumber(tblInfo["TotalDeaths"]), util.CommaNumber(tblInfo["NewDeaths"])),
                                inline = true
                            },
                        },
                        color = 3447003,
                        footer = {
                            text = "By SaturdaysHeroes.xyz#4859",
                            icon_url = "https://i.imgur.com/EFSYABZ.png"
                        }
                    }
                }
            end)
        end
    end)

    util.Log("init", "Loaded Commands...")
end
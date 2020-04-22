return function(client)
    client:on("messageCreate", function(message) 
        local strContent = message.content
        local uAuthor = message.author 
        local mMember = message.member
        local cChannel = message.channel    
        local tblArgs = strContent:split(" ")
        local gGuild = message.channel.guild

        if gGuild == nil then return end

        if string.lower(tblArgs[1]) == config.prefix.."help" then
            message:reply { 
                embed = {
                    author = {
                        name = lang.GetPhrase("Help_Header", lang.GetLanguage(gGuild.id)),
                        icon_url = "https://i.imgur.com/Wtzvol9.png"
                    },
                    description = lang.GetPhrase("Help_Description", lang.GetLanguage(gGuild.id)),
                    fields = {
                        {
                            name = config.prefix..lang.GetPhrase("Help_ReportName", lang.GetLanguage(gGuild.id)), 
                            value = lang.GetPhrase("Help_ReportDesc", lang.GetLanguage(gGuild.id)),
                            inline = false
                        }, 
                        {
                            name = config.prefix..lang.GetPhrase("Help_LanguageName", lang.GetLanguage(gGuild.id)),
                            value = lang.GetPhrase("Help_LanguageDesc", lang.GetLanguage(gGuild.id)), 
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

        if string.lower(tblArgs[1]) == config.prefix..lang.GetPhrase("Report_Command", lang.GetLanguage(gGuild.id)) then 
            if tblArgs[2] == nil then message:reply(lang.GetPhrase("Report_NoCountry", lang.GetLanguage(gGuild.id))) return end
            if tblArgs[3] ~= nil then strInput = string.lower(tblArgs[2]).." "..string.lower(tblArgs[3]) end

            api.GetSummary(function(tblData) 
                local strInput = string.lower(tblArgs[2])
                local strCountry, strCode = util.MatchCountry(strInput)
                local tblInfo = util.GetCountryFromSummary(strCode, tblData)

                if tblData == "ERROR" then message:reply(lang.GetPhrase("Report_Error", lang.GetLanguage(gGuild.id))) return end
                if tblInfo == nil then message:reply(lang.GetPhrase("Report_NotFound", lang.GetLanguage(gGuild.id))) return end

                message:reply { 
                    embed = {
                        author = {
                            name = string.format(lang.GetPhrase("Report_Header", lang.GetLanguage(gGuild.id)), tblInfo["Country"] == nil and "Świat" or tblInfo["Country"], os.date("%H:%M")),
                            icon_url = "https://i.imgur.com/Wtzvol9.png"
                        },
                        description = string.format(lang.GetPhrase("Report_Description", lang.GetLanguage(gGuild.id)), tblInfo["Country"] == nil and "Świat" or tblInfo["Country"]),
                        fields = {
                            {
                                name = "😷 "..lang.GetPhrase("Report_ActiveCases", lang.GetLanguage(gGuild.id)),
                                value = string.format("%s (+%s)", util.CommaNumber(tblInfo["TotalConfirmed"]), util.CommaNumber(tblInfo["NewConfirmed"])),
                                inline = true
                            }, 
                            {
                                name = "👨‍⚕️ "..lang.GetPhrase("Report_Cured", lang.GetLanguage(gGuild.id)),
                                value = string.format("%s (+%s)", util.CommaNumber(tblInfo["TotalRecovered"]), util.CommaNumber(tblInfo["NewRecovered"])),
                                inline = true
                            },
                            {
                                name = "💀 "..lang.GetPhrase("Report_Deaths", lang.GetLanguage(gGuild.id)),
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

        if string.lower(tblArgs[1]) == config.prefix.."language" then 
            if tblArgs[2] == nil then message:reply(lang.GetPhrase("Language_InvalidLanguage", lang.GetLanguage(gGuild.id))) return end
            if lang.IsValid(string.lower(tblArgs[2])) == false then message:reply(lang.GetPhrase("Language_InvalidLanguage", lang.GetLanguage(gGuild.id))) return end
            if not util.IsAdmin(mMember) then message:reply(lang.GetPhrase("Language_NoPermissions")) return end

            lang.SetSetting(gGuild.id, string.lower(tblArgs[2]))
            message:reply(lang.GetPhrase("Language_ChangedLanguage", string.lower(tblArgs[2])))
        end
    end)

    util.Log("init", "Loaded Commands...")
end
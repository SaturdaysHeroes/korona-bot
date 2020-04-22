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
                        name = "KoronaBot - Help",
                        icon_url = "https://i.imgur.com/Wtzvol9.png"
                    },
                    description = "Cześć, poniżej znajduje się lista wszystkich komend.",
                    fields = {
                        {
                            name = config.prefix.."raport [państwo]",
                            value = "Wysyła raport dotyczący podanego państwa, w tym liczbę nowych przypadków, zgonów oraz wyleczeń.\n\nPrzykład: `>raport PL`.",
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

        if string.lower(tblArgs[1]) == config.prefix.."raport" then 
            local strInput = string.lower(tblArgs[2])

            if tblArgs[2] == nil then message:reply("Proszę podać kod państwa, z którego otrzymać zebrać informacje.") return end
            if tblArgs[3] ~= nil then strInput = string.lower(tblArgs[2]).." "..string.lower(tblArgs[3]) end

            api.GetSummary(function(tblData) 
                local strCountry, strCode = util.MatchCountry(strInput)
                local tblInfo = util.GetCountryFromSummary(strCode, tblData)

                if tblData == "ERROR" then message:reply("Zbieranie informacji nie powiodło się, proszę ponowić prośbę...") return end
                if tblInfo == nil then message:reply("Nie znaleziono państwa z podanym kodem/nazwą, proszę ponowić prośbę...") return end

                message:reply { 
                    embed = {
                        author = {
                            name = string.format("Raport - %s ("..os.date("%H:%M")..")", tblInfo["Country"] == nil and "Świat" or tblInfo["Country"]),
                            icon_url = "https://i.imgur.com/Wtzvol9.png"
                        },
                        description = string.format("Raport dot. %s: aktywne przypadki, zgony, wyleczenia.", tblInfo["Country"] == nil and "Świat" or tblInfo["Country"]),
                        fields = {
                            {
                                name = "😷 Aktywne Przypadki",
                                value = string.format("%s (+%s)", util.CommaNumber(tblInfo["TotalConfirmed"]), util.CommaNumber(tblInfo["NewConfirmed"])),
                                inline = true
                            }, 
                            {
                                name = "👨‍⚕️ Wyleczenia",
                                value = string.format("%s (+%s)", util.CommaNumber(tblInfo["TotalRecovered"]), util.CommaNumber(tblInfo["NewRecovered"])),
                                inline = true
                            },
                            {
                                name = "💀 Zgony",
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
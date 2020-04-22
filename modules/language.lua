return function(client)
    local fs = require("fs")
    local json = require("json")

    function lang.RegisterLanguage(strName, strFileName)
        fs.readFile(string.format("./languages/%s.txt", strFileName), function(err, data)
            _G.languages[strName] = json.decode(data)
            util.Log("Languages", "Language "..strName.." has been registered...")
        end)
    end

    function lang.GetPhrase(strPhrase, strLanguage)
        return _G.languages[strLanguage][strPhrase] or "phrase_not_found"
    end  

    function lang.IsValid(strLanguage)
        return _G.languages[strLanguage] ~= nil and true or false 
    end

    function lang.GetSettings()
        fs.readFile("./data/settings.txt", function(err, data)
            _G.settings = json.decode(data)
            
            util.Log("Languages", "Loaded language settings...")
        end)
    end

    function lang.SetSetting(strGuild, strLanguage)
        _G.settings[strGuild] = strLanguage
        fs.writeFile("./data/settings.txt", json.encode(_G.settings))
        util.Log("Languages", "Set language for guild "..strGuild.." to "..strLanguage.."...")
    end

    function lang.GetLanguage(strGuild)
        return _G.settings[strGuild] or config.language
    end

    util.Log("init", "Loaded Timer...")
end
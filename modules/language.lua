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

    util.Log("init", "Loaded Timer...")
end
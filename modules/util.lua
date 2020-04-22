return function(client)
    local fs = require("fs")
    local json = require("json")
    local tblCountries = {}

    fs.readFile("./data/countries.json", function(err, data)
        for i, v in pairs(json.decode(data)) do 
            tblCountries[i] = v
        end
    end)

    function util.Log(strType, strMessage)
        print("["..os.date("%H:%M:%S").."] ["..string.upper(strType).."] "..strMessage)
    end

    function util.GetCountryFromSummary(strCountry, tblData)
        local intIndex = nil

        if strCountry == nil then return nil end
        
        for i, v in pairs(tblData["Countries"]) do 
            if string.lower(v["CountryCode"]) == string.lower(strCountry) then intIndex = i end
        end

        if string.lower(strCountry) == "world" then return tblData["Global"] end 

        return tblData["Countries"][intIndex]
    end 

    function util.CommaNumber(intNumber)
        local formatted = tonumber(intNumber)

        while true do  
            formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
            if (k==0) then
            break
            end
        end

        return formatted
    end

    function util.MatchCountry(strInput)
        local strCountry, strCode = nil, nil

        for i, v in pairs(tblCountries) do 
            if string.lower(strInput) == string.lower(v.code) then strCountry = v.name_en strCode = v.code end
            if string.lower(strInput) == string.lower(v.name_pl) then strCountry = v.name_en strCode = v.code end
            if string.lower(strInput) == string.lower(v.name_en) then strCountry = v.name_en strCode = v.code end
        end

        if string.lower(strInput) == "świat" then strCountry = "world" strCode = "world" end

        return strCountry, strCode
    end

    function util.IsAdmin(mMember)
        return mMember:hasPermission(0x00000008) or false
    end

    util.Log("init", "Loaded Util...")
end
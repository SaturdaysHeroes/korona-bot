return function(client)
    local json = require("json")
    local http = require("coro-http")

    -- Adding better compatability for pcall, it will be necessary for all requests. 
    function api.Request(strMethod, strURL, tblHeaders, strData)
        if strMethod == "GET" then 
            return http.request("GET", strURL, tblHeaders)
        end
    end

    function api.GetRoutes(funcCallback)
        coroutine.wrap(function()
            local headers = {
                {"accept", "application/json"}
            }
            local url = config.apiurl
            local status, res, body = pcall(api.Request, "GET", url, headers)

            if status then 
                util.Log("API", "Successfully fetched all API routes...")
                funcCallback(json.decode(body))
            else
                util.Log("API", "Unsuccessfully fetched all API routes...")
                funcCallback("ERROR")
            end
        end)() 
    end

    function api.GetLiveCases(strCountry, funcCallback)
        coroutine.wrap(function()
            local headers = {
                {"accept", "application/json"}
            }
            local url = config.apiurl.."live/country/"..string.lower(strCountry)
            local status, res, body = pcall(api.Request, "GET", url, headers)

            if status then 
                util.Log("API", "Successfully fetched all live cases...")
                funcCallback(json.decode(body))
            else
                util.Log("API", "Unsuccessfully fetched all live cases...")
                funcCallback("ERROR")
            end
        end)() 
    end

    function api.GetSummary(funcCallback)
        coroutine.wrap(function()
            local headers = {
                {"accept", "application/json"}
            }
            local url = config.apiurl.."summary"
            local status, res, body = pcall(api.Request, "GET", url, headers)

            if status then 
                util.Log("API", "Successfully fetched summary...")
                funcCallback(json.decode(body))
            else
                util.Log("API", "Unsuccessfully fetched summary...")
                funcCallback("ERROR")
            end
        end)() 
    end

    util.Log("init", "Loaded API...")
end
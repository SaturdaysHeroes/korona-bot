return function()
    config.prefix = ">"
    config.token = ""
    config.activity = ">help"
    config.apiurl = "https://api.covid19api.com/"
    config.devmode = false
    config.language = "english"
    config.channels = {
        ["405937832600010752"] = "702614908969287740"
    }

    util.Log("Init", "Loaded Config...")
end
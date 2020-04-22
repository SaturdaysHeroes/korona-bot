return function()
    config.prefix = ">"
    config.token = ""
    config.activity = ">help"
    config.apiurl = "https://api.covid19api.com/"
    config.devmode = false
    config.language = "english"

    util.Log("Init", "Loaded Config...")
end
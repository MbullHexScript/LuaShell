-- plugins/example_plugin.lua
-- Contoh plugin sederhana

-- Register command baru
dispatcher.register("date", function(args)
    -- Karena Lua tidak punya built-in date formatter yang bagus,
    -- kita delegate ke sistem
    process.exec("date", args)
end)

dispatcher.register("weather", function(args)
    term.println("Weather plugin not implemented yet!")
    term.println("This would fetch weather data from an API.")
end)

-- Hook ke startup
table.insert(_LuaShell.hooks.startup, function()
    -- term.println("[Plugin] Example plugin loaded")
end)

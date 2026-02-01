-- config.lua - User configuration
-- File ini opsional dan bisa dikustomisasi user

-- Register custom aliases
dispatcher.alias("ll", "ls -la")
dispatcher.alias("la", "ls -A")
dispatcher.alias("...", "cd ../..")

-- Custom command example
dispatcher.register("greet", function(args)
    local name = args[1] or "World"
    term.println("Hello, " .. name .. "!")
end)

-- Startup hook example
table.insert(_LuaShell.hooks.startup, function()
    -- Auto-executed saat startup
    -- term.println("Custom config loaded!")
end)

-- Command hook example (triggered before every command)
table.insert(_LuaShell.hooks.command, function(cmd, args)
    -- Log commands ke file, dll
    -- Uncomment jika ingin logging
    -- term.println("[DEBUG] Running: " .. cmd)
end)

-- Exit hook example
table.insert(_LuaShell.hooks.exit, function()
    -- Cleanup sebelum exit
    -- term.println("Cleaning up...")
end)

-- Auto-load plugins dari folder plugins/
local function load_plugins()
    if not fs.exists("lua/plugins") then
        return
    end

    local ok, plugins = pcall(fs.list_dir, "lua/plugins")
    if not ok then
        return
    end

    for i = 1, #plugins do
        local plugin = plugins[i]
        if plugin:match("%.lua$") then
            local plugin_name = plugin:gsub("%.lua$", "")
            local ok, err = pcall(function()
                require("plugins." .. plugin_name)
            end)
            if not ok then
                term.println("Failed to load plugin " .. plugin_name .. ": " .. tostring(err))
            end
        end
    end
end

load_plugins()

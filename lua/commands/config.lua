-- commands/config.lua - Config management commands

-- config reload: Reload configuration
dispatcher.register("config", function(args)
    local c = shell.colors
    local subcommand = args[1] or "help"

    if subcommand == "reload" then
        -- Reload config.lua
        term.println(c.cyan .. "Reloading configuration..." .. c.reset)

        package.loaded["config"] = nil
        local ok, err = pcall(function()
            require("config")
        end)

        if ok then
            term.println(c.green .. "Success: " .. c.reset .. "Configuration reloaded")
        else
            if string.match(err, "module 'config' not found") then
                term.println(c.yellow .. "Warning: " .. c.reset .. "config.lua not found")
            else
                term.println(c.red .. "Error: " .. c.reset .. tostring(err))
            end
        end

    elseif subcommand == "path" then
        -- Show config file paths
        term.println(c.cyan .. "Configuration files:" .. c.reset)
        term.println("")

        -- Global config
        local home = env.get("HOME") or env.get("USERPROFILE")
        if home then
            local global_config = home .. "/.luashellrc"
            if fs.exists(global_config) then
                term.println(c.green .. "✓ " .. c.reset .. global_config .. c.bright_black .. " (loaded)" .. c.reset)
            else
                term.println(c.bright_black .. "✗ " .. global_config .. " (not found)" .. c.reset)
            end
        end

        -- Local config
        local local_config = "lua/config.lua"
        if fs.exists(local_config) then
            term.println(c.green .. "✓ " .. c.reset .. local_config .. c.bright_black .. " (loaded)" .. c.reset)
        else
            term.println(c.bright_black .. "✗ " .. local_config .. " (not found)" .. c.reset)
        end

        -- Directory-specific config
        local dir_config = ".luashellrc"
        if fs.exists(dir_config) then
            term.println(c.green .. "✓ " .. c.reset .. dir_config .. c.bright_black .. " (loaded)" .. c.reset)
        else
            term.println(c.bright_black .. "✗ " .. dir_config .. " (not found)" .. c.reset)
        end

    elseif subcommand == "edit" then
        -- Open config in editor
        local editor = env.get("EDITOR") or env.get("VISUAL") or "notepad"
        local config_file = "lua/config.lua"

        if not fs.exists(config_file) then
            term.println(c.yellow .. "Warning: " .. c.reset .. config_file .. " not found")
            term.println("Create it first or edit global config: ~/.luashellrc")
            return
        end

        term.println(c.cyan .. "Opening config in " .. editor .. "..." .. c.reset)
        process.exec(editor, {config_file})

    elseif subcommand == "create" then
        -- Create default config
        local config_file = "lua/config.lua"

        if fs.exists(config_file) then
            term.println(c.yellow .. "Warning: " .. c.reset .. config_file .. " already exists")
            term.println("Use 'config edit' to modify it")
            return
        end

        local default_config = [[-- config.lua - User configuration

-- Custom aliases
dispatcher.alias("ll", "ls -la")
dispatcher.alias("...", "cd ../..")

-- Custom commands
dispatcher.register("hello", function(args)
    term.println("Hello, World!")
end)

-- Startup hook
table.insert(_LuaShell.hooks.startup, function()
    -- Auto-execute on startup
    -- term.println("Custom config loaded!")
end)
]]

        local file = io.open(config_file, "w")
        if file then
            file:write(default_config)
            file:close()
            term.println(c.green .. "Success: " .. c.reset .. "Created " .. config_file)
            term.println("Use 'config edit' to customize it")
        else
            term.println(c.red .. "Error: " .. c.reset .. "Cannot create " .. config_file)
        end

    else
        -- Help
        term.println(c.cyan .. "Config Management" .. c.reset)
        term.println("")
        term.println(c.bright_white .. "Commands:" .. c.reset)
        term.println("  " .. c.green .. "config reload" .. c.reset .. "  - Reload configuration")
        term.println("  " .. c.green .. "config path" .. c.reset .. "    - Show config file paths")
        term.println("  " .. c.green .. "config edit" .. c.reset .. "    - Edit config in $EDITOR")
        term.println("  " .. c.green .. "config create" .. c.reset .. "  - Create default config")
        term.println("")
        term.println(c.bright_black .. "Config files are loaded in this order:" .. c.reset)
        term.println("  1. ~/.luashellrc (global)")
        term.println("  2. lua/config.lua (project)")
        term.println("  3. .luashellrc (directory)")
    end
end)

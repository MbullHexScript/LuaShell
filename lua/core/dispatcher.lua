-- dispatcher.lua - Command dispatching and execution with BETTER ERRORS! ⚠️

dispatcher = {}

-- Register a built-in command
function dispatcher.register(name, handler)
    if type(handler) ~= "function" then
        error("Command handler must be a function")
    end
    _LuaShell.commands[name] = handler
end

-- Register an alias
function dispatcher.alias(name, target)
    _LuaShell.aliases[name] = target
end

-- Execute a parsed command
function dispatcher.execute(parsed)
    if not parsed then
        return true -- Empty input
    end

    local cmd = parsed.cmd
    local args = parsed.args

    -- Import colors
    local colors = shell.colors

    -- Trigger command hooks
    for _, hook in ipairs(_LuaShell.hooks.command) do
        local ok, result = pcall(hook, cmd, args)
        if not ok then
            term.println(colors.yellow .. "Warning: " .. colors.reset ..
                        "Command hook error: " .. tostring(result))
        end
    end

    -- Resolve aliases
    local resolved_cmd = _LuaShell.aliases[cmd] or cmd

    -- Check if built-in command exists
    local handler = _LuaShell.commands[resolved_cmd]

    if handler then
        -- Execute Lua command
        local ok, err = pcall(handler, args)
        if not ok then
            term.println(colors.red .. "Error: " .. colors.reset .. tostring(err))
            return false
        end
        return true
    else
        -- External command - delegate to host
        local exit_code = process.exec(resolved_cmd, args)

        if exit_code == 127 then
            -- Command not found
            term.println(colors.red .. "Error: " .. colors.reset ..
                        "command not found: " .. colors.yellow .. resolved_cmd .. colors.reset)
        elseif exit_code ~= 0 then
            -- Command failed
            term.println(colors.yellow .. "Warning: " .. colors.reset ..
                        "command exited with code " .. exit_code)
        end

        return exit_code == 0
    end
end

-- Get list of all registered commands
function dispatcher.list_commands()
    local cmds = {}
    for name, _ in pairs(_LuaShell.commands) do
        table.insert(cmds, name)
    end
    table.sort(cmds)
    return cmds
end

return dispatcher

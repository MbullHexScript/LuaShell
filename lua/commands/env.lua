-- commands/env.lua - Environment variable management

dispatcher.register("env", function(args)
    local c = shell.colors

    if #args == 0 then
        -- List all environment variables (sorted)
        local vars = env.list()
        local sorted_vars = {}

        for key, _ in pairs(vars) do
            table.insert(sorted_vars, key)
        end
        table.sort(sorted_vars)

        for _, key in ipairs(sorted_vars) do
            term.println(c.cyan .. key .. c.reset .. "=" .. vars[key])
        end
    else
        -- Show specific variable
        local var_name = args[1]
        local value = env.get(var_name)

        if value then
            term.println(c.cyan .. var_name .. c.reset .. "=" .. value)
        else
            term.println(c.yellow .. "Warning: " .. c.reset ..
                        var_name .. " is not set")
        end
    end
end)

-- setenv: Set environment variable
dispatcher.register("setenv", function(args)
    local c = shell.colors

    if #args < 2 then
        term.println(c.yellow .. "Usage: " .. c.reset .. "setenv <name> <value>")
        return
    end

    local name = args[1]
    local value = table.concat(args, " ", 2)

    env.set(name, value)
    term.println(c.green .. "Set: " .. c.reset ..
                c.cyan .. name .. c.reset .. "=" .. value)
end)

-- export: Export environment variable (bash-like)
dispatcher.register("export", function(args)
    if #args == 0 then
        -- Show all exports (same as env)
        _LuaShell.commands.env({})
        return
    end

    local c = shell.colors

    -- Parse NAME=VALUE format
    local arg = args[1]
    local name, value = arg:match("^([^=]+)=(.*)$")

    if name and value then
        env.set(name, value)
        term.println(c.green .. "Exported: " .. c.reset ..
                    c.cyan .. name .. c.reset .. "=" .. value)
    else
        term.println(c.yellow .. "Usage: " .. c.reset ..
                    "export NAME=VALUE")
    end
end)

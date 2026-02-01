-- commands/help.lua - Show available commands with COLORS! 🎨

dispatcher.register("help", function(args)
    local colors = shell.colors

    term.println(colors.bright_cyan .. colors.bold .. "LuaShell" .. colors.reset ..
                 " v" .. _LuaShell.version)
    term.println("")
    term.println(colors.bright_white .. "Built-in commands:" .. colors.reset)

    local cmds = dispatcher.list_commands()
    for _, cmd in ipairs(cmds) do
        term.println("  " .. colors.green .. cmd .. colors.reset)
    end

    term.println("")

    -- Show aliases if any
    local has_aliases = false
    for _ in pairs(_LuaShell.aliases) do
        has_aliases = true
        break
    end

    if has_aliases then
        term.println(colors.bright_white .. "Aliases:" .. colors.reset)
        local alias_list = {}
        for name, target in pairs(_LuaShell.aliases) do
            table.insert(alias_list, {name = name, target = target})
        end
        table.sort(alias_list, function(a, b) return a.name < b.name end)

        for _, alias in ipairs(alias_list) do
            term.println("  " .. colors.cyan .. alias.name .. colors.reset ..
                        " -> " .. colors.yellow .. alias.target .. colors.reset)
        end
        term.println("")
    end

    term.println(colors.bright_black .. "All other commands are passed to the system shell." .. colors.reset)
end)

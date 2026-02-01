-- commands/help.lua - Show available commands

dispatcher.register("help", function(args)
    term.println("LuaShell v" .. _LuaShell.version)
    term.println("")
    term.println("Built-in commands:")

    local cmds = dispatcher.list_commands()
    for _, cmd in ipairs(cmds) do
        term.println("  " .. cmd)
    end

    term.println("")
    term.println("All other commands are passed to the system shell.")
end)

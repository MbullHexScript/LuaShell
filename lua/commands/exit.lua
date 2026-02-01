-- commands/exit.lua - Exit the shell with STYLE! 👋

dispatcher.register("exit", function(args)
    local colors = shell.colors
    term.println(colors.bright_cyan .. "Goodbye! " .. colors.reset .. "👋")
    _LuaShell.running = false
end)

-- Alias for exit
dispatcher.register("quit", function(args)
    _LuaShell.commands.exit(args)
end)

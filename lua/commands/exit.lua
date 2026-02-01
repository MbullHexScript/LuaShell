-- commands/exit.lua - Exit the shell

dispatcher.register("exit", function(args)
    term.println("Goodbye!")
    _LuaShell.running = false
end)

-- Alias for exit
dispatcher.register("quit", function(args)
    _LuaShell.commands.exit(args)
end)

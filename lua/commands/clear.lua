-- commands/clear.lua - Clear terminal screen

dispatcher.register("clear", function(args)
    term.clear()
end)

-- Alias
dispatcher.register("cls", function(args)
    _LuaShell.commands.clear(args)
end)

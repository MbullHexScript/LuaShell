-- commands/pwd.lua - Print working directory

dispatcher.register("pwd", function(args)
    local cwd = fs.getcwd()
    term.println(cwd)
end)

-- commands/echo.lua - Print arguments to stdout

dispatcher.register("echo", function(args)
    if #args == 0 then
        term.println("")
        return
    end

    local output = table.concat(args, " ")

    -- Support basic escape sequences
    output = output:gsub("\\n", "\n")
    output = output:gsub("\\t", "\t")

    term.println(output)
end)

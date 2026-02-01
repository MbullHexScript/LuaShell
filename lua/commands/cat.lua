-- commands/cat.lua - Concatenate and print files

dispatcher.register("cat", function(args)
    local c = shell.colors

    if #args == 0 then
        term.println(c.yellow .. "Usage: " .. c.reset .. "cat <file1> [file2] ...")
        return
    end

    for _, file in ipairs(args) do
        if not fs.exists(file) then
            term.println(c.red .. "Error: " .. c.reset ..
                        "cat: " .. file .. ": No such file or directory")
        else
            -- Read and print file contents
            local f = io.open(file, "r")
            if f then
                local content = f:read("*all")
                f:close()
                term.print(content)
            else
                term.println(c.red .. "Error: " .. c.reset ..
                            "cat: " .. file .. ": Permission denied")
            end
        end
    end
end)

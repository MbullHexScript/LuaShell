-- commands/source.lua - Execute script files (.luash)

dispatcher.register("source", function(args)
    local c = shell.colors

    if #args == 0 then
        term.println(c.yellow .. "Usage: " .. c.reset .. "source <script.luash>")
        term.println("")
        term.println("Example:")
        term.println("  source startup.luash")
        term.println("  source ~/scripts/deploy.luash")
        return
    end

    local script_file = args[1]

    -- Expand environment variables in path
    script_file = script_file:gsub("%$([%w_]+)", function(var)
        return env.get(var) or ""
    end)
    script_file = script_file:gsub("%${([%w_]+)}", function(var)
        return env.get(var) or ""
    end)

    -- Expand ~ to home
    if script_file:sub(1, 1) == "~" then
        local home = env.get("HOME") or env.get("USERPROFILE")
        if home then
            script_file = home .. script_file:sub(2)
        end
    end

    -- Check if file exists
    if not fs.exists(script_file) then
        term.println(c.red .. "Error: " .. c.reset ..
                    "source: " .. script_file .. ": No such file")
        return
    end

    -- Read and execute file line by line
    local file = io.open(script_file, "r")
    if not file then
        term.println(c.red .. "Error: " .. c.reset ..
                    "source: " .. script_file .. ": Cannot read file")
        return
    end

    term.println(c.cyan .. "Executing: " .. c.reset .. script_file)

    local line_num = 0
    local errors = 0

    for line in file:lines() do
        line_num = line_num + 1

        -- Trim whitespace
        line = line:match("^%s*(.-)%s*$")

        -- Skip empty lines and comments
        if line ~= "" and not line:match("^#") and not line:match("^//") then
            -- Parse and execute command
            local parsed = parser.parse(line)
            if parsed then
                local ok = dispatcher.execute(parsed)
                if not ok then
                    errors = errors + 1
                    term.println(c.yellow .. "Warning: " .. c.reset ..
                                "Line " .. line_num .. " failed")
                end
            end
        end
    end

    file:close()

    -- Summary
    if errors == 0 then
        term.println(c.green .. "Success: " .. c.reset ..
                    "Executed " .. line_num .. " lines")
    else
        term.println(c.yellow .. "Completed with " .. errors .. " error(s)" .. c.reset)
    end
end)

-- Alias: run
dispatcher.register("run", function(args)
    _LuaShell.commands.source(args)
end)

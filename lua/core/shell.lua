-- shell.lua - Main shell loop

shell = {}

-- Get prompt string
function shell.get_prompt()
    local cwd = fs.getcwd()
    local home = env.get("HOME") or env.get("USERPROFILE") or ""

    -- Replace home with ~
    if home ~= "" and cwd:sub(1, #home) == home then
        cwd = "~" .. cwd:sub(#home + 1)
    end

    return cwd .. " $ "
end

-- Main REPL loop
function shell.run()
    term.println("LuaShell v" .. _LuaShell.version)
    term.println("Type 'help' for available commands")
    term.println("")

    while _LuaShell.running do
        local prompt = shell.get_prompt()
        local input = term.read_line(prompt)

        -- Handle EOF or interrupt
        if not input or input == "" then
            goto continue
        end

        -- Parse and execute
        local parsed = parser.parse(input)
        dispatcher.execute(parsed)

        ::continue::
    end

    -- Trigger exit hooks
    for _, hook in ipairs(_LuaShell.hooks.exit) do
        local ok, err = pcall(hook)
        if not ok then
            term.println("Exit hook error: " .. tostring(err))
        end
    end
end

return shell

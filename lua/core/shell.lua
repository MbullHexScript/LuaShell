-- shell.lua - Main shell loop with PLAIN PROMPT (NO COLORS)

shell = {}

-- ANSI Color codes (hanya untuk output, TIDAK untuk prompt)
local colors = {
    reset = "\27[0m",
    bold = "\27[1m",
    -- Foreground colors
    black = "\27[30m",
    red = "\27[31m",
    green = "\27[32m",
    yellow = "\27[33m",
    blue = "\27[34m",
    magenta = "\27[35m",
    cyan = "\27[36m",
    white = "\27[37m",
    -- Bright colors
    bright_black = "\27[90m",
    bright_red = "\27[91m",
    bright_green = "\27[92m",
    bright_yellow = "\27[93m",
    bright_blue = "\27[94m",
    bright_magenta = "\27[95m",
    bright_cyan = "\27[96m",
    bright_white = "\27[97m",
}

-- Get PLAIN prompt (NO COLORS - fixes cursor issue)
function shell.get_prompt()
    local cwd = fs.getcwd()
    local home = env.get("HOME") or env.get("USERPROFILE") or ""

    -- Replace home with ~
    if home ~= "" and cwd:sub(1, #home) == home then
        cwd = "~" .. cwd:sub(#home + 1)
    end

    -- Get username
    local user = env.get("USER") or env.get("USERNAME") or "user"

    -- PLAIN PROMPT - NO ANSI CODES
    return user .. ":" .. cwd .. " $ "
end

-- Main REPL loop
function shell.run()
    -- Welcome message MASIH BISA pakai colors (tidak masalah)
    term.println(colors.bright_cyan .. colors.bold .. "LuaShell" .. colors.reset ..
                 " v" .. _LuaShell.version)
    term.println("Type " .. colors.yellow .. "'help'" .. colors.reset ..
                 " for available commands")
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
            term.println(colors.red .. "Exit hook error: " .. colors.reset .. tostring(err))
        end
    end
end

-- Export colors untuk digunakan di commands lain
shell.colors = colors

return shell

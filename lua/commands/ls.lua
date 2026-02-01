-- commands/ls.lua - List directory contents (built-in)

dispatcher.register("ls", function(args)
    local c = shell.colors
    local path = args[1] or "."

    -- Parse flags
    local show_all = false
    local long_format = false

    for _, arg in ipairs(args) do
        if arg == "-a" or arg == "-A" then
            show_all = true
        elseif arg == "-l" then
            long_format = true
        elseif arg == "-la" or arg == "-al" then
            show_all = true
            long_format = true
        elseif not arg:match("^%-") then
            path = arg
        end
    end

    -- Check if path exists
    if not fs.exists(path) then
        term.println(c.red .. "Error: " .. c.reset ..
                    "ls: cannot access '" .. path .. "': No such file or directory")
        return
    end

    -- Check if it's a directory
    if not fs.is_dir(path) then
        -- Just print the file name if it's a file
        term.println(path)
        return
    end

    -- List directory
    local ok, files = pcall(fs.list_dir, path)
    if not ok then
        term.println(c.red .. "Error: " .. c.reset ..
                    "ls: cannot read directory '" .. path .. "'")
        return
    end

    -- Convert to table and sort
    local file_list = {}
    for i = 1, #files do
        local name = files[i]

        -- Skip hidden files if not -a
        if show_all or not name:match("^%.") then
            table.insert(file_list, name)
        end
    end

    -- Sort alphabetically
    table.sort(file_list, function(a, b)
        return a:lower() < b:lower()
    end)

    -- Print files
    if long_format then
        -- TODO: Implement long format with file sizes, dates
        for _, name in ipairs(file_list) do
            local full_path = path .. "/" .. name
            local is_dir = fs.is_dir(full_path)

            if is_dir then
                term.println(c.blue .. name .. "/" .. c.reset)
            else
                term.println(name)
            end
        end
    else
        -- Simple format
        for _, name in ipairs(file_list) do
            local full_path = path .. "/" .. name
            local is_dir = fs.is_dir(full_path)

            if is_dir then
                term.print(c.blue .. name .. "/" .. c.reset .. "  ")
            else
                term.print(name .. "  ")
            end
        end
        term.println("")
    end
end)

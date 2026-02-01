-- commands/cd.lua - Change directory with BETTER ERROR MESSAGES! ⚠️

dispatcher.register("cd", function(args)
    -- Import colors dari shell module
    local colors = shell.colors

    local target = args[1]

    if not target then
        -- No argument - go to home
        target = env.get("HOME") or env.get("USERPROFILE")
        if not target then
            term.println(colors.red .. "Error: " .. colors.reset ..
                        "cd: HOME environment variable not set")
            return
        end
    end

    -- Expand ~
    if target:sub(1, 1) == "~" then
        local home = env.get("HOME") or env.get("USERPROFILE")
        if home then
            target = home .. target:sub(2)
        else
            term.println(colors.red .. "Error: " .. colors.reset ..
                        "cd: cannot expand ~, HOME not set")
            return
        end
    end

    -- Check if path exists
    if not fs.exists(target) then
        term.println(colors.red .. "Error: " .. colors.reset ..
                    "cd: no such file or directory: " .. colors.yellow .. target .. colors.reset)
        return
    end

    -- Check if path is a directory
    if not fs.is_dir(target) then
        term.println(colors.red .. "Error: " .. colors.reset ..
                    "cd: not a directory: " .. colors.yellow .. target .. colors.reset)
        return
    end

    -- Try to change directory
    local ok, err = fs.chdir(target)
    if not ok then
        term.println(colors.red .. "Error: " .. colors.reset ..
                    "cd: " .. tostring(err))
    end
end)

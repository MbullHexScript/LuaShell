-- commands/cd.lua - Change directory

dispatcher.register("cd", function(args)
    local target = args[1]

    if not target then
        -- No argument - go to home
        target = env.get("HOME") or env.get("USERPROFILE")
        if not target then
            term.println("cd: HOME not set")
            return
        end
    end

    -- Expand ~
    if target:sub(1, 1) == "~" then
        local home = env.get("HOME") or env.get("USERPROFILE")
        if home then
            target = home .. target:sub(2)
        end
    end

    local ok, err = fs.chdir(target)
    if not ok then
        term.println("cd: " .. tostring(err))
    end
end)

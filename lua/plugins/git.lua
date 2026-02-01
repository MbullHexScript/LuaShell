-- plugins/git.lua - Comprehensive Git Integration Plugin 🔧

-- Helper: Check if we're in a git repository
local function is_git_repo()
    return fs.exists(".git")
end

-- Helper: Print error if not in git repo
local function require_git_repo()
    if not is_git_repo() then
        local c = shell.colors
        term.println(c.red .. "Error: " .. c.reset .. "not a git repository")
        return false
    end
    return true
end

-- ============================================================
-- GIT STATUS COMMANDS
-- ============================================================

-- gst: Git status (short format)
dispatcher.register("gst", function(args)
    if not require_git_repo() then return end
    process.exec("git", {"status", "--short"})
end)

-- gs: Git status (full)
dispatcher.register("gs", function(args)
    if not require_git_repo() then return end
    process.exec("git", {"status"})
end)

-- ============================================================
-- GIT LOG COMMANDS
-- ============================================================

-- glog: Git log (oneline, graph)
dispatcher.register("glog", function(args)
    if not require_git_repo() then return end
    local count = args[1] or "10"
    process.exec("git", {"log", "--oneline", "--graph", "--decorate", "-" .. count})
end)

-- gloga: Git log all branches
dispatcher.register("gloga", function(args)
    if not require_git_repo() then return end
    local count = args[1] or "10"
    process.exec("git", {"log", "--oneline", "--graph", "--decorate", "--all", "-" .. count})
end)

-- ============================================================
-- GIT ADD COMMANDS
-- ============================================================

-- ga: Git add
dispatcher.register("ga", function(args)
    if not require_git_repo() then return end

    if #args == 0 then
        local c = shell.colors
        term.println(c.yellow .. "Usage: " .. c.reset .. "ga <file>")
        term.println("  or: ga . (add all)")
        return
    end

    local git_args = {"add"}
    for _, arg in ipairs(args) do
        table.insert(git_args, arg)
    end
    process.exec("git", git_args)
end)

-- gaa: Git add all
dispatcher.register("gaa", function(args)
    if not require_git_repo() then return end
    process.exec("git", {"add", "."})
end)

-- ============================================================
-- GIT COMMIT COMMANDS
-- ============================================================

-- gc: Git commit
dispatcher.register("gc", function(args)
    if not require_git_repo() then return end

    if #args == 0 then
        local c = shell.colors
        term.println(c.yellow .. "Usage: " .. c.reset .. "gc <message>")
        return
    end

    local message = table.concat(args, " ")
    process.exec("git", {"commit", "-m", message})
end)

-- gca: Git commit amend
dispatcher.register("gca", function(args)
    if not require_git_repo() then return end

    if #args == 0 then
        process.exec("git", {"commit", "--amend", "--no-edit"})
    else
        local message = table.concat(args, " ")
        process.exec("git", {"commit", "--amend", "-m", message})
    end
end)

-- ============================================================
-- GIT PUSH/PULL COMMANDS
-- ============================================================

-- gp: Git push
dispatcher.register("gp", function(args)
    if not require_git_repo() then return end

    if #args == 0 then
        process.exec("git", {"push"})
    else
        local git_args = {"push"}
        for _, arg in ipairs(args) do
            table.insert(git_args, arg)
        end
        process.exec("git", git_args)
    end
end)

-- gpf: Git push force
dispatcher.register("gpf", function(args)
    if not require_git_repo() then return end
    process.exec("git", {"push", "--force"})
end)

-- gl: Git pull
dispatcher.register("gl", function(args)
    if not require_git_repo() then return end
    process.exec("git", {"pull"})
end)

-- ============================================================
-- GIT BRANCH COMMANDS
-- ============================================================

-- gb: Git branch
dispatcher.register("gb", function(args)
    if not require_git_repo() then return end

    if #args == 0 then
        process.exec("git", {"branch"})
    else
        local git_args = {"branch"}
        for _, arg in ipairs(args) do
            table.insert(git_args, arg)
        end
        process.exec("git", git_args)
    end
end)

-- gba: Git branch all
dispatcher.register("gba", function(args)
    if not require_git_repo() then return end
    process.exec("git", {"branch", "-a"})
end)

-- gbd: Git branch delete
dispatcher.register("gbd", function(args)
    if not require_git_repo() then return end

    if #args == 0 then
        local c = shell.colors
        term.println(c.yellow .. "Usage: " .. c.reset .. "gbd <branch>")
        return
    end

    process.exec("git", {"branch", "-d", args[1]})
end)

-- ============================================================
-- GIT CHECKOUT COMMANDS
-- ============================================================

-- gco: Git checkout
dispatcher.register("gco", function(args)
    if not require_git_repo() then return end

    if #args == 0 then
        local c = shell.colors
        term.println(c.yellow .. "Usage: " .. c.reset .. "gco <branch>")
        return
    end

    process.exec("git", {"checkout", args[1]})
end)

-- gcb: Git checkout new branch
dispatcher.register("gcb", function(args)
    if not require_git_repo() then return end

    if #args == 0 then
        local c = shell.colors
        term.println(c.yellow .. "Usage: " .. c.reset .. "gcb <new-branch>")
        return
    end

    process.exec("git", {"checkout", "-b", args[1]})
end)

-- ============================================================
-- GIT DIFF COMMANDS
-- ============================================================

-- gd: Git diff
dispatcher.register("gd", function(args)
    if not require_git_repo() then return end
    process.exec("git", {"diff"})
end)

-- gds: Git diff staged
dispatcher.register("gds", function(args)
    if not require_git_repo() then return end
    process.exec("git", {"diff", "--staged"})
end)

-- ============================================================
-- GIT STASH COMMANDS
-- ============================================================

-- gstash: Git stash
dispatcher.register("gstash", function(args)
    if not require_git_repo() then return end

    if #args == 0 then
        process.exec("git", {"stash"})
    else
        local git_args = {"stash"}
        for _, arg in ipairs(args) do
            table.insert(git_args, arg)
        end
        process.exec("git", git_args)
    end
end)

-- gstashp: Git stash pop
dispatcher.register("gstashp", function(args)
    if not require_git_repo() then return end
    process.exec("git", {"stash", "pop"})
end)

-- gstashl: Git stash list
dispatcher.register("gstashl", function(args)
    if not require_git_repo() then return end
    process.exec("git", {"stash", "list"})
end)

-- ============================================================
-- HELPER COMMANDS
-- ============================================================

-- ghelp: Show git shortcuts
dispatcher.register("ghelp", function(args)
    local c = shell.colors

    term.println(c.bright_cyan .. "Git Plugin Commands:" .. c.reset)
    term.println("")

    term.println(c.bright_white .. "Status & Log:" .. c.reset)
    term.println("  " .. c.green .. "gst" .. c.reset .. "     - git status (short)")
    term.println("  " .. c.green .. "gs" .. c.reset .. "      - git status (full)")
    term.println("  " .. c.green .. "glog" .. c.reset .. "    - git log (graph, 10 commits)")
    term.println("  " .. c.green .. "gloga" .. c.reset .. "   - git log --all")
    term.println("")

    term.println(c.bright_white .. "Add & Commit:" .. c.reset)
    term.println("  " .. c.green .. "ga" .. c.reset .. "      - git add <file>")
    term.println("  " .. c.green .. "gaa" .. c.reset .. "     - git add .")
    term.println("  " .. c.green .. "gc" .. c.reset .. "      - git commit -m <msg>")
    term.println("  " .. c.green .. "gca" .. c.reset .. "     - git commit --amend")
    term.println("")

    term.println(c.bright_white .. "Push & Pull:" .. c.reset)
    term.println("  " .. c.green .. "gp" .. c.reset .. "      - git push")
    term.println("  " .. c.green .. "gpf" .. c.reset .. "     - git push --force")
    term.println("  " .. c.green .. "gl" .. c.reset .. "      - git pull")
    term.println("")

    term.println(c.bright_white .. "Branches:" .. c.reset)
    term.println("  " .. c.green .. "gb" .. c.reset .. "      - git branch")
    term.println("  " .. c.green .. "gba" .. c.reset .. "     - git branch -a")
    term.println("  " .. c.green .. "gbd" .. c.reset .. "     - git branch -d <branch>")
    term.println("  " .. c.green .. "gco" .. c.reset .. "     - git checkout <branch>")
    term.println("  " .. c.green .. "gcb" .. c.reset .. "     - git checkout -b <new-branch>")
    term.println("")

    term.println(c.bright_white .. "Diff & Stash:" .. c.reset)
    term.println("  " .. c.green .. "gd" .. c.reset .. "      - git diff")
    term.println("  " .. c.green .. "gds" .. c.reset .. "     - git diff --staged")
    term.println("  " .. c.green .. "gstash" .. c.reset .. "  - git stash")
    term.println("  " .. c.green .. "gstashp" .. c.reset .. " - git stash pop")
    term.println("  " .. c.green .. "gstashl" .. c.reset .. " - git stash list")
end)

-- ============================================================
-- STARTUP HOOK
-- ============================================================

table.insert(_LuaShell.hooks.startup, function()
    if is_git_repo() then
        local c = shell.colors
        term.println(c.cyan .. "[Git]" .. c.reset .. " Repository detected. Type " ..
                    c.yellow .. "'ghelp'" .. c.reset .. " for git shortcuts.")
    end
end)

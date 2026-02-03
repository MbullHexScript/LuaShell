-- init.lua - Bootstrap LuaShell Lua layer with BETTER CONFIG SYSTEM
-- Dieksekusi pertama kali oleh host

-- Load path untuk modules
package.path = package.path .. ";./lua/?.lua;./lua/core/?.lua;./lua/commands/?.lua"

-- Global state
_LuaShell = {
    version = "0.4.0",
    running = true,
    commands = {},
    aliases = {},
    hooks = {
        startup = {},
        command = {},
        exit = {}
    },
    config = {}
}

-- Load core modules
require("core.parser")
require("core.dispatcher")
require("core.shell")

-- Load built-in commands
require("commands.help")
require("commands.exit")
require("commands.cd")
require("commands.pwd")
require("commands.clear")
require("commands.echo")
require("commands.cat")
require("commands.ls")
require("commands.env")
require("commands.source")  -- Script execution
require("commands.config")  -- Config management

-- ============================================================
-- MULTI-LEVEL CONFIG LOADING
-- ============================================================

local function load_config_file(path, name)
    if fs.exists(path) then
        local ok, err = pcall(function()
            dofile(path)
        end)
        if ok then
            -- term.println("Loaded: " .. name)
        else
            term.println("Warning: Error loading " .. name .. ": " .. tostring(err))
        end
        return true
    end
    return false
end

-- 1. Try load GLOBAL config (~/.luashellrc)
local home = env.get("HOME") or env.get("USERPROFILE")
if home then
    local global_config = home .. "/.luashellrc"
    load_config_file(global_config, "global config")
end

-- 2. Try load PROJECT config (lua/config.lua)
local ok, err = pcall(function()
    require("config")
end)

if not ok and not string.match(err, "module 'config' not found") then
    term.println("Warning: config.lua error: " .. tostring(err))
end

-- 3. Try load DIRECTORY config (./.luashellrc)
load_config_file(".luashellrc", "directory config")

-- ============================================================
-- STARTUP HOOKS
-- ============================================================

-- Trigger startup hooks
for _, hook in ipairs(_LuaShell.hooks.startup) do
    local ok, err = pcall(hook)
    if not ok then
        term.println("Startup hook error: " .. tostring(err))
    end
end

-- Export main loop function to host
function _LuaShell_main_loop()
    shell.run()
end

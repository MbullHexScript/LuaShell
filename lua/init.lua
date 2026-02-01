-- init.lua - Bootstrap LuaShell Lua layer
-- Dieksekusi pertama kali oleh host

-- Load path untuk modules
package.path = package.path .. ";./lua/?.lua;./lua/core/?.lua;./lua/commands/?.lua"

-- Global state
_LuaShell = {
    version = "0.1.0",
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

-- Try load config.lua if exists
local ok, err = pcall(function()
    require("config")
end)

if not ok and not string.match(err, "module 'config' not found") then
    term.println("Warning: config.lua error: " .. tostring(err))
end

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

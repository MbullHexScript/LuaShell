-- test.lua
-- Simple Lua test script

print("=== Lua Test Script ===")

-- 1. Test variable & arithmetic
local a = 10
local b = 5
print("A + B =", a + b)
print("A * B =", a * b)

-- 2. Test function
local function greet(name)
    return "Halo, " .. name .. "! Selamat datang di dunia Lua 🌙"
end

print(greet("NaufalNyaa"))

-- 3. Test table
local skills = {
    "Lua",
    "Rust",
    "Shell",
    "PowerShell"
}

print("\nSkill list:")
for i, skill in ipairs(skills) do
    print(i .. ".", skill)
end

-- 4. Test conditional
local score = 85
if score >= 75 then
    print("\nStatus: LULUS 🎉")
else
    print("\nStatus: COBA LAGI 😼")
end

-- 5. Test loop
print("\nCountdown:")
for i = 5, 1, -1 do
    print(i)
end

print("\n🚀 Lua berjalan normal. Semua aman.")

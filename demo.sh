#!/bin/bash
# demo.sh - Interactive demo of LuaShell features

echo "======================================"
echo "  LuaShell Feature Demo"
echo "======================================"
echo ""

# Check if LuaShell binary exists
if [ ! -f "target/release/LuaShell" ]; then
    echo "Building LuaShell first..."
    ./build.sh
    echo ""
fi

echo "Testing Lua layer components..."
echo ""

# Test parser
cat > /tmp/test_parser.lua << 'EOF'
package.path = package.path .. ";./lua/?.lua;./lua/core/?.lua"
require("core.parser")

-- Test 1: Simple command
local r1 = parser.parse("ls -la")
assert(r1.cmd == "ls", "Failed: simple cmd")
assert(r1.args[1] == "-la", "Failed: simple args")
print("✓ Parser test 1: Simple command")

-- Test 2: Quoted args
local r2 = parser.parse('echo "hello world"')
assert(r2.cmd == "echo", "Failed: quoted cmd")
assert(r2.args[1] == "hello world", "Failed: quoted args")
print("✓ Parser test 2: Quoted arguments")

-- Test 3: Empty input
local r3 = parser.parse("")
assert(r3 == nil, "Failed: empty input")
print("✓ Parser test 3: Empty input")

print("")
print("All parser tests passed!")
EOF

lua /tmp/test_parser.lua
echo ""

echo "======================================"
echo "Now run: ./target/release/LuaShell"
echo ""
echo "Try these commands:"
echo "  help          - Show available commands"
echo "  pwd           - Print working directory"
echo "  cd /tmp       - Change directory"
echo "  greet Alice   - Custom command from config"
echo "  ll            - Alias for ls -la"
echo "  exit          - Exit shell"
echo "======================================"

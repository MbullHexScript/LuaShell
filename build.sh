#!/bin/bash
# build.sh - Build LuaShell

set -e

echo "Building LuaShell..."
cargo build --release

echo ""
echo "✅ Build successful!"
echo ""
echo "Run with: ./target/release/LuaShell
echo "Or: cargo run --release"

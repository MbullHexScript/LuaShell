# update.ps1 - Update LuaShell ke v0.2.0
# Run: .\update.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  LuaShell Update v0.2.0" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Backup existing files
Write-Host "[1/5] Creating backup..." -ForegroundColor Yellow
$backupDir = "backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

Copy-Item -Path "Cargo.toml" -Destination "$backupDir\" -Force
Copy-Item -Path "src\lua_bindings.rs" -Destination "$backupDir\" -Force
Copy-Item -Path "lua\core\*" -Destination "$backupDir\core\" -Force -Recurse
Copy-Item -Path "lua\commands\*" -Destination "$backupDir\commands\" -Force -Recurse

Write-Host "  Backup created in: $backupDir" -ForegroundColor Green

# Step 2: Update Cargo.toml
Write-Host ""
Write-Host "[2/5] Updating Cargo.toml..." -ForegroundColor Yellow

$cargoContent = @"
[package]
name = "LuaShell"
version = "0.1.0"
edition = "2021"

[dependencies]
mlua = { version = "0.9", features = ["lua54", "vendored"] }
rustyline = "14.0"
dirs = "5.0"
"@

Set-Content -Path "Cargo.toml" -Value $cargoContent
Write-Host "  Cargo.toml updated" -ForegroundColor Green

# Step 3: Copy new Rust files
Write-Host ""
Write-Host "[3/5] Updating Rust source files..." -ForegroundColor Yellow
Write-Host "  Please manually copy lua_bindings.rs from LuaShell-Updates/" -ForegroundColor Cyan

# Step 4: Copy new Lua files
Write-Host ""
Write-Host "[4/5] Updating Lua files..." -ForegroundColor Yellow
Write-Host "  Please manually copy these files from LuaShell-Updates/:" -ForegroundColor Cyan
Write-Host "    - shell.lua -> lua/core/" -ForegroundColor White
Write-Host "    - dispatcher.lua -> lua/core/" -ForegroundColor White
Write-Host "    - cd.lua -> lua/commands/" -ForegroundColor White
Write-Host "    - help.lua -> lua/commands/" -ForegroundColor White
Write-Host "    - exit.lua -> lua/commands/" -ForegroundColor White

# Step 5: Build
Write-Host ""
Write-Host "[5/5] Ready to build" -ForegroundColor Yellow
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Copy updated files from LuaShell-Updates/" -ForegroundColor White
Write-Host "  2. Run: cargo clean" -ForegroundColor White
Write-Host "  3. Run: cargo build --release" -ForegroundColor White
Write-Host "  4. Run: .\target\release\LuaShell.exe" -ForegroundColor White
Write-Host ""
Write-Host "Backup location: $backupDir" -ForegroundColor Green
Write-Host ""
Write-Host "Update preparation complete!" -ForegroundColor Green

# install_tab_completion.ps1 - Install Tab Completion v0.3.0

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  LuaShell Tab Completion v0.3.0" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Backup
Write-Host "[1/4] Creating backup..." -ForegroundColor Yellow
$backupDir = "backup_tab_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
Copy-Item -Path "Cargo.toml" -Destination "$backupDir\" -Force
Copy-Item -Path "src\lua_bindings.rs" -Destination "$backupDir\" -Force
Write-Host "  Backup: $backupDir" -ForegroundColor Green

# Step 2: Copy files
Write-Host ""
Write-Host "[2/4] Copying updated files..." -ForegroundColor Yellow
Copy-Item -Path "LuaShell-Updates\v0.3\Cargo.toml" -Destination "." -Force
Copy-Item -Path "LuaShell-Updates\v0.3\lua_bindings.rs" -Destination "src\" -Force
Write-Host "  Files updated" -ForegroundColor Green

# Step 3: Clean build
Write-Host ""
Write-Host "[3/4] Cleaning previous build..." -ForegroundColor Yellow
cargo clean
Write-Host "  Build cleaned" -ForegroundColor Green

# Step 4: Build
Write-Host ""
Write-Host "[4/4] Building with tab completion..." -ForegroundColor Yellow
Write-Host "  This may take 1-2 minutes..." -ForegroundColor Cyan
cargo build --release

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  ✅ Tab Completion Installed!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Try it:" -ForegroundColor Cyan
    Write-Host "  .\target\release\LuaShell.exe" -ForegroundColor White
    Write-Host ""
    Write-Host "Test tab completion:" -ForegroundColor Cyan
    Write-Host "  he<Tab>       → help" -ForegroundColor White
    Write-Host "  g<Tab><Tab>   → show all g* commands" -ForegroundColor White
    Write-Host "  cd De<Tab>    → Desktop/" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "❌ Build failed!" -ForegroundColor Red
    Write-Host "Check error messages above" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Restore from backup:" -ForegroundColor Cyan
    Write-Host "  Copy-Item $backupDir\* . -Force" -ForegroundColor White
}

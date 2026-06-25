# LazyMicro — Windows Uninstaller
# Run in PowerShell: irm https://raw.githubusercontent.com/you/lazymicro/main/uninstall.ps1 | iex

$MicroCfg = "$env:APPDATA\micro"

Write-Host "`n⚠  This will delete your micro config at: $MicroCfg" -ForegroundColor Yellow
$confirm = Read-Host "Continue? [y/N]"
if ($confirm -notmatch "^[Yy]$") { Write-Host "Aborted."; exit 0 }

Remove-Item -Path $MicroCfg -Recurse -Force
Write-Host "✓ LazyMicro removed." -ForegroundColor Green

# Offer to restore latest backup
$latest = Get-Item "$env:APPDATA\micro.backup.*" -ErrorAction SilentlyContinue |
          Sort-Object LastWriteTime -Descending |
          Select-Object -First 1

if ($latest) {
    $restore = Read-Host "Restore backup from $($latest.FullName)? [y/N]"
    if ($restore -match "^[Yy]$") {
        Copy-Item -Path $latest.FullName -Destination $MicroCfg -Recurse -Force
        Write-Host "✓ Restored $($latest.FullName) → $MicroCfg" -ForegroundColor Green
    }
}

# ============================================================
#  LazyMicro — Windows 10/11 Installer (PowerShell)
#  Run in an ADMIN PowerShell:
#  irm https://raw.githubusercontent.com/you/lazymicro/main/install.ps1 | iex
# ============================================================

$ErrorActionPreference = "Stop"

$RawBase   = "https://raw.githubusercontent.com/you/lazymicro/main"
$MicroCfg  = "$env:APPDATA\micro"
$Backup    = "$env:APPDATA\micro.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"

$Plugins = @(
    "filemanager",   # Explorer sidebar  (Ctrl+B)
    "comment",       # Toggle comments   (Ctrl+/)
    "fzf",           # Quick Open        (Ctrl+P)
    "lsp",           # IntelliSense / go-to-def / rename
    "autofmt",       # Format on save
    "editorconfig",  # Respect .editorconfig
    "detectindent",  # Auto-detect tabs vs spaces
    "autoclose",     # Auto-close brackets & quotes
    "jump"           # Jump to definition (non-LSP fallback)
)

# ── Colours ──────────────────────────────────────────────────────────────────
function Write-Step  { param($msg) Write-Host "`n▶ $msg" -ForegroundColor Cyan }
function Write-Ok    { param($msg) Write-Host "  ✓ $msg" -ForegroundColor Green }
function Write-Warn  { param($msg) Write-Host "  ! $msg" -ForegroundColor Yellow }
function Write-Fail  { param($msg) Write-Host "  ✗ $msg" -ForegroundColor Red; exit 1 }

# ── Banner ───────────────────────────────────────────────────────────────────
Write-Host @"

  ██╗      █████╗ ███████╗██╗   ██╗
  ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝
  ██║     ███████║  ███╔╝  ╚████╔╝
  ██║     ██╔══██║ ███╔╝    ╚██╔╝
  ███████╗██║  ██║███████╗   ██║
  ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝
   ███╗   ███╗██╗ ██████╗██████╗  ██████╗
   ████╗ ████║██║██╔════╝██╔══██╗██╔═══██╗
   ██╔████╔██║██║██║     ██████╔╝██║   ██║
   ██║╚██╔╝██║██║██║     ██╔══██╗██║   ██║
   ██║ ╚═╝ ██║██║╚██████╗██║  ██║╚██████╔╝
   ╚═╝     ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝

  VS Code-style setup for micro  —  Windows 10/11

"@ -ForegroundColor Blue

# ── 1. Install micro if not present ──────────────────────────────────────────
Write-Step "Checking for micro"

if (-not (Get-Command micro -ErrorAction SilentlyContinue)) {
    Write-Warn "micro not found. Attempting to install..."

    # Try winget first (built into Win 10 2004+)
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install --id zyedidia.micro -e --silent
        Write-Ok "Installed via winget"
    }
    # Fall back to Scoop
    elseif (Get-Command scoop -ErrorAction SilentlyContinue) {
        scoop install micro
        Write-Ok "Installed via Scoop"
    }
    # Fall back to Chocolatey
    elseif (Get-Command choco -ErrorAction SilentlyContinue) {
        choco install micro -y
        Write-Ok "Installed via Chocolatey"
    }
    # Manual download from GitHub releases
    else {
        Write-Warn "No package manager found. Downloading micro directly..."
        $rel  = "https://api.github.com/repos/zyedidia/micro/releases/latest"
        $tag  = (Invoke-RestMethod $rel).tag_name
        $ver  = $tag.TrimStart("v")
        $url  = "https://github.com/zyedidia/micro/releases/download/$tag/micro-$ver-win64.zip"
        $zip  = "$env:TEMP\micro.zip"
        $dest = "$env:LOCALAPPDATA\Programs\micro"

        Invoke-WebRequest $url -OutFile $zip
        Expand-Archive -Path $zip -DestinationPath $dest -Force
        $env:PATH += ";$dest"
        # Persist PATH for the user
        [Environment]::SetEnvironmentVariable(
            "PATH",
            [Environment]::GetEnvironmentVariable("PATH","User") + ";$dest",
            "User"
        )
        Write-Ok "Installed to $dest and added to user PATH"
    }

    if (-not (Get-Command micro -ErrorAction SilentlyContinue)) {
        Write-Fail "micro still not found. Restart your terminal or add it to PATH manually."
    }
} else {
    Write-Ok "micro found: $(micro --version 2>&1 | Select-Object -First 1)"
}

# ── 2. Check for recommended tools ───────────────────────────────────────────
Write-Step "Checking optional tools"

foreach ($tool in @("fzf", "rg")) {
    if (Get-Command $tool -ErrorAction SilentlyContinue) {
        Write-Ok "$tool found"
    } else {
        Write-Warn "$tool not found — install via: winget install $( if($tool -eq 'fzf'){'junegunn.fzf'}else{'BurntSushi.ripgrep.MSVC'} )"
    }
}

# ── 3. Backup existing config ─────────────────────────────────────────────────
Write-Step "Backing up existing config"

if (Test-Path $MicroCfg) {
    Copy-Item -Path $MicroCfg -Destination $Backup -Recurse -Force
    Write-Ok "Backed up to $Backup"
} else {
    Write-Ok "No existing config — fresh install"
}

# ── 4. Download LazyMicro config files ───────────────────────────────────────
Write-Step "Downloading LazyMicro"

$files = @(
    "settings.json",
    "bindings.json",
    "init.lua"
)

New-Item -ItemType Directory -Force -Path $MicroCfg | Out-Null
New-Item -ItemType Directory -Force -Path "$MicroCfg\colorschemes" | Out-Null

foreach ($f in $files) {
    $url  = "$RawBase/$f"
    $dest = "$MicroCfg\$f"
    Invoke-WebRequest $url -OutFile $dest
    Write-Ok "Downloaded $f"
}

Invoke-WebRequest "$RawBase/colorschemes/vscode-dark.micro" `
    -OutFile "$MicroCfg\colorschemes\vscode-dark.micro"
Write-Ok "Downloaded colorschemes\vscode-dark.micro"

# ── 5. Install plugins ────────────────────────────────────────────────────────
Write-Step "Installing plugins"

foreach ($plugin in $Plugins) {
    $installed = & micro -plugin list 2>$null
    if ($installed -match "^$plugin") {
        Write-Ok "$plugin already installed"
    } else {
        Write-Host "  Installing $plugin..." -NoNewline
        try {
            & micro -plugin install $plugin 2>$null
            Write-Host " ✓" -ForegroundColor Green
        } catch {
            Write-Host " skipped (not in registry)" -ForegroundColor Yellow
        }
    }
}

# ── Done ─────────────────────────────────────────────────────────────────────
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "  LazyMicro installed successfully!" -ForegroundColor White
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Green

Write-Host "  Run " -NoNewline
Write-Host "micro <file>" -ForegroundColor Cyan -NoNewline
Write-Host " in Windows Terminal to start.`n"

Write-Host "  Quick reference:"
Write-Host "   Ctrl+B        " -ForegroundColor Cyan -NoNewline; Write-Host "Toggle file explorer"
Write-Host "   Ctrl+P        " -ForegroundColor Cyan -NoNewline; Write-Host "Quick open (fuzzy file search)"
Write-Host "   Ctrl+Shift+P  " -ForegroundColor Cyan -NoNewline; Write-Host "Command palette"
Write-Host "   Ctrl+/        " -ForegroundColor Cyan -NoNewline; Write-Host "Toggle line comment"
Write-Host "   F2            " -ForegroundColor Cyan -NoNewline; Write-Host "LSP rename symbol"
Write-Host "   F12           " -ForegroundColor Cyan -NoNewline; Write-Host "LSP go to definition"
Write-Host "   Ctrl+\`        " -ForegroundColor Cyan -NoNewline; Write-Host "Integrated terminal (PowerShell)`n"

Write-Host "  Tip: Use Windows Terminal + Cascadia Code NF for the best experience.`n" -ForegroundColor Yellow

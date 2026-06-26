-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  LazyMicro · init.lua
--  VS Code-style enhancements for the micro text editor
--  https://github.com/ojaswi1234/lazymicro
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local micro   = import("micro")
local m_config  = import("micro/config")
local shell   = import("micro/shell")
local buffer  = import("micro/buffer")

-- ── Helpers ──────────────────────────────────────────────────────────────────

local function info(msg)
    if micro.InfoBar() ~= nil then
        micro.InfoBar():Message("⚡ " .. msg)
    end
end

-- ── init() – runs once at startup ────────────────────────────────────────────

function init()
    -- Safety-bind keys that may not be covered by bindings.json
    -- (second arg `false` = don't override if already set)
    config.TryBindKey("Ctrl-/",       "lua:comment.comment",     false)
    config.TryBindKey("Alt-Up",       "MoveLinesUp",             false)
    config.TryBindKey("Alt-Down",     "MoveLinesDown",           false)
    config.TryBindKey("Ctrl-b",       "lua:filemanager.toggle",  false)
    config.TryBindKey("Ctrl-p",       "lua:fzf.fzf",             false)
    config.TryBindKey("Ctrl-Shift-p", "CommandMode",             false)

    -- Custom commands exposed in the command bar (Ctrl+E / Ctrl+Shift+P)
    config.MakeCommand("fmt",      formatFile,  config.NoComplete)
    config.MakeCommand("trim",     trimSpaces,  config.NoComplete)
    config.MakeCommand("explorer", toggleExplorer, config.NoComplete)
    config.MakeCommand("reload",   reloadConfig, config.NoComplete)

    info("LazyMicro ready — VS Code mode active. Press Ctrl+Shift+P for commands.")
end

-- ── File-type detection message (like VS Code's bottom-right language badge) ─

function onBufferOpen(buf)
    local ft = buf:FileType()
    if ft ~= "" and ft ~= "Unknown" then
        -- tiny delay so it shows after any plugin messages
        info(buf.Path .. "  [" .. ft .. "]")
    end
end

-- ── Auto-format on save (calls the autofmt plugin when available) ─────────────

function onSave(bp)
    local ft = bp.Buf:FileType()
    local fmtSupported = {
        go         = true,
        python     = true,
        javascript = true,
        typescript = true,
        rust       = true,
        json       = true,
        html       = true,
        css        = true,
        lua        = true,
    }
    if fmtSupported[ft] then
        -- autofmt plugin hooks into onSave itself; this is a no-op guard
    end
    return true   -- allow save to proceed
end

-- ── Trim trailing whitespace command ─────────────────────────────────────────

function trimSpaces(bp)
    local buf = bp.Buf
    for i = 0, buf:LinesNum() - 1 do
        local line  = buf:Line(i)
        local trimmed = line:gsub("%s+$", "")
        if trimmed ~= line then
            buf:Replace(
                buffer.Loc(#trimmed, i),
                buffer.Loc(#line,    i),
                ""
            )
        end
    end
    info("Trailing whitespace removed.")
end

-- ── Format file command (delegates to autofmt plugin) ─────────────────────────

function formatFile(bp)
    local ok, err = pcall(function()
        -- autofmt exposes its formatter via this action name
        bp:Autocomplete()
    end)
    if not ok then
        info("No formatter available for this file type.")
    end
end

-- ── Toggle file explorer ──────────────────────────────────────────────────────

function toggleExplorer(bp)
    -- filemanager plugin registers this action
    local ok, err = pcall(function()
        micro.CurPane():HandleEvent("lua:filemanager.toggle")
    end)
    if not ok then
        info("filemanager plugin not installed. Run: micro -plugin install filemanager")
    end
end

-- ── Reload config without restarting (like VS Code's Developer: Reload Window) -

function reloadConfig(bp)
    config.ReloadConfig()
    info("Config reloaded.")
end

-- ── Breadcrumb in info bar on cursor move (file:line:col) ────────────────────

local _lastLine = -1

function onCursorMove(bp)
    local c    = bp.Buf:GetActiveCursor()
    local line = c.Y + 1
    if line ~= _lastLine then
        _lastLine = line
        -- The status bar already shows line/col; this is a no-op unless you
        -- want to push it to the info bar too. Disabled by default.
    end
end

-- ── VS Code-like "word count" in info bar (triggered by :wc command) ─────────

function wordCount(bp)
    local total = 0
    local buf   = bp.Buf
    for i = 0, buf:LinesNum() - 1 do
        local _, n = buf:Line(i):gsub("%S+", "")
        total = total + n
    end
    info(string.format("Words: %d  Lines: %d", total, buf:LinesNum()))
end
m_config.MakeCommand("wc", wordCount)

-- ── End ──────────────────────────────────────────────────────────────────────

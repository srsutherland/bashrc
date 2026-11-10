# profile.ps1 -- Windows PowerShell 5.1 and PowerShell 7
# Keep this file ASCII-only: 5.1 reads BOM-less files as ANSI.

# ---------------------------------------------------------------------------
# Elevation check
# ---------------------------------------------------------------------------
$global:__IsAdmin = $false
try {
    $__id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $global:__IsAdmin = (New-Object Security.Principal.WindowsPrincipal $__id).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator)
} catch { }

# ---------------------------------------------------------------------------
# Line editing (PSReadLine, console host only)
# ---------------------------------------------------------------------------
if ($Host.Name -eq 'ConsoleHost') {
    Import-Module PSReadLine -ErrorAction SilentlyContinue
    $__psrl = Get-Module PSReadLine
}
if ($__psrl) {
    Set-PSReadLineKeyHandler -Key Tab       -Function MenuComplete
    # Up/Down search history for lines starting with what's already typed
    Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    # Prompt below is two lines; lets PSReadLine redraw it correctly
    Set-PSReadLineOption -ExtraPromptLineCount 1
    # Part of the prompt PSReadLine turns red on a syntax error
    Set-PSReadLineOption -PromptText $(if ($__IsAdmin) { '# ' } else { '> ' })

    # PSReadLine 2.0.0 (bundled with 5.1) writes every line to the history file.
    # 2.0.4+ skips lines with these words by default; replicate that on older versions.
    # (On 2.0.0, a skipped line is also left out of Up-arrow history for the session.)
    if ($__psrl.Version -lt [version]'2.0.4') {
        Set-PSReadLineOption -AddToHistoryHandler {
            param([string]$line)
            $line -notmatch 'password|asplaintext|token|apikey|secret'
        }
    }
}

# ---------------------------------------------------------------------------
# Navigation
# ---------------------------------------------------------------------------
# cd.. is built in; these go further up
function cd...  { Set-Location ..\.. }
function cd.... { Set-Location ..\..\.. }

# Downloads, honoring folder redirection
function cdd {
    $ddir = (Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' `
          -ErrorAction SilentlyContinue).'{374DE290-123F-4565-9164-39C4925E467B}'
    if (-not $ddir) { $ddir = "$HOME\Downloads" }
    Set-Location -LiteralPath $ddir
}

# ---------------------------------------------------------------------------
# Hashes
# ---------------------------------------------------------------------------
function md5    { Get-FileHash -Algorithm MD5    @args }
function sha1   { Get-FileHash -Algorithm SHA1   @args }
function sha256 { Get-FileHash -Algorithm SHA256 @args }

# ---------------------------------------------------------------------------
# Elevation (skipped entirely when the built-in sudo.exe is installed)
#   admin            -> new elevated shell in the current folder
#   admin <command>  -> run <command> elevated; window stays open
# Uses the same shell that's running (powershell.exe or pwsh.exe).
# Args containing spaces are single-quoted; avoid double quotes in <command>.
# ---------------------------------------------------------------------------
$__builtinSudo = Get-Command sudo.exe -CommandType Application -ErrorAction SilentlyContinue
if (-not $__builtinSudo) {
    function global:admin {
        $exe = (Get-Process -Id $PID).Path
        $cmd = ''
        if ($PWD.Provider.Name -eq 'FileSystem') {
            $cmd = "Set-Location -LiteralPath '$($PWD.ProviderPath -replace "'", "''")'; "
        }
        if ($args.Count -gt 0) {
            $cmd += ($args | ForEach-Object {
                $a = "$_"
                if ($a -match '\s') { "'" + ($a -replace "'", "''") + "'" } else { $a }
            }) -join ' '
        }
        $argList = @('-NoExit')
        if ($cmd) { $argList += '-Command', $cmd }
        Start-Process $exe -Verb RunAs -ArgumentList $argList
    }
    Set-Alias -Name su   -Value admin -Scope Global
    Set-Alias -Name sudo -Value admin -Scope Global
}

# ---------------------------------------------------------------------------
# Prompt
#   [HH:mm:ss]  ADMIN  DOMAIN\user@HOST ~\path (branch) [failed] [3.2s]
#   >                                   ('#' when elevated)
# ---------------------------------------------------------------------------

function Write-PromptText {
    param(
        [Parameter(Position = 0)] [Alias('text')]  $Object,
        [Alias('color')] [ConsoleColor] $ForegroundColor
    )
    Write-Host -NoNewline @PSBoundParameters
}

# Replace control characters (ESC, BEL, etc.) so a crafted folder or branch
# name can't inject terminal escape sequences into the prompt.
function Format-SafeCtrlChars([string]$s) { $s -replace '[\x00-\x1F\x7F-\x9F]', '?' }

function Get-PromptPath {
    $p = $PWD.Path -replace '^Microsoft\.PowerShell\.Core\\FileSystem::', ''
    $p -replace ('^' + [regex]::Escape($HOME) + '(?=\\|$)'), '~'
}

# Current git branch read straight from .git\HEAD (no git.exe, no modules).
# Skipped on UNC paths to keep the prompt fast on network shares.
function Get-GitBranch {
    if ($PWD.Provider.Name -ne 'FileSystem') { return }
    $d = $PWD.ProviderPath
    if ($d.StartsWith('\\')) { return }
    $head = $null
    while ($d) {
        $g = Join-Path $d '.git'
        if (Test-Path -LiteralPath $g -PathType Container) { $head = Join-Path $g 'HEAD'; break }
        if (Test-Path -LiteralPath $g -PathType Leaf) {
            # worktree/submodule: .git is a file containing "gitdir: <path>"
            $gd = (Get-Content -LiteralPath $g -TotalCount 1) -replace '^gitdir:\s*', ''
            if ($gd -notmatch '^[A-Za-z]:|^\\\\|^/') { $gd = Join-Path $d $gd }
            $head = Join-Path $gd 'HEAD'; break
        }
        $d = Split-Path $d -Parent
    }
    if (-not $head -or -not (Test-Path -LiteralPath $head)) { return }
    $ref = Get-Content -LiteralPath $head -TotalCount 1
    if ($ref -match '^ref: refs/heads/(.+)$') { 
        $Matches[1] 
    }
    elseif ($ref.Length -ge 7) { # detached HEAD
        $ref.Substring(0, 7)
    }   
}

$global:__LastHistId = -1

function prompt {
    $ok   = $?  # must be first
    $code = $global:LASTEXITCODE

    # Only report status/duration once per command (not on empty Enter)
    $h = Get-History -Count 1
    $isNew = $h -and $h.Id -ne $global:__LastHistId
    if ($isNew) { $global:__LastHistId = $h.Id }

    $who  = "$env:USERNAME@$env:COMPUTERNAME"
    $path = Format-SafeCtrlChars (Get-PromptPath)

    Write-PromptText "[$(Get-Date -Format 'HH:mm:ss')] " -color DarkGray
    $whoColor = if ($__IsAdmin) { 'Red' } else { 'Cyan' }
    Write-PromptText "$who " -color $whoColor
    Write-PromptText $path -color Green

    $br = Get-GitBranch
    if ($br) { 
        $br = Format-SafeCtrlChars $br
        Write-PromptText " $br" -color Magenta
    }

    if ($isNew) {
        if (-not $ok) {
            # Exit code shown only if nonzero; it may be from an earlier native command
            $msg = if ($code) { "failed, exit $code" } else { 'failed' }
            Write-PromptText " [$msg]" -color Red
        }
        $sec = ($h.EndExecutionTime - $h.StartExecutionTime).TotalSeconds
        if ($sec -ge 2) { Write-PromptText (' [{0:N1}s]' -f $sec) -color Yellow }
    }
    Write-Host '' # End of line 1

    $date = Get-Date -Format 'MM/dd HH:mm:ss'
    if ($__IsAdmin) { 
        $Host.UI.RawUI.WindowTitle = "ADMIN: $path [$date]" 
    } else { 
        $Host.UI.RawUI.WindowTitle = "$path [$date]" 
    }
    $global:LASTEXITCODE = $code

    ('>' * $NestedPromptLevel) + $(if ($__IsAdmin) { '# ' } else { '> ' })
}
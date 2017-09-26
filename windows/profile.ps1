# Install:
#   mkdir $env:USERPROFILE\Documents\WindowsPowerShell
#   cmd /c mklink %USERPROFILE%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 PATH/TO/THIS/FILE
#   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

function prompt
{
    # Based on Rikard Ronnkvist's work: http://www.snowland.se/2010/02/23/nice-powershell-prompt/

    $_LASTEXITCODE = $LASTEXITCODE

    # himitsu
    if ($env:SDXROOT) {
        Write-Host "R" -NoNewline -ForegroundColor Yellow
    }
    if ($DeviceWD) {
        Write-Host "T" -NoNewline -ForegroundColor Yellow
    }

    # Admin ?
    if( (
        New-Object Security.Principal.WindowsPrincipal (
            [Security.Principal.WindowsIdentity]::GetCurrent())
        ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
    {
        # Admin-mark on prompt
        Write-Host "[" -NoNewline -ForegroundColor DarkGray
        Write-Host "Admin" -NoNewline -ForegroundColor Red
        Write-Host "] " -NoNewline -ForegroundColor DarkGray
    }

    # Show providername if you are outside FileSystem
    if ($pwd.Provider.Name -ne "FileSystem") {
        Write-Host "[" -NoNewline -ForegroundColor DarkGray
        Write-Host $pwd.Provider.Name -NoNewline -ForegroundColor Gray
        Write-Host "] " -NoNewline -ForegroundColor DarkGray
    }

    # Current Time
    Write-Host $(Get-Date -UFormat %T) -NoNewline

    # Execution time of the last command
    $lastCommand = Get-History -Count 1
    if ($lastCommand) {
        Write-Host " (" -NoNewline -ForegroundColor DarkGray
        $lastCommandString = $lastCommand.ToString().Replace("`n", " ")

        if ($lastCommandString.Length -gt 10) {
            Write-Host $lastCommandString.Substring(0, 8) -NoNewline -ForegroundColor Gray
            Write-Host ".." -NoNewline -ForegroundColor DarkGray
        } else {
            Write-Host $lastCommandString -NoNewline -ForegroundColor Gray
        }

        $lastCommandTime = $lastCommand.EndExecutionTime - $lastCommand.StartExecutionTime

        Write-Host ": " -NoNewline -ForegroundColor DarkGray
        Write-Host $lastCommandTime -NoNewline -ForegroundColor DarkGray

        if ($lastCommandTime -ge [System.TimeSpan]::FromSeconds($slowProcessNotificationThreshold) -and
            $lastCommand.Id -ne $_slowProcessNotificationId) {
            Write-Host "!" -NoNewline -ForegroundColor Yellow
        }

        Write-Host ")" -NoNewline -ForegroundColor DarkGray
    }

    $pathColor = "Yellow"

    # Remote Device WD
    if ($DeviceWD) {
        Write-Host " REMOTE: " -NoNewline -ForegroundColor Gray
        $DeviceWD.Split("\") | foreach {
            Write-Host $_ -NoNewline
            Write-Host "\" -NoNewline -ForegroundColor Gray
        }
        Write-Host "`b " -NoNewline

        $pathColor = "Green"
    }

    Write-Host

    # Split path and write \ in a gray
    # case insensitive replace
    $path = $pwd.Path -replace [Regex]::Escape($env:HOME), "~"
    if ($env:SDXROOT) {
        $path = $path -replace [Regex]::Escape($env:SDXROOT), "%SDXROOT%"
    }
    $path.Split("\") | foreach {
        Write-Host $_ -NoNewline -ForegroundColor $pathColor
        Write-Host "\" -NoNewline -ForegroundColor Gray
    }

    # Backspace last \
    # Write-Host "`b " -NoNewline

    Write-Host
    Write-Host ">" -NoNewline -ForegroundColor Gray

    # Beep
    Write-Host "`a" -NoNewline

    if ($lastCommand -and
        $lastCommandTime -ge [System.TimeSpan]::FromSeconds($slowProcessNotificationThreshold) -and
        $lastCommand.Id -ne $_slowProcessNotificationId) {
            $global:_slowProcessNotificationId = $lastCommand.Id
            $lastCommandCommandLine = $lastCommand.CommandLine
            Start-Job { param($text)
                Write-Output $text | line-me | Out-Null
            } -Arg "exec time: $lastCommandTime`nexit code: $_LASTEXITCODE`nworking dir: $path`n`n$lastCommandCommandLine" | Out-Null
        }

    return " "
}

$slowProcessNotificationThreshold = 5 * 60 # seconds
$_slowProcessNotificationId = -1

Set-PSReadLineOption -HistoryNoDuplicates:$True
Set-PSReadlineOption -EditMode Emacs
Set-Variable -Name MaximumHistoryCount -Value 32767

Import-Module posh-git

function and
{
    if (!$?) {
        throw "`$LASTEXITCODE = $LASTEXITCODE"
    }
}

$shortcuts = @{}

function bash-like-cd($path = "~")
{
    if (!(Test-Path $path) -and $shortcuts.Contains($path)) {
        $path = $shortcuts[$path]
    }

    if ($path -eq "-") {
        popd
    } elseif (!(Test-Path $path) -and (Test-Path ($Env:SDXROOT + "/" + $path))) {
        pushd ($Env:SDXROOT + "/" + $path)
    } else {
        pushd $path
    }
}
New-Item -Force -Path alias:cd -Value bash-like-cd | Out-Null

function Time-Statistics($cmd)
{
    Write-Host "Statistics for " -NoNewline
    Write-Host $cmd -ForegroundColor Yellow

    Get-History |
      ? { $_.CommandLine -eq $cmd } |
      % { ($_.EndExecutionTime - $_.StartExecutionTime).TotalSeconds } |
      Measure-Object -Average -Maximum -Minimum |
      # % { [timespan]::fromseconds($_) } |
      Format-Table Count, Average, Maximum, Minimum
}

if (Test-Path ~/secrets.ps1) {
    . ~/secrets.ps1
}

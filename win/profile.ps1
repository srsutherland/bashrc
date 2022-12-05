Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

function cdd  { cd $HOME\Downloads }

#https://gist.github.com/timsneath/19867b12eee7fd5af2ba
# Useful shortcuts for traversing directories
function cd..   { cd .. }
function cd...  { cd ..\.. }
function cd.... { cd ..\..\.. }

# Compute file hashes - useful for checking successful downloads 
function md5    { Get-FileHash -Algorithm MD5 $args }
function sha1   { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }

# Simple function to start a new elevated process. If arguments are supplied then 
# a single command is started with admin rights; if not then a new admin instance
# of PowerShell is started.
function admin
{
    if ($args.Count -gt 0)
    {   
       $argList = "& '" + $args + "'"
       Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $argList
    }
    else
    {
       Start-Process "$psHome\powershell.exe" -Verb runAs
    }
}


# Set UNIX-like aliases for the admin command, so sudo <command> will run the command
# with elevated rights. 
Set-Alias -Name su -Value admin
Set-Alias -Name sudo -Value admin
#https://stackoverflow.com/questions/138144/what-s-in-your-powershell-profile-ps1-file
function Get-Time { return $(get-date | foreach { $_.ToLongTimeString() } ) }

if (Get-Module -ListAvailable -Name posh-git) {
    Import-Module posh-git
    $GitPromptSettings.DefaultPromptPrefix.Text = '[$(Get-Date -f "MM-dd HH:mm:ss")] '
    $GitPromptSettings.DefaultPromptPrefix.ForegroundColor = [ConsoleColor]::gray
    $GitPromptSettings.DefaultPromptPath.ForegroundColor = [ConsoleColor]::green
    $GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
}
else {
    #https://stackoverflow.com/questions/138144/what-s-in-your-powershell-profile-ps1-file
    function prompt
    {
        # Write the time 
        write-host "[" -noNewLine
        write-host $(Get-Time) -foreground yellow -noNewLine
        write-host "] " -noNewLine
        # Write the path
        write-host $($(Get-Location).Path.replace($home,"~").replace("\","/")) -foreground green -noNewLine
        write-host $(if ($nestedpromptlevel -ge 1) { '>>' }) -noNewLine
        return "> "
    }
}

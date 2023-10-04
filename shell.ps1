# Display the custom text
Write-Host @"
    #########################################
    # WINDOWS 10 LTSC POST-INSTALLER SCRIPT #
    #########################################
"@

# Function to disable the Windows Update service
function Disable-WindowsUpdateService {
    Set-Service -Name "wuauserv" -StartupType Disabled
    Stop-Service -Name "wuauserv"
    Write-Host "Windows Update service has been disabled."
}

function EdgeRemove {
    # Run the command to remove Microsoft Edge
    Invoke-Expression (New-Object Net.WebClient).DownloadString("http://bit.ly/edge-remove")
}

# Function to install Scoop in a separate PowerShell window
function Install-ScoopInSeparateWindow {
    $scoopInstallScript = "https://get.scoop.sh"
    
    # Start a new PowerShell process without a new window and wait for it to complete
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command irm $scoopInstallScript | iex" -Wait
    
    Write-Host "Scoop package manager installation has completed in a separate window."
}

# Start a loop to allow the user to continue choosing options
do {
    Write-Host "`nPress the numbers then ENTER`n'0' to install Scoop package manager`n'1' to disable Windows Update service`n'2' to run edge-remove.bat`n'X' to exit."
    $choice = Read-Host

    if ($choice -eq "0") {
        Write-Host "Do you want to install Scoop package manager in a separate window? (Y/N)"
        $installChoice = Read-Host
        if ($installChoice -eq "Y" -or $installChoice -eq "y") {
            # Install Scoop in a separate PowerShell window
            Install-ScoopInSeparateWindow
        }
        elseif ($installChoice -eq "N" -or $installChoice -eq "n") {
            Write-Host "Installation of Scoop package manager canceled."
        }
        else {
            Write-Host "Invalid input. Installation canceled."
        }
    }
    elseif ($choice -eq "1") {
        Disable-WindowsUpdateService
    }
    elseif ($choice -eq "2") {
        EdgeRemove
    }
    elseif ($choice -ne "X" -and $choice -ne "x") {
        Write-Host "Invalid choice."
    }

} until ($choice -eq "X" -or $choice -eq "x")

# Exit message
Write-Host "Exiting the main script..."

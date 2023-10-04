# Function to disable the Windows Update service
function Disable-WindowsUpdateService {
    Set-Service -Name "wuauserv" -StartupType Disabled
    Stop-Service -Name "wuauserv"
    Write-Host "Windows Update service has been disabled."
}

# Main script
$scriptDirectory = $PSScriptRoot
Write-Host "Press '0' to install Scoop package manager, '1' to disable Windows Update service, '2' to run edge-remove.bat, or any other key to exit."
$choice = Read-Host

if ($choice -eq "0") {
    Write-Host "Do you want to install Scoop package manager? (Y/N)"
    $installChoice = Read-Host
    if ($installChoice -eq "Y" -or $installChoice -eq "y") {
        # Download and run the Scoop installer
        irm get.scoop.sh -outfile 'install.ps1'
        Start-Process -FilePath ".\install.ps1" -ArgumentList "-RunAsAdmin"
        Write-Host "Scoop package manager installation has been initiated."
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
    # Run edge-remove.bat script from the same directory
    $edgeRemoveScript = Join-Path -Path $scriptDirectory -ChildPath "edge-remove.bat"
    if (Test-Path $edgeRemoveScript) {
        Start-Process -FilePath $edgeRemoveScript -Wait
        Write-Host "edge-remove.bat script has been executed."
    }
    else {
        Write-Host "edge-remove.bat script not found in the script directory."
    }
}
elseif ($choice -ne "0" -and $choice -ne "1" -and $choice -ne "2") {
    Write-Host "Exiting..."
}
else {
    Write-Host "Invalid choice."
}

Pause

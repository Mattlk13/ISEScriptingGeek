

Function ConvertTo-TextFile {
    [cmdletbinding()]
    Param (
        [switch]$Reload
    )

    #verify we are in the ISE
    if ($psise) {
        #get the current file name and path and change the extension
        $psVersion = $psise.CurrentFile.FullPath
        $textVersion = $psversion -replace "ps1", "txt"

        #save the file.
        $psise.CurrentFile.SaveAs($textVersion)

        #if -Reload then reload the PowerShell file into the ISE
        if ($Reload) {
            $psise.CurrentPowerShellTab.Files.Add($psVersion)
        }
    } #if $psise
    else {
        Write-Warning "This function requires the Windows PowerShell ISE."
    }
} #end function
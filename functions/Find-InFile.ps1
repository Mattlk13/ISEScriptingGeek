
Function Find-InFile {

    [cmdletbinding()]
    Param()

    Set-StrictMode -Version Latest

    Write-Verbose "Starting $($myinvocation.mycommand)"
    #verify we are in the ISE
    if ($host.name -match "ISE") {

        $Title = "Find in Files"

        #prompt for file types to search
        $Prompt = "Enter a path and file types to search. Leave blank to cancel"
        $Default = ".\*.ps1"
        $path = New-Inputbox -prompt $prompt -title $Title -default $Default

        if ($path) {
            #prompt for what to search for
            $Prompt = "What do you want to search for"
            $Default = $Null
            $find = New-Inputbox -prompt $prompt -title $Title -default $Default

            #execute search
            $results = Select-String -Pattern $find -Path $path |
                Select Path, Filename,
            @{Name = "Line"; Expression = {$_.Line.Trim()}}, LineNumber |
                Out-Gridview -Title "Select one or more matching files" -OutputMode Multiple

            #open files and jump to matching line
            foreach ($item in $results) {
                Write-Verbose ($item | out-string)
                psedit $item.path
                #give file a chance to open
                start-sleep -Milliseconds 100
                #get current files
                $f = $psise.CurrentPowerShellTab.Files
                #select the last one
                $psise.CurrentPowerShellTab.Files.SelectedFile = $f[-1]
                #set the cursor
                $psise.CurrentPowerShellTab.files.SelectedFile.Editor.SetCaretPosition($item.linenumber, 1)
            }
        }
    }
    else {
        Write-Warning "This version only works in the PowerShell ISE"
    }
    Write-Verbose "Ending $($myinvocation.mycommand)"

}
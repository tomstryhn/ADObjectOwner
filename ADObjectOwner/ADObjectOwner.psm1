# Parse .\src\ps1\*.ps1
Get-ChildItem $(Join-Path -Path $PSScriptRoot -ChildPath 'src') |
    Where-Object { $_.PSIsContainer -and ($_.Name -eq 'ps1') } |
        ForEach-Object { Get-ChildItem "$($_.FullName)\*" -Include '*.ps1' } |
            ForEach-Object { . $_.FullName }
Task default -depends FunctionsToExport

Task FunctionsToExport {
    $moduleName = Get-Item . | ForEach-Object BaseName

    # RegEx matches files like Verb-Noun.ps1 only, not psakefile.ps1 or *-*.Tests.ps1
    $functionNames = Get-ChildItem "$($modulename).psm1" -PipelineVariable file | ForEach-Object {
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref] $null, [ref] $null)
        if ($ast.EndBlock.Statements.Name) {
            $ast.EndBlock.Statements.Name
        }
    }
    Write-Verbose "Using functions $functionNames"

    Update-ModuleManifest -Path ".\$($moduleName).psd1" -FunctionsToExport $functionNames
}

Task UpdateReadme {
  $moduleName = Get-Item . | ForEach-Object BaseName
  $readMe = Get-Item README.md

  if (!(Get-Module -Name $moduleName )) {Import-Module -Name ".\$($moduleName).psd1" }

  Write-Output "[![GitHub issues](https://img.shields.io/github/issues/Azure-Devops-PowerShell-Module/$($moduleName))](https://github.com/Azure-Devops-PowerShell-Module/$($moduleName)/issues)" |Out-File $readMe.FullName -Force 
  Write-Output "[![GitHub forks](https://img.shields.io/github/forks/Azure-Devops-PowerShell-Module/$($moduleName))](https://github.com/Azure-Devops-PowerShell-Module/$($moduleName)/network)" |Out-File $readMe.FullName -Append
  Write-Output "[![GitHub license](https://img.shields.io/github/license/Azure-Devops-PowerShell-Module/$($moduleName))](https://github.com/Azure-Devops-PowerShell-Module/$($moduleName)/blob/master/LICENSE)" |Out-File $readMe.FullName -Append

  Get-Command -Module $moduleName |Sort-Object -Property Noun,Verb |ForEach-Object {Write-Output "## [$($_.Name)](docs/$($_.Name).md)";Write-Output '```';Get-Help $_.Name;Write-Output '```'} |Out-File $readMe.FullName -Append
}
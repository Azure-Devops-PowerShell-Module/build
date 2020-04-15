# .ExternalHelp core-help.xml
function Get-Build {
  [CmdletBinding(
    HelpURI = 'https://github.com/Azure-Devops-PowerShell-Module/build/blob/master/docs/Get-AzDevOpsBuild.md#get-azdevopsbuild',
    PositionalBinding = $true)]
  [OutputType([Object])]
  param (
    [Parameter(ValueFromPipeline, Mandatory = $false, ParameterSetName = 'Project')]
    [object]$Project,
    [Parameter(Mandatory = $false, ParameterSetName = 'ProjectId')]
    [Guid]$ProjectId,
    [Parameter(Mandatory = $false, ParameterSetName = 'Project')]
    [Parameter(Mandatory = $false, ParameterSetName = 'ProjectId')]
    [int]$BuildId
  )

  $ErrorActionPreference = 'Stop'
  $Error.Clear()

  try {
    #
    # Are we connected
    #
    if ($Global:azDevOpsConnected) {
      switch ($PSCmdlet.ParameterSetName) {
        'Project' {
          $uriProjects = $Global:azDevOpsOrg + "/$($Project.Id)/_apis/build/builds?api-version=5.1"
        }
        'ProjectId' {
          $Project = Get-AzDevOpsProject -ProjectId $ProjectId
          $uriProjects = $Global:azDevOpsOrg + "/$($Project.Id)/_apis/build/builds?api-version=5.1"
        }
      }
      if ($BuildId) {
        $uriProjects = $Global:azDevOpsOrg + "/$($Project.Id)/_apis/build/builds/$($BuildId)?api-version=5.1"
        return (Invoke-RestMethod -Uri $uriProjects -Method get -Headers $Global:azDevOpsHeader)
      }
      else {
        return (Invoke-RestMethod -Uri $uriProjects -Method get -Headers $Global:azDevOpsHeader).Value
      }
    }
    else {
      $PSCmdlet.ThrowTerminatingError(
        [System.Management.Automation.ErrorRecord]::new(
          ([System.Management.Automation.ItemNotFoundException]"Not connected to Azure DevOps, please run Connect-AzDevOpsOrganization"),
          'Projects.Functions',
          [System.Management.Automation.ErrorCategory]::OpenError,
          $MyObject
        )
      )
    }
  }
  catch {
    throw $_
  }
}
function Remove-Build {
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High',
    HelpURI = 'https://github.com/Azure-Devops-PowerShell-Module/build/blob/master/docs/Remove-AzDevOpsBuild.md#remove-azdevopsbuild',
    PositionalBinding = $true)]
  [OutputType([string])]
  param (
    [Parameter(ValueFromPipeline, Mandatory = $false, ParameterSetName = 'Project')]
    [object]$Project,
    [Parameter(Mandatory = $false, ParameterSetName = 'ProjectId')]
    [Guid]$ProjectId,
    [Parameter(Mandatory = $true, ParameterSetName = 'Project')]
    [Parameter(Mandatory = $true, ParameterSetName = 'ProjectId')]
    [int]$BuildId
  )

  $ErrorActionPreference = 'Stop'
  $Error.Clear()

  try {
    #
    # Are we connected
    #
    if ($Global:azDevOpsConnected) {
      switch ($PSCmdlet.ParameterSetName) {
        'ProjectId' {
          $Project = Get-AzDevOpsProject -ProjectId $ProjectId
        }
      }
      $Build = Get-AzDevOpsBuild -ProjectId $Project.Id -BuildId $BuildId
      if (!($Build.deleted)) {
        $uriProjects = $Global:azDevOpsOrg + "/$($Project.Id)/_apis/build/builds/$($Build.Id)?api-version=5.1"
        if ($PSCmdlet.ShouldProcess("Delete", "Remove Build $($Build.Id) from $($Project.name) Azure Devops Projects")) {
          $Result = Invoke-RestMethod -Uri $uriProjects -Method Delete -Headers $Global:azDevOpsHeader
        }
        if (!($Result)) {
          return "Build : $($Build.id) removed from Project : $($Project.name)"
        }
      }
      else {
        return "Build : $($Build.id) was deleted on $(Get-Date ($Build.deletedDate)) by $($Build.deletedBy.displayName)"
      }
    }
    else {
      $PSCmdlet.ThrowTerminatingError(
        [System.Management.Automation.ErrorRecord]::new(
          ([System.Management.Automation.ItemNotFoundException]"Not connected to Azure DevOps, please run Connect-AzDevOpsOrganization"),
          'Projects.Functions',
          [System.Management.Automation.ErrorCategory]::OpenError,
          $MyObject
        )
      )
    }
  }
  catch {
    throw $_
  }
}
function Start-Build {
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low',
    HelpURI = 'https://github.com/Azure-Devops-PowerShell-Module/build/blob/master/docs/Start-AzDevOpsBuild.md#start-azdevopsbuild',
    PositionalBinding = $true)]
  [OutputType([Object])]
  param (
    [Parameter(ValueFromPipeline, Mandatory = $false, ParameterSetName = 'Project')]
    [object]$Project,
    [Parameter(ValueFromPipeline, Mandatory = $false, ParameterSetName = 'Project')]
    [object]$Definition,
    [Parameter(Mandatory = $false, ParameterSetName = 'ProjectId')]
    [Guid]$ProjectId,
    [Parameter(Mandatory = $false, ParameterSetName = 'ProjectId')]
    [int]$DefinitionId,
    [Parameter(Mandatory = $false, ParameterSetName = 'ProjectId')]
    [Parameter(ValueFromPipeline, Mandatory = $false, ParameterSetName = 'Project')]
    [hashtable[]]$Variables,
    [Parameter(Mandatory = $false, ParameterSetName = 'ProjectId')]
    [Parameter(ValueFromPipeline, Mandatory = $false, ParameterSetName = 'Project')]
    [switch]$Wait
  )

  $ErrorActionPreference = 'Stop'
  $Error.Clear()

  try {
    #
    # Are we connected
    #
    if ($Global:azDevOpsConnected) {
      switch ($PSCmdlet.ParameterSetName) {
        'Project' {
        }
        'ProjectId' {
          $Project = Get-AzDevOpsProject -ProjectId $ProjectId
          $Definition = Get-AzDevOpsBuildDefinition -ProjectId $Project.Id -DefinitionId $DefinitionId
        }
      }
      $uriBuild = $Global:azDevOpsOrg + "/$($Project.Id)/_apis/build/builds?api-version=5.1"
      #
      # Check that variables exist in defintion
      #
      foreach ($key in $Variables.keys) {
        if (!($Definition.variables | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name).Contains($key)) {
          $PSCmdlet.ThrowTerminatingError(
            [System.Management.Automation.ErrorRecord]::new(
              ([System.Management.Automation.ItemNotFoundException]"One or more variables not found in Build Definition"),
              'Projects.Functions',
              [System.Management.Automation.ErrorCategory]::OpenError,
              $MyObject
            )
          )
        }
      }
      $Body = New-Object -TypeName psobject
      Add-Member -InputObject $Body -MemberType NoteProperty -Name definition -Value $Definition
      $Parameters = New-Object -TypeName psobject
      foreach ($item in $Variables){Add-Member -InputObject $parameters -MemberType NoteProperty -Name $item.Keys -Value $item[$item.Keys][0]}
      Add-Member -InputObject $Body -MemberType NoteProperty -Name parameters -Value ($Parameters |ConvertTo-Json -Compress)
      if ($PSCmdlet.ShouldProcess("Start", "Qeue Build $($Build.Id) from $($Project.name) Azure Devops Projects")) {
        $Result = Invoke-RestMethod -Method post -Uri $uriBuild -Headers $Global:azDevOpsHeader -ContentType 'application/json' -Body ($Body |ConvertTo-Json -Compress -Depth 10)
        if ($Wait) {
          do {
            Get-AzDevOpsBuild -Project $Project -BuildId $Result.id |out-null
          } until ((Get-AzDevOpsBuild -Project $Project -BuildId $Result.id).status -eq 'completed')
        }
        return Get-AzDevOpsBuild -Project $Project -BuildId $Result.id
      }
    }
    else {
      $PSCmdlet.ThrowTerminatingError(
        [System.Management.Automation.ErrorRecord]::new(
          ([System.Management.Automation.ItemNotFoundException]"Not connected to Azure DevOps, please run Connect-AzDevOpsOrganization"),
          'Projects.Functions',
          [System.Management.Automation.ErrorCategory]::OpenError,
          $MyObject
        )
      )
    }
  }
  catch {
    throw $_
  }
}
function Get-BuildLog {
  [CmdletBinding(
    HelpURI = 'https://github.com/Azure-Devops-PowerShell-Module/build/blob/master/docs/Get-AzDevOpsBuildLog.md#get-azdevopsbuildlog',
    PositionalBinding = $true)]
  [OutputType([Object])]
  param (
    [Parameter(ValueFromPipeline, Mandatory = $false, ParameterSetName = 'Project')]
    [object]$Project,
    [Parameter(ValueFromPipeline, Mandatory = $false, ParameterSetName = 'Project')]
    [object]$Build,
    [Parameter(Mandatory = $false, ParameterSetName = 'ProjectId')]
    [Guid]$ProjectId,
    [Parameter(Mandatory = $false, ParameterSetName = 'ProjectId')]
    [int]$BuildId,
    [Parameter(Mandatory = $false, ParameterSetName = 'Project')]
    [Parameter(Mandatory = $false, ParameterSetName = 'ProjectId')]
    [int]$LogId
  )

  $ErrorActionPreference = 'Stop'
  $Error.Clear()

  try {
    #
    # Are we connected
    #
    if ($Global:azDevOpsConnected) {
      switch ($PSCmdlet.ParameterSetName) {
        'Project' {
          $uriProjects = $Global:azDevOpsOrg + "/$($Project.Id)/_apis/build/builds/$($Build.Id)/logs?api-version=5.1"
        }
        'ProjectId' {
          $Project = Get-AzDevOpsProject -ProjectId $ProjectId
          $Build = Get-AzDevOpsBuild -ProjectId $Project.id -BuildId $BuildId
          $uriProjects = $Global:azDevOpsOrg + "/$($Project.Id)/_apis/build/builds/$($Build.Id)/logs?api-version=5.1"
        }
      }
      if ($LogId) {
        $uriProjects = $uriProjects = $Global:azDevOpsOrg + "/$($Project.Id)/_apis/build/builds/$($Build.Id)/logs/$($LogId)?api-version=5.1"
        return (Invoke-RestMethod -Uri $uriProjects -Method get -Headers $Global:azDevOpsHeader)
      }
      else {
        return (Invoke-RestMethod -Uri $uriProjects -Method get -Headers $Global:azDevOpsHeader).Value
      }
    }
    else {
      $PSCmdlet.ThrowTerminatingError(
        [System.Management.Automation.ErrorRecord]::new(
          ([System.Management.Automation.ItemNotFoundException]"Not connected to Azure DevOps, please run Connect-AzDevOpsOrganization"),
          'Projects.Functions',
          [System.Management.Automation.ErrorCategory]::OpenError,
          $MyObject
        )
      )
    }
  }
  catch {
    throw $_
  }
}
function Get-BuildDefinition {
  [CmdletBinding(
    HelpURI = 'https://github.com/Azure-Devops-PowerShell-Module/build/blob/master/docs/Get-AzDevOpsBuildDefinition.md#get-azdevopsbuilddefinition',
    PositionalBinding = $true)]
  [OutputType([Object])]
  param (
    [Parameter(ValueFromPipeline, Mandatory = $false, ParameterSetName = 'Project')]
    [object]$Project,
    [Parameter(Mandatory = $false, ParameterSetName = 'ProjectId')]
    [Guid]$ProjectId,
    [Parameter(Mandatory = $false, ParameterSetName = 'Project')]
    [Parameter(Mandatory = $false, ParameterSetName = 'ProjectId')]
    [int]$DefinitionId
  )

  $ErrorActionPreference = 'Stop'
  $Error.Clear()

  try {
    #
    # Are we connected
    #
    if ($Global:azDevOpsConnected) {
      switch ($PSCmdlet.ParameterSetName) {
        'Project' {
          $uriProjects = $Global:azDevOpsOrg + "/$($Project.Id)/_apis/build/definitions?api-version=5.1"
        }
        'ProjectId' {
          $Project = Get-AzDevOpsProject -ProjectId $ProjectId
          $uriProjects = $Global:azDevOpsOrg + "/$($Project.Id)/_apis/build/definitions?api-version=5.1"
        }
      }
      if ($DefinitionId) {
        $uriProjects = $Global:azDevOpsOrg + "/$($Project.Id)/_apis/build/definitions/$($DefinitionId)?api-version=5.1"
        return (Invoke-RestMethod -Uri $uriProjects -Method get -Headers $Global:azDevOpsHeader)
      }
      else {
        return (Invoke-RestMethod -Uri $uriProjects -Method get -Headers $Global:azDevOpsHeader).Value
      }
    }
    else {
      $PSCmdlet.ThrowTerminatingError(
        [System.Management.Automation.ErrorRecord]::new(
          ([System.Management.Automation.ItemNotFoundException]"Not connected to Azure DevOps, please run Connect-AzDevOpsOrganization"),
          'Projects.Functions',
          [System.Management.Automation.ErrorCategory]::OpenError,
          $MyObject
        )
      )
    }
  }
  catch {
    throw $_
  }
}
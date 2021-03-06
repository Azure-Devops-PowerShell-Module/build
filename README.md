[![GitHub issues](https://img.shields.io/github/issues/Azure-Devops-PowerShell-Module/build)](https://github.com/Azure-Devops-PowerShell-Module/build/issues)
[![GitHub forks](https://img.shields.io/github/forks/Azure-Devops-PowerShell-Module/build)](https://github.com/Azure-Devops-PowerShell-Module/build/network)
[![GitHub license](https://img.shields.io/github/license/Azure-Devops-PowerShell-Module/build)](https://github.com/Azure-Devops-PowerShell-Module/build/blob/master/LICENSE)
## [Get-AzDevOpsBuild](docs/Get-AzDevOpsBuild.md)
```

NAME
    Get-AzDevOpsBuild
    
SYNTAX
    Get-AzDevOpsBuild [-Project <Object>] [-BuildId <int>]  [<CommonParameters>]
    
    Get-AzDevOpsBuild [-ProjectId <guid>] [-BuildId <int>]  [<CommonParameters>]
    

ALIASES
    None
    

REMARKS
    None

```
## [Remove-AzDevOpsBuild](docs/Remove-AzDevOpsBuild.md)
```
NAME
    Remove-AzDevOpsBuild
    
SYNTAX
    Remove-AzDevOpsBuild -BuildId <int> [-Project <Object>] [-WhatIf] [-Confirm]  [<CommonParameters>]
    
    Remove-AzDevOpsBuild -BuildId <int> [-ProjectId <guid>] [-WhatIf] [-Confirm]  [<CommonParameters>]
    

ALIASES
    None
    

REMARKS
    None

```
## [Start-AzDevOpsBuild](docs/Start-AzDevOpsBuild.md)
```
NAME
    Start-AzDevOpsBuild
    
SYNTAX
    Start-AzDevOpsBuild [-Project <Object>] [-Definition <Object>] [-Variables <hashtable[]>] [-Wait] [-WhatIf] [-Confirm]  [<CommonParameters>]
    
    Start-AzDevOpsBuild [-ProjectId <guid>] [-DefinitionId <int>] [-Variables <hashtable[]>] [-Wait] [-WhatIf] [-Confirm]  [<CommonParameters>]
    

ALIASES
    None
    

REMARKS
    None

```
## [Get-AzDevOpsBuildDefinition](docs/Get-AzDevOpsBuildDefinition.md)
```
NAME
    Get-AzDevOpsBuildDefinition
    
SYNTAX
    Get-AzDevOpsBuildDefinition [-Project <Object>] [-DefinitionId <int>]  [<CommonParameters>]
    
    Get-AzDevOpsBuildDefinition [-ProjectId <guid>] [-DefinitionId <int>]  [<CommonParameters>]
    

ALIASES
    None
    

REMARKS
    None

```
## [Get-AzDevOpsBuildFolder](docs/Get-AzDevOpsBuildFolder.md)
```
NAME
    Get-AzDevOpsBuildFolder
    
SYNTAX
    Get-AzDevOpsBuildFolder [-Project <Object>] [-Path <string>]  [<CommonParameters>]
    
    Get-AzDevOpsBuildFolder [-ProjectId <guid>] [-Path <string>]  [<CommonParameters>]
    

ALIASES
    None
    

REMARKS
    None

```
## [New-AzDevOpsBuildFolder](docs/New-AzDevOpsBuildFolder.md)
```
NAME
    New-AzDevOpsBuildFolder
    
SYNTAX
    New-AzDevOpsBuildFolder -Name <string> [-Project <Object>] [-Description <string>]  [<CommonParameters>]
    
    New-AzDevOpsBuildFolder -Name <string> [-ProjectId <guid>] [-Description <string>]  [<CommonParameters>]
    

ALIASES
    None
    

REMARKS
    None

```
## [Remove-AzDevOpsBuildFolder](docs/Remove-AzDevOpsBuildFolder.md)
```
NAME
    Remove-AzDevOpsBuildFolder
    
SYNTAX
    Remove-AzDevOpsBuildFolder -Name <string> [-Project <Object>] [-WhatIf] [-Confirm]  [<CommonParameters>]
    
    Remove-AzDevOpsBuildFolder -Name <string> [-ProjectId <guid>] [-WhatIf] [-Confirm]  [<CommonParameters>]
    

ALIASES
    None
    

REMARKS
    None

```
## [Get-AzDevOpsBuildLog](docs/Get-AzDevOpsBuildLog.md)
```
NAME
    Get-AzDevOpsBuildLog
    
SYNTAX
    Get-AzDevOpsBuildLog [-Project <Object>] [-Build <Object>] [-LogId <int>]  [<CommonParameters>]
    
    Get-AzDevOpsBuildLog [-ProjectId <guid>] [-BuildId <int>] [-LogId <int>]  [<CommonParameters>]
    

ALIASES
    None
    

REMARKS
    None

```



# ADObjectOwner PowerShell Module

PowerShell Module, for making the process of changing the Owner of bulk ADObjects so much more simple.

## Table of Content

  - [Version Changes](#version-changes)
  - [Background](#background)
      - [Risk(s)](#risks)
      - [Mitigation](#mitigation)
  - [Importing the Module](#importing-the-module)
  - [Examples](#examples)
  - [Functions](#functions)
      - [Get-ADObjectOwner](#get-adobjectowner)
      - [Get-SecurityPrincipalNTAccount](#get-securityprincipalntaccount)
      - [Set-ADObjectOwner](#set-adobjectowner)

## Version Changes

>1.0.1.0
- Minor changes to the filestructure of the Module
- ScriptFileInfo added on the scriptfiles in the Module
- MIT License added - Yes, it's free to use
>1.0.0.20211026
- First version published on GitHub

## Background

Every ADObject has an owner, the Owner is by default the Identity creating it. Normally if a member of the 'Domain Admins' or 'Enterprise Admins' creates an Object, the owner of the Object would be set as the 'Domain Admins' or 'Enterprise Admins'.
Also per default in ADDS, a user can domain-join up to 10 computers, by doing so, if the user is not member of any Privliged Group, the owner of the Computer being domain-joined will be the user joining it to the domain.

### Risk(s)

There are several risks by this 'feature', one being if a hacker get hold of the credentials for the User, they have indirectly Full Control over the Object, being an Owner on its own don't grant Full Control, but by being the Owner they have permission to alter the Permissions on the Object, which gives the hacker the option to take Full Control over the Object.

### Mitigation

The easy way to mitigate this problem, is obviously to make sure that no unprivliged users, have ownership of any of the Objects in your Active Directory. The ADObjectOwner Module, makes this task rather simple. Since the `Get-ADObjectOwner` takes pipeline-input, you are able to pipe several ADObject into the function, and get an output with the DistinguishedName and the Owner. Now it's pretty straight forward to sort in the Objects based on the Owner. With the combination of `Get-ADObjectOwner`, `Get-SecurityPrincipalNTAccount` and `Set-ADObjectOwner`, it's possible to handle this risk, without going through all the Objects manually. See [Examples](#examples) for more on this.

## Importing the Module

1. Either you can download the ZIP using the green "Code" button top right, or clone this repository
2. Go to your repositiry, or unzipped folder in your PowerShell
3. See below

```PowerShell

PS C:\GitHub\ADObjectOwner> gci


    Directory: C:\GitHub\ADObjectOwner


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       26-10-2021     23:37                ADObjectOwner
-a----       26-10-2021     23:49            122 README.md


PS C:\GitHub\ADObjectOwner> Import-Module .\ADObjectOwner
PS C:\GitHub\ADObjectOwner> Get-Command -Module ADObjectOwner

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Get-ADObjectOwner                                  1.0.1.0    ADObjectOwner
Function        Get-SecurityPrincipalNTAccount                     1.0.1.0    ADObjectOwner
Function        Set-ADObjectOwner                                  1.0.1.0    ADObjectOwner


PS C:\GitHub\ADObjectOwner>

```

## Examples

When using the `Set-ADObjectOwner`, use it with the `Get-SecurityPrincipalNTAccount` output in a variable like shown below:

```PowerShell

PS C:\> $newOwner = Get-SecurityPrincipalNTAccount -SAMAccountName 'Domain Admins'

PS C:\> Get-ADObject -SearchBase "OU=TestOU,DC=YourDomain,DC=local" -Filter * | Get-ADObjectOwner | Where-Object { $_.Owner -ne $newOwner } | Set-ADObjectOwner -Owner $newOwner

DistinguishedName                             Owner
-----------------                             -----
CN=JohnSmith,OU=TestOU,DC=YourDomain,DC=local YourDomain\Domain Admins
CN=WS001,OU=TestOU,DC=YourDomain,DC=local     YourDomain\Domain Admins

PS C:\> _

```

By setting the Owner in an variable you will obtain a far better performance, since the UserPrincipal will not have to be generated for each `Set-ADObjectOwner` action.

## Functions

The list of the functions contained in this module.

### Get-ADObjectOwner

```PowerShell
<#
.SYNOPSIS
    Gets Object Owner, from the Access Control List on an ADObject.

.DESCRIPTION
    Gets the ACL of an ADObject, and returns the Object Owner

.PARAMETER DistinguishedName
    The DistinguishedName of the Object you want to get the Owner of.

.EXAMPLE
    PS C:\> Get-ADObjectOwner -DistinguishedName 'OU=TestOU,DC=Dev,DC=local'

    DistinguishedName         Owner        
    -----------------         -----        
    OU=TestOU,DC=Dev,DC=local Dev\Domain Admins

.NOTES
    FUNCTION: Set-ADObjectOwner
    AUTHOR:   Tom Stryhn
    GITHUB:   https://github.com/tomstryhn/

.INPUTS
    [string]

.OUTPUTS
    [PSCustomObject]

.LINK
    Set-ADObjectOwner

#>
```

### Get-SecurityPrincipalNTAccount

```PowerShell
<#
.SYNOPSIS
    Validates a Security Principal NT Account, and outputs it.

.DESCRIPTION
    Validates a Security Principal NT Account, and outputs it, by looking up the SID on the entered
    NT Account, and retrieves the Account associated with the SID, and compares the sAMAccount name
    of the two. If the Account can not be validated it will not be returned.

.PARAMETER SAMAccountName
    The sAMAccount name wanted.

.PARAMETER Domain
    Domain, if other than the one being run from, ie. if you need 'Enterprise Admins' of a root domain.

.EXAMPLE
    PS C:\> Get-SecurityPrincipalNTAccount -SAMAccount 'DomainUser' -Domain 'Dev'

    Value       
    -----       
    Dev\DomainUser

.NOTES
    FUNCTION: Get-SecurityPrincipalNTAccount
    AUTHOR:   Tom Stryhn
    GITHUB:   https://github.com/tomstryhn/

.INPUTS
    [string],[string]

.OUTPUTS
    [System.Security.Principal.NTAccount]

#>
```

### Set-ADObjectOwner

```PowerShell
<#
.SYNOPSIS
    Sets the Access Control List Owner on an AD Object

.DESCRIPTION
    Sets the Access Control List Owner on an AD Object

    ## CAUTION ## - This script is provided on an “AS-IS” basis, any wrongful use could cause
                    irrevesible changes to Active Directory and related services. Therefore use it
                    with great caution. 

.PARAMETER DistinguishedName
    The DistinguishedName of the Object you want to set the Owner on.

.PARAMETER Owner
    The Owner to be set.

.EXAMPLE
    PS C:\> Set-ADObjectOwner -DistinguishedName 'OU=TestOU,DC=Dev,DC=local' -Owner (Get-SecurityPrincipalNTAccount -SAMAccount 'Domain Admins')

    DistinguishedName         Owner        
    -----------------         -----        
    OU=TestOU,DC=Dev,DC=local Dev\Domain Admins

.NOTES
    FUNCTION: Set-ADObjectOwner
    AUTHOR:   Tom Stryhn
    GITHUB:   https://github.com/tomstryhn/

.INPUTS
    [string],[System.Security.Principal.NTAccount]

.OUTPUTS
    [PSCustomObject]

.LINK
    Get-ADObjectOwner
    Get-SecurityPrincipalNTAccount

#>
```

# ADObjectOwner

PowerShell Module, for making the process of changing the Owner of ADObjects that much easier and quick.

### Background

Every ADObject has an owner, the Owner is by default the Identity creating it. Normally if a member of the 'Domain Admins' or 'Enterprise Admins' creates an Object, the owner of the Object would be set as the 'Domain Admins' or 'Enterprise Admins'.
Also per default in ADDS, an User can domain-join up to 10 computers, by doing so, if the User is not member of any Privliged Group, the owner of the Computer being domain-joined will be the User joining it to the domain.

#### Risk(s)

There are several risks by this 'feature', one being if a hacker get hold of the credentials for the User, they have indirectly Full Control over the Object, being an Owner on its own don't grant Full Control, but by being the Owner they have permission to alter the Permissions on the Object, which gives the hacker the option to take Full Control over the Object.

#### Mitigation

The easy way to mitigate this problem, is obviously to make sure that no unprivliged users, have ownership of any of the Objects in your Active Directory. The ADObjectOwner Module, makes this task rahter simple. Since the Get-ADObjectOwner takes pipeline-input, you are able to pipe several ADObject into the function, and get an output with the DistinguishedName and the Owner. Now it's pretty straight forward to sort in the Objects based on the Owner. With the combination of Get-ADObjectOwner, Get-SecurityPrincipalNTAccount, Set-ADObjectOwner, it's possible to handle this risk, without going through all the Objects manually.

### Importing the Module

#### The correct way

1. Start by Cloning the Repo
2. Go to your Repo folder in your PowerShell
4. See below

```PowerShell

PS C:\GitHub\ADObjectOwner> ls


    Directory: C:\GitHub\ADObjectOwner


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       26-10-2021     23:37                ADObjectOwner
-a----       26-10-2021     23:49            122 README.md


PS C:\GitHub\ADObjectOwner> Import-Module .\ADObjectOwner
PS C:\GitHub\ADObjectOwner> Get-Command -Module ADObjectOwner

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Get-ADObjectOwner                                  1.0.0.2... ADObjectOwner
Function        Get-SecurityPrincipalNTAccount                     1.0.0.2... ADObjectOwner
Function        Set-ADObjectOwner                                  1.0.0.2... ADObjectOwner


PS C:\GitHub\ADObjectOwner>

```

#### The Ninja Way

Alternatively, if you dont have the option to clone the Repo and importing the module, you can do it the "Ninja Way" and load the functions directly into memory of your PowerShell session. Be aware depending on the security in your enviroment, you could trigger one or more alarms, since this method leverages the same workaround as hackers use, when trying to load scripts, without saving them on disk.

Let's start by checking if we have the functions loaded:

```PowerShell
# Testing for Functions - No Output
PS C:\> Get-Command *ADObjectOwner*
PS C:\> _
```

Now run the following:

```PowerShell
$files = 'Get-ADObjectOwner.ps1','Get-SecurityPrincipalNTAccount.ps1','Set-ADObjectOwner.ps1'
$rGit = 'https://raw.githubusercontent.com/tomstryhn/ADObjectOwner/main/ADObjectOwner/ps1/'

foreach($file in $files){
    $rURL = "$rGit$file"
    $rCode = (Invoke-WebRequest -Uri $rURL).Content
    Invoke-Expression -Command $rCode
}
```

Now check for the Commands again:

```PowerShell
# Testing for Functions - Now the functions are in memory
PS C:\> Get-Command *ADObjectOwner*

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Get-ADObjectOwner
Function        Set-ADObjectOwner


PS C:\> _
```

## Examples

When using the Set-ADObjectOwner, use it with the Get-SecurityPrincipalNTAccount set as a variable like shown below:

```PowerShell

PS C:\> $newOwner = Get-SecurityPrincipalNTAccount -SAMAccountName 'Domain Admins'

PS C:\> Get-ADObject -SearchBase "OU=TestOU,DC=YourDomain,DC=local" -Filter * | Get-ADObjectOwner | Where-Object { $_.Owner -ne $newOwner } | Set-ADObjectOwner -Owner $newOwner

DistinguishedName                                      Owner
-----------------                                      -----
CN=JohnSmith,OU=DomainComputers,DC=YourDomain,DC=local YourDomain\Domain Admins
CN=WS001,OU=DomainComputers,DC=YourDomain,DC=local     YourDomain\Domain Admins

PS C:\> _

```

By setting the Owner in an variable you will obtain a far better performance, since the UserPrincipal will not have to be generated on each Set-ADObjectOwner.

### Functions

#### Get-ADObjectOwner

```PowerShell
<#
.SYNOPSIS
    Gets Object Owner, from the Access Control List on an ADObject.

.DESCRIPTION
    Gets the ACL of an ADObject, and returns the Object Owner.

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

.INPUTS
    [string]

.OUTPUTS
    [PSCustomObject]

.LINK
    Set-ADObjectOwner

#>
```

#### Get-SecurityPrincipalNTAccount

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

.INPUTS
    [string],[string]

.OUTPUTS
    [System.Security.Principal.NTAccount]

#>
```

#### Set-ADObjectOwner

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

.INPUTS
    [string],[System.Security.Principal.NTAccount]

.OUTPUTS
    [PSCustomObject]

.LINK
    Get-ADObjectOwner
    Get-SecurityPrincipalNTAccount

#>
```

# ADObjectOwner

Small PowerShell Module for making the process of changing the Owner defined in the ACL on ADObjects.

## Importing the Module

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

## Tips & Tricks

When using the Set-ADObjectOwner, and the Get-SecurityPrincipalNTAccount, use it through a parameter as below:

```PowerShell

PS C:\> $newOwner = Get-SecurityPrincipalNTAccount -SAMAccountName 'Domain Admins'

PS C:\> Get-ADObject -Identity "OU=Testing,DC=YourDomain,DC=local" | Set-ADObjectOwner -Owner $newOwner

DistinguishedName                 Owner
-----------------                 -----
OU=Testing,DC=YourDomain,DC=local YourDomain\Domain Admins

PS C:\> _

```

If you pipe more than one ADObject into the Set-ADObjectOwner, you will save a lot of time, since the Owner is static, and not generated on each Object.

## Functions

### Get-ADObjectOwner

### Get-SecurityPrincipalNTAccount

### Set-ADObjectOwner

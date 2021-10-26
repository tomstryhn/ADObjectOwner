# ADObjectOwner

PowerShell Module, for making the process of changing the Owner of ADObjects that much easier and quick.

## Usescenarios

### User domain-joined computers

Per default users have the option in ADDS to join up to 10 devices, most Administrators disable this option, but should any User already have Domain Joined one or more computers to the domain, they will automaticly be the Owner of the Object. This can in some cases be a security issue, since any Owner of an Object in ADDS have permissions to delegate rights to the object(s) they "own". This can also from time to time as a sideeffect casue that you as an administrator are unable to remove some of the Security Permissions, unless you change the Owner of the Object. This module makes changing Ownership in Bulk a walk in the park.

## Importing the Module

### The correct way

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

### The Ninja Way

Alternatively, if you dont have the option to clone the Repo and importing the module, you can do it the "Ninja Way" and load the functions directly into memory of your PowerShell session. Be aware depending on the security in your enviroment, you could trigger one or more alarms, since this method leverages the same workaround as hackers use, when trying to load scripts, without saving them on disk.

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

```PowerShell
# Testing for Functions - Now the functions are in memory
PS C:\> Get-Command *ADObjectOwner*

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Get-ADObjectOwner
Function        Set-ADObjectOwner


PS C:\> _
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

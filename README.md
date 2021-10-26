# ADObjectOwner

Small PowerShell Module for making the process of changing the Owner defined in the ACL on ADObjects.

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

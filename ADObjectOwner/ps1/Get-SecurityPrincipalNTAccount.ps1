#Requires -Modules ActiveDirectory

function Get-SecurityPrincipalNTAccount {

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

    [CmdletBinding()]
    Param(
        #sAMAccount Name
        [Parameter(
            Mandatory   = $true
        )]
        [string]
        $SAMAccountName,

        #Domain NetBIOS Name, if other than current
        [Parameter()]
        [string]
        $Domain
    )

    if (!$Domain) {
        $Domain = (Get-ADDomain).NetBIOSName
    }

    $ntAccount = New-Object System.Security.Principal.NTAccount($Domain, $SAMAccountName)

    try {

        $sidFromNTAccount = $ntAccount.Translate([System.Security.Principal.SecurityIdentifier]).Value
        $sAMAccountNameFromSID = ([ADSI]"LDAP://<SID=$sidFromNTAccount>").sAMAccountName

    }
    catch {

        Write-Error -Message "Unable to validate credentials in domain" -ErrorAction Stop

    }

    if (($ntAccount.Value -split '\\')[1] -eq $sAMAccountNameFromSID) {
        $ntAccount
    } else {
        Write-Error -Message "Not valid credential" -ErrorAction Stop
    }
}
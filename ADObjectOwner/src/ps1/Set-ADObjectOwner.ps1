#Requires -Modules ActiveDirectory

<#PSScriptInfo

.DESCRIPTION Sets the Access Control List Owner on an AD Object

.VERSION 1.0.1.1

.GUID 1f734259-d1b1-4ec1-9c25-56e06f381fc1

.AUTHOR Tom Stryhn

.COMPANYNAME Tom Stryhn

.COPYRIGHT 2021 (c) Tom Stryhn

.LICENSEURI https://github.com/tomstryhn/ADObjectOwner/blob/main/LICENSE

.PROJECTURI https://github.com/tomstryhn/ADObjectOwner

#>

function Set-ADObjectOwner {

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

    [CmdletBinding()]
    param (
        # DistinguishedName
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            Mandatory                       = $true
        )]
        [string]
        $DistinguishedName,

        # Owner
        [Parameter(
            Mandatory                       = $true
        )]
        [System.Security.Principal.NTAccount]
        $Owner
    )
    
    process {
        try {

            $objectPath = "ActiveDirectory:://RootDSE/" + $DistinguishedName
            $objectACL  = Get-Acl -Path $objectPath -ErrorAction Stop
        }
        catch {

            Write-Error -Message "Error getting ACL: [$DistinguishedName]" -ErrorAction Stop
        }
        try {

            $objectACL.SetOwner($Owner)
            Set-Acl -Path $objectPath -AclObject $objectACL -ErrorAction Stop
            Get-ADObjectOwner -DistinguishedName $DistinguishedName -ErrorAction Stop
        }
        catch {

            Write-Error -Message "Error setting ACL: [$DistinguishedName]" -ErrorAction Stop
        }
    }
}
#Requires -Modules ActiveDirectory

<#PSScriptInfo

.DESCRIPTION Gets the ACL of an ADObject, and returns the Object Owner

.VERSION 1.0.1.0

.GUID 266e43f6-5117-47cb-b7d0-9321fc3739ce

.AUTHOR Tom Stryhn

.COMPANYNAME Tom Stryhn

.COPYRIGHT 2021 (c) Tom Stryhn

.LICENSEURI https://github.com/tomstryhn/ADObjectOwner/blob/main/LICENSE

.PROJECTURI https://github.com/tomstryhn/ADObjectOwner

#>

function Get-ADObjectOwner {

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
    
    [CmdletBinding()]
    param (
        # DistinguishedName
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            Mandatory                       = $true
        )]
        [string]
        $DistinguishedName
    )
    
    process {

        try {

            $objectACL = Get-Acl -Path ("ActiveDirectory:://RootDSE/" + $DistinguishedName)
            $output = [PSCustomObject]@{
                DistinguishedName = $DistinguishedName
                Owner             = $objectACL.Owner
            }
            $output

        }
        catch {

            Write-Error -Message "Error getting ACL: [$DistinguishedName]"

        }
    }
}
function Get-ADObjectOwner {

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
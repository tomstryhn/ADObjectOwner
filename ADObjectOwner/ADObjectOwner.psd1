@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'ADObjectOwner.psm1'

    # Version number of this module.
    ModuleVersion = '1.0.1.0'

    # ID used to uniquely identify this module
    GUID = 'fce00063-4fe4-433c-887d-8692586e13d2'

    # Author of this module
    Author = 'Tom Stryhn'

    # Company or vendor of this module
    CompanyName = 'Tom Stryhn'

    # Copyright statement for this module
    Copyright = 'Copyright (c) 2021 Tom Stryhn'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @('ActiveDirectory')

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @('Get-ADObjectOwner',
                          'Set-ADObjectOwner',
                          'Get-SecurityPrincipalNTAccount')

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = '*'

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    FileList = @('ADObjectOwner.psd1',
                 'ADObjectOwner.psm1',
                 'LICENSE',
                 '.\src\ps1\Get-ADObjectOwner.ps1',
                 '.\src\ps1\Get-SecurityPrincipalNTAccount.ps1',
                 '.\src\ps1\Set-ADObjectOwner.ps1')

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            # Tags = @()

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/tomstryhn/ADObjectOwner/blob/main/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/tomstryhn/ADObjectOwner'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''

        } # End of PSData hashtable

    } # End of PrivateData hashtable
}

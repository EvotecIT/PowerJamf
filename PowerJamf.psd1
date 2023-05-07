﻿@{
    AliasesToExport        = @()
    Author                 = 'Przemyslaw Klys'
    CmdletsToExport        = @()
    CompanyName            = 'Evotec'
    CompatiblePSEditions   = @('Desktop', 'Core')
    Copyright              = '(c) 2011 - 2023 Przemyslaw Klys @ Evotec. All rights reserved.'
    Description            = 'PowerJamf is an unofficial PowerShell module for Jamf Pro.'
    DotNetFrameworkVersion = '4.5.2'
    FunctionsToExport      = @('Connect-Jamf', 'Get-JamfDevice', 'Get-JamfDeviceDetail')
    GUID                   = 'bcbc98de-69f9-4579-89e7-b5807932eb7e'
    ModuleVersion          = '0.2.0'
    PowerShellVersion      = '5.1'
    PrivateData            = @{
        PSData = @{
            Tags                       = @('Windows', 'MacOS', 'Linux')
            IconUri                    = 'https://resources.jamf.com/images/icons/jamf-og-image.jpg'
            ProjectUri                 = 'https://github.com/EvotecIT/PowerJamf'
            ExternalModuleDependencies = @('Microsoft.PowerShell.Utility')
        }
    }
    RequiredModules        = @('Microsoft.PowerShell.Utility')
    RootModule             = 'PowerJamf.psm1'
}
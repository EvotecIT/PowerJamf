function Convert-JamfDevice {
    [CmdletBinding()]
    param(
        [PSCustomObject[]] $Devices
    )
    foreach ($Device in $Devices) {
        $ConvertedDevice = [ordered] @{
            Id   = $Device.id
            Udid = $Device.udid
        }
        foreach ($Key in $Device.General.PSObject.Properties.Name) {
            $ConvertedDevice[$Key] = $Device.General.$Key
        }
        $Additions = [ordered] @{
            DiskEncryption = $Device.diskEncryption
            # LocalUserAccounts     = $Device.localUserAccounts
            # Purchasing            = $Device.purchasing
            # Printers              = $Device.printers
            # Storage               = $Device.storage
            # Applications          = $Device.applications
            # UserAndLocation       = $Device.userAndLocation
            # ConfigurationProfiles = $Device.configurationProfiles
            # Services              = $Device.services
            # Plugins               = $Device.plugins
            # Hardware              = $Device.hardware
            # Certificates          = $Device.certificates
            # Attachments           = $Device.attachments
            # PackageReceipts       = $Device.packageReceipts
            # Fonts                 = $Device.fonts
            # Security              = $Device.security
            # OperatingSystem       = $Device.operatingSystem
            # LicensedSoftware      = $Device.licensedSoftware
            # SoftwareUpdates       = $Device.softwareUpdates
            # GroupMemberships      = $Device.groupMemberships
            # ExtensionAttributes   = $Device.extensionAttributes
            # ContentCaching        = $Device.contentCaching
            # Ibeacons              = $Device.ibeacons
        }
        $ProperDevice = $ConvertedDevice + $Additions
        [PScustomObject] $ProperDevice
    }

}
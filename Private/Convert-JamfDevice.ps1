function Convert-JamfDevice {
    [CmdletBinding()]
    param(
        [PSCustomObject[]] $Devices
    )
    foreach ($Device in $Devices) {
        $ConvertedDevice = [ordered] @{
            Id                                   = $Device.id
            Udid                                 = $Device.udid
            name                                 = $Device.General.name
            lastIpAddress                        = $Device.General.lastIpAddress
            lastReportedIp                       = $Device.General.lastReportedIp
            jamfBinaryVersion                    = $Device.General.jamfBinaryVersion
            lastContactTime                      = if ($Device.General.lastContactTime) { [DateTime]::Parse($Device.General.lastContactTime) } else { $null }
            lastCloudBackupDate                  = if ($Device.General.lastCloudBackupDate) { [DateTime]::Parse($Device.General.lastCloudBackupDate) } else { $null }
            lastEnrolledDate                     = if ($Device.General.lastEnrolledDate) { [DateTime]::Parse($Device.General.lastEnrolledDate) } else { $null }
            mdmProfileExpiration                 = if ($Device.General.mdmProfileExpiration) { [DateTime]::Parse($Device.General.mdmProfileExpiration) } else { $null }
            initialEntryDate                     = if ($Device.General.initialEntryDate) { [DateTime]::Parse($Device.General.initialEntryDate) } else { $null }
            platform                             = $Device.General.platform
            remoteManagementManaged              = $Device.General.remoteManagement.managed
            remoteManagementUserName             = $Device.General.remoteManagement.managementUsername
            supervised                           = $Device.General.supervised
            mdmCapable                           = $Device.General.mdmCapable.capable
            mdmCapableCapableUsers               = $Device.General.mdmCapable.capableUsers
            reportDate                           = if ($Device.General.reportDate) { [DateTime]::Parse($Device.General.reportDate) } else { $null }
            distributionPoint                    = $Device.General.distributionPoint
            siteId                               = $Device.General.site.id
            siteName                             = $Device.General.site.name
            itunesStoreAccountActive             = $Device.General.itunesStoreAccountActive
            enrolledViaAutomatedDeviceEnrollment = $Device.General.enrolledViaAutomatedDeviceEnrollment
            userApprovedMdm                      = $Device.General.userApprovedMdm
            enrollmentMethod                     = $Device.General.enrollmentMethod
            declarativeDeviceManagementEnabled   = $Device.General.declarativeDeviceManagementEnabled
            managementId                         = $Device.General.managementId
            #extensionAttributes                  = $Device.General.extensionAttributes
            barcode1                             = $Device.General.barcode1
            barcode2                             = $Device.General.barcode2
            assetTag                             = $Device.General.assetTag
        }
        [PScustomObject] $ConvertedDevice
    }
}
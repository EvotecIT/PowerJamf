function Get-JamfDevice {
    [CmdletBinding()]
    param(
        [string] $Id,
        [switch] $Native
    )
    $Organization = $Script:JamfTokenInformation.Organization
    $Url = "https://$Organization.jamfcloud.com/api/v1/computers-inventory"
    if ($id) {
        $Url = "$Url/$id"
    }
    $Data = Invoke-JamfQuery -Url $Url
    if ($Native) {
        if ($Id) {
            $Data
        } else {
            $Data.results
        }
    } else {
        if ($Id) {
            Convert-JamfDevice -Devices $Data
        } else {
            Convert-JamfDevice -Devices $Data.results
        }
    }
}
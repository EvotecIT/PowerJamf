function Get-JamfDeviceDetail {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string] $Id
    )
    $Organization = $Script:JamfTokenInformation.Organization
    $Url = "https://$Organization.jamfcloud.com/api/v1/computers-inventory-detail"
    if ($id) {
        $Url = "$Url/$id"
    }
    $Data = Invoke-JamfQuery -Url $Url
    $Data
}
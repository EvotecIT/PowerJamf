function Get-JamfDevices {
    [CmdletBinding()]
    param(
        [switch] $Native
    )
    Write-Verbose -Message "Get-JamfDevices - Starting"
    if (-not $Script:JamfTokenInformation) {
        Write-Warning -Message "Get-JamfDevices - No Jamf token information found. Please run Connect-Jamf first."
        return
    } else {
        Connect-Jamf -ExistingToken
    }
    if (-not $Script:JamfTokenInformation) {
        Write-Warning -Message "Get-JamfDevices - No Jamf token information found. Please run Connect-Jamf first."
        return
    }
    $Organization = $Script:JamfTokenInformation.Organization
    $Url = "https://$Organization.jamfcloud.com/api/v1/computers-inventory"
    if ($id) {
        $Url = "$Url/$id"
    }

    $invokeRestMethodSplat = @{
        Method  = "GET"
        Uri     = $Url
        Headers = [ordered] @{
            'Content-Type'  = 'application/json; charset=utf-8'
            'Authorization' = "Bearer $($Script:JamfTokenInformation.Token)"
            'Cache-Control' = 'no-cache'
        }
    }

    $Data = Invoke-RestMethod @invokeRestMethodSplat
    if ($Native) {
        $Data.results
    } else {
        Convert-JamfDevice -Devices $Data.results
    }

}
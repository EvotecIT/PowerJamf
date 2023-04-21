function Invoke-JamfQuery {
    [cmdletBinding()]
    param(
        [Parameter(Mandatory)][string] $Url
    )
    if (-not $Script:JamfTokenInformation) {
        Write-Warning -Message "Invoke-JamfQuery - No Jamf token information found. Please run Connect-Jamf first."
        return
    } else {
        Connect-Jamf -ExistingToken
    }
    if (-not $Script:JamfTokenInformation) {
        Write-Warning -Message "Invoke-JamfQuery - No Jamf token information found. Please run Connect-Jamf first."
        return
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
    Write-Verbose -Message "Invoke-JamfQuery - Querying $Url"
    try {
        $Data = Invoke-RestMethod @invokeRestMethodSplat -ErrorAction Stop -Verbose:$false
    } catch {
        Write-Warning -Message "Get-JamfDevices - Error querying $Url. Error $($_.Exception.Message)"
        return
    }
    $Data
}
function Get-JamfDevice {
    [CmdletBinding()]
    param(
        [string] $Id,
        [switch] $Native,
        [int] $Page,
        [int] $PageSize = 1000000
    )
    $Organization = $Script:JamfTokenInformation.Organization

    $QueryParameter = [ordered] @{
        'page-size' = if ($PSBoundParameters.ContainsKey('Id')) { $null } else { $PageSize }
        'page'      = if ($PSBoundParameters.ContainsKey('Page')) { $Page } else { $null }
    }
    # lets remove empty values to remove whatever user hasn't requested
    Remove-EmptyValue -Hashtable $QueryParameter

    if (-not $Organization) {
        Write-Warning -Message 'Get-JamfDevice - Organization not set. Use Connect-Jamf to set it.'
        return
    }

    # Lets build our url
    $BaseUri = "https://$Organization.jamfcloud.com/api/v1/computers-inventory"
    $Url = Join-UriQuery -BaseUri $BaseUri -QueryParameter $QueryParameter

    if ($id) {
        $Url = "$Url/$id"
    }

    Write-Verbose -Message "Get-JamfDevice - Using query: $Url"

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
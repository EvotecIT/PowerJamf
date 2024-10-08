﻿
function Connect-Jamf {
    [CmdletBinding(DefaultParameterSetName = 'UserName')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'PasswordEncrypted')]
        [Parameter(Mandatory, ParameterSetName = 'UserName' )]
        [Parameter(Mandatory, ParameterSetName = 'Credential' )]
        [string] $Organization,
        [Parameter(Mandatory, ParameterSetName = 'PasswordEncrypted')]
        [Parameter(Mandatory, ParameterSetName = 'UserName')]
        [string] $UserName,
        [Parameter(Mandatory, ParameterSetName = 'UserName')][securestring] $Password,
        [Parameter(Mandatory, ParameterSetName = 'PasswordEncrypted')][string] $PasswordEncrypted,

        [Parameter(Mandatory, ParameterSetName = 'Credential')][pscredential] $Credential,
        [Parameter(ParameterSetName = 'PasswordEncrypted')]
        [Parameter(ParameterSetName = 'UserName')]
        [Parameter(ParameterSetName = 'Credential')]
        [switch] $Suppress,
        [Parameter(ParameterSetName = 'PasswordEncrypted')]
        [Parameter(ParameterSetName = 'UserName')]
        [Parameter(ParameterSetName = 'Credential')]
        [Parameter(DontShow, ParameterSetName = 'ExistingToken')]
        [switch] $Force,
        [Parameter(DontShow, ParameterSetName = 'ExistingToken')]
        [switch] $ExistingToken
    )

    # Check for curent token
    $CurrentTime = (Get-Date).AddSeconds(20)
    if ($Script:JamfTokenInformation.expires -lt $CurrentTime -or $Force) {
        if ($ExistingToken) {
            Write-Verbose -Message "Connect-Jamf - Using existing token within command"
            $Url = $Script:JamfTokenInformation.Url
            $Headers = $Script:JamfTokenInformation.Headers
        } else {
            Write-Verbose -Message "Connect-Jamf - Creating new token."
            if ($Credential) {
                $UserName = $Credential.UserName
                $ConvertedPassword = $Credential.GetNetworkCredential().Password
            } elseif ($UserName -and $Password) {
                $ConvertedPassword = [System.Net.NetworkCredential]::new("", $Password).Password
            } elseif ($UserName -and $PasswordEncrypted) {
                $ConvertedPasswordSecure = ConvertTo-SecureString -String $PasswordEncrypted -Force
                $ConvertedPassword = [System.Net.NetworkCredential]::new("", $ConvertedPasswordSecure).Password
            } else {
                return
            }

            $Bytes = [Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $UserName, $ConvertedPassword))
            $AuthorizationInfo = [Convert]::ToBase64String($Bytes)


            $Url = "https://$Organization.jamfcloud.com/api/v1/auth/token"
            $Headers = [ordered] @{
                Accept        = "application/json"
                Authorization = "Basic $AuthorizationInfo"
            }

            $Script:JamfTokenInformation = [ordered] @{
                Organization = $Organization
                Url          = $Url
                Headers      = $Headers
                Token        = $null
                Expires      = $null
            }
        }

        try {
            $Token = Invoke-RestMethod -Method Post -Uri $Url -Headers $Headers -ErrorAction Stop -Verbose:$false
        } catch {
            Write-Warning -Message "Connect-Jamf - Unable to connect to organization '$Organization' with user '$UserName'. Error $($_.Exception.Message)"
            return
        }
        $Script:JamfTokenInformation.Token = $Token.token
        $Script:JamfTokenInformation.Expires = [DateTime]::Parse($Token.Expires)
        if (-not $Suppress) {
            $Script:JamfTokenInformation
        }
    } else {
        $WhenExpires = $Script:JamfTokenInformation.expires - $CurrentTime
        Write-Verbose -Message "Connect-Jamf - Using existing cached token (Expires in: $WhenExpires)"
        if (-not $Suppress -and -not $ExistingToken) {
            $Script:JamfTokenInformation
        }
    }
}
# Put in your Client ID from Central
$clientid = ""

# Put in your Client Secret from Central
$clientsecret = ""

# URI to authenticate with Central
$authuri = "https://id.sophos.com/api/v2/oauth2/token"

# Body of the authentication request
$authbod = @{
 "grant_type" = 'client_credentials'
 "scope" = 'token'
 "client_id" = $clientid
 "client_secret" = $clientsecret
} 

# POST request to get bearer token
$auth = Invoke-RestMethod -uri $authuri -Method Post -Body $authbod -ContentType application/x-www-form-urlencoded

# This grabs the bearer token from the above POST request
$bearer = $auth.access_token

# After authenticating and grabbing the bearer token, place bearer token in header for future requests

$header = @{ 
Authorization = "Bearer $($bearer)"
'X-Tenant-ID' = ""
}


$endpointuri = "https://api-us01.central.sophos.com/endpoint/v1/settings/allowed-items"

$exclusions = Invoke-RestMethod -ur $endpointuri -header $header
# Put in your Client ID from Central
$clientid = "[YOUR CLIENT ID]"

# Put in your Client Secret from Central
$clientsecret = "[YOUR TENANT ID]"

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
'X-Tenant-ID' = "[YOUR TENANT ID"
}

# uri to list out machines where Tamper Protection is enabled

$tampuri = "https://api-us01.central.sophos.com/endpoint/v1/endpoints?tamperProtectionEnabled=true"

# GET request to list out machines with TP enabled

$truetamp = Invoke-RestMethod -uri $tampuri -Headers $header

# list out machines with TP enabled and their IDs

$tpONlist = $truetamp.items | Select-Object -Property hostname,id

# uri section for a specific endpoint

$endpointuri = "https://api-us01.central.sophos.com/endpoint/v1/endpoints/"

# Body of GET request to disable TP

$body = @{
 "enabled" = 'false'
} |  ConvertTo-Json

# Turn off TP by taking a list of TP enabled machines, taking the first machine in the list and adding it to the endpoint uri

$turnoff = Invoke-RestMethod -Headers $header -Method Post -Body $body -ContentType 'application/json' -uri "$($endpointuri)$($truetamp.items.id.GetValue(0))/tamper-protection"

# print the new list of machines with TP enabled

$tpONlist
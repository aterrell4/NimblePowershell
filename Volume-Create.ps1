# Built By: Adam Terrell
# Email: aterrell@vertisys.com 

####################
#Preliminary Setup #
####################
# Invoke VisualBasic For Credentials 
Add-Type -AssemblyName Microsoft.VisualBasic
# Define Variables and Gather User Generated Info
$MessageBox = 'Enter Credentials'
$Message0 = 'Enter Array Target'
$Message1 = 'Enter Username'
$Message2 = 'Enter Password'
$Message3 = 'Enter Volume Name'
$Message4 = 'Enter Volume Size In Megabytes'
$AR = [Microsoft.VisualBasic.Interaction]::InputBox($Message0,$MessageBox)
$UN = [Microsoft.VisualBasic.Interaction]::InputBox($Message1,$MessageBox)
$PW = [Microsoft.VisualBasic.Interaction]::InputBox($Message2,$MessageBox)  
# Long Term Goal to Adjust to use shared key or alternate form of automated authentication.
$VOLN = [Microsoft.VisualBasic.Interaction]::InputBox($Message3,$MessageBox)
$VOLS = [Microsoft.VisualBasic.Interaction]::InputBox($Message4,$MessageBox)
# Enable HTTPS Communication
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
################################
# Generate session based Token #
################################
# Convert Variables to List
$data = @{
    username = $UN
    password = $PW
}
# Take data from above and convert to json for ingestation
$body = convertto-json (@{ data = $data })
# Structure API request with Login Credentials from Above and use this to generate Token
$uri = "https://" + $AR + ":5392/v1/tokens"
$token = Invoke-RestMethod -Uri $uri -Method Post -Body $body
$token = $token.data.session_token
$token
###################
# Create a Volume #
###################
# Define Performance Policy_ID as well as format Variables to List
$perfpolicy = "034038334fffeea31800000000000000000000001c"
$data = @{
    name = $VOLN
    perfpolicy_id = $perfpolicy
    size = $VOLS
}
# Structure API request with Volume Name, Performance Policy_ID and Size.
$body = convertto-json (@{ data = $data })
$header = @{ "X-Auth-Token" = $token }
$uri = "https://" + $AR + ":5392/v1/volumes"
$result = Invoke-RestMethod -Uri $uri -Method Post -Body $body -Header $header
# Show Us The Results
$result.data | select name,size,description,target_name | format-table -autosize
###################
# Get Volume List #
###################
# Structure API request to Array. Pass token for authentication
$header = @{ "X-Auth-Token" = $token }
$uri = "https://" + $AR + ":5392/v1/volumes"
$volume_list = Invoke-RestMethod -Uri $uri -Method Get -Header $header
$vol_array = @();
# Loop this task for each of the items present in the volume list received from the array. Store in variable array. 
foreach ($volume_id in $volume_list.data.id){
    
    $uri = "https://" + $AR + ":5392/v1/volumes/" + $volume_id
    $volume = Invoke-RestMethod -Uri $uri -Method Get -Header $header
    #write-host $volume.data.name :     $volume.data.id
    $vol_array += $volume.data
    
}
#################
# Print Results #
#################
# Show Us The Results
$vol_array | sort-object size,name -descending | select size,name,online,agent_type,target_name | format-table -autosize
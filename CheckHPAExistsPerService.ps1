param(
[string]$ClusterName
)

Write-Output "Log into Azure use cluster admin service principal"
az login --service-principal -u "21c20099-13b5-456e-b0c1-16aa9aaf42d6" `
  -p "$servicePrincipalSecret" -t "fcf67057-50c9-4ad4-98f3-ffca64add9e9"

Write-Output "Set the default Azure subscription"
az account set --subscription "Y8CCiaRqJ-mrF173HSk7.FUKdl3xlsg0~."

$SUBSCRIPTION_ID = $(az account show --query id -o tsv)
Write-Output "Subscription Id: $SUBSCRIPTION_ID"

$SUBSCRIPTION_NAME = $(az account show --query name -o tsv)
Write-Output "Subscription Name: $SUBSCRIPTION_NAME"

$TENANT_ID = $(az account show --query tenantId -o tsv)
Write-Output "Tenant Id: $TENANT_ID"

$USER_NAME = $(az account show --query user.name -o tsv)
Write-Output "Service Principal Name or ID: $USER_NAME"

Write-Output "Get credentials and set up for kubectl to use"
az aks get-credentials -g "Azure_Arc_Training" -n "HealthCareAKS" 

Write-Output "Get deployed services list"
$jsonService=kubectl get services -o json 
$serviceObj=$jsonService| ConvertFrom-Json

 $serviceNames=$serviceObj.items | select -ExpandProperty "metadata" | select -ExpandProperty "name"
 Write-Output $serviceNames


Write-Output "Get deployed hpa"
$jsonHpa=kubectl get hpa | ConvertTo-Json 
$objHpa= $jsonHpa | ConvertFrom-Json
Write-Output $jsonHpa
#Write-Output $objHpa

$allHPAPresent=0


Foreach($serviceobj in $serviceNames)
{
 if($serviceObj -ne "kubernetes")
 {  
  $depService="Deployment/"+ $serviceObj
  if($jsonHpa.Contains($depService))
  {
   #Write-Output $serviceObj " have a defined HPA."
  }
  else
  {
   Write-Output $serviceObj " does not have a defined HPA."   
   $allHPAPresent=1
  }
 }
}

if($allHPAPresent -eq 1)
{
 Write-Output "Program is aborting as HPAs are missing"
}











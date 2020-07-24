Write-Output "Log into Azure use cluster admin service principal"
$spApplicationId="21c20099-13b5-456e-b0c1-16aa9aaf42d6"
$spSecret="Y8CCiaRqJ-mrF173HSk7.FUKdl3xlsg0~."
$userPassword = ConvertTo-SecureString -String $spSecret -AsPlainText -Force
$pscredential = New-Object -TypeName System.Management.Automation.PSCredential($spApplicationId, $userPassword)
Connect-AzAccount -ServicePrincipal -Credential $pscredential -Tenant "ca42b5b8-5d42-40d8-b44b-a2ce4dc7f8dd"

Write-Output "Set the default Azure subscription"
az account set --subscription "05bc92a8-0ea0-4c4d-b5d7-cd6d9eefe888"

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

Write-Output "Get deployed resource quota"
$jsonResourceQuota=kubectl describe quota compute-resources --namespace=default | ConvertTo-Json 
$objResourceQuota= $jsonResourceQuota | ConvertFrom-Json
Write-Output $objResourceQuota | Out-File "C:\JSONOutput\ResourceQuotaOutput.txt"
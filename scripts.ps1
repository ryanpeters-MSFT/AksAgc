$group = "rg-aks-agc"
$clusterName = "agccluster"
$identityName = "ryanagc"

$groupId = (az group create -n $group -l eastus2 --query id -o tsv)

$principalId = (az identity create -g $group -n $identityName --query principalId)

#Start-Sleep -Seconds 10

#az aks create -n $clusterName -g $group --network-plugin azure --enable-oidc-issuer --enable-workload-identity -c 2 --node-osdisk-type ephemeral --node-vm-size Standard_DS3_v2
#az role assignment create --assignee-object-id $principalId --assignee-principal-type ServicePrincipal --scope $groupId --role "acdd72a7-3385-48ef-bd42-f606fba81ae7" # Reader role

#Start-Sleep -Seconds 10

$oidcIssuer = (az aks show -n $clusterName -g $group --query "oidcIssuerProfile.issuerUrl" -o tsv)

#az identity federated-credential create --name "azure-alb-identity" --identity-name $identityName -g $group --issuer $oidcIssuer --subject "system:serviceaccount:alb:alb-controller-sa"

#az aks get-credentials --resource-group $group --name $clusterName

#kubectl create ns alb

#helm install alb-controller oci://mcr.microsoft.com/application-lb/charts/alb-controller --namespace "alb" --version 1.0.0 --set albController.namespace="alb" --set albController.podIdentity.clientID=$(az identity show -g $group -n $identityName --query clientId -o tsv)

# create the subnet for the ALB resource

# delegate permissions to the subnet

# Delegate AppGw for Containers Configuration Manager role to AKS Managed Cluster RG
az role assignment create --assignee-object-id $principalId --assignee-principal-type ServicePrincipal --scope $groupId --role "fbc52c3f-28ad-4303-a892-8a056630b8f1" 

# Delegate Network Contributor permission for join to association subnet
az role assignment create --assignee-object-id $principalId --assignee-principal-type ServicePrincipal --scope "/subscriptions/24ef1668-95f3-4c77-adf2-2d023271a3e1/resourceGroups/MC_rg-aks-agc_agccluster_eastus2/providers/Microsoft.Network/virtualNetworks/aks-vnet-21266979/subnets/agc" --role "4d97b98b-1d4f-4787-a291-c67834d212e7" 




az role assignment create --assignee-object-id $principalId --assignee-principal-type ServicePrincipal --scope "/subscriptions/24ef1668-95f3-4c77-adf2-2d023271a3e1/resourceGroups/MC_rg-aks-agc_agccluster_eastus2/providers/Microsoft.Network/virtualNetworks/aks-vnet-21266979/subnets/agc" --role "4d97b98b-1d4f-4787-a291-c67834d212e7" 
$group = "rg-aks-agc"
$clusterName = "agccluster"
$identityName = "ryanagc"

$groupId = (az group create -n $group -l eastus2 --query id -o tsv)

$principalId = (az identity create -g $group -n $identityName --query principalId)

Start-Sleep -Seconds 10

az aks create -n $clusterName -g $group --network-plugin azure --enable-oidc-issuer --enable-workload-identity -c 2 --node-osdisk-type ephemeral --node-vm-size Standard_DS3_v2
az role assignment create --assignee-object-id $principalId --assignee-principal-type ServicePrincipal --scope $groupId --role "acdd72a7-3385-48ef-bd42-f606fba81ae7" # Reader role

Start-Sleep -Seconds 10

$oidcIssuer = (az aks show -n $clusterName -g $group --query "oidcIssuerProfile.issuerUrl" -o tsv)

az identity federated-credential create --name "azure-alb-identity" --identity-name $identityName -g $group --issuer $oidcIssuer --subject "system:serviceaccount:azure-alb-system:alb-controller-sa"

az aks get-credentials --resource-group $group --name $clusterName

kubectl create ns alb

helm install alb-controller oci://mcr.microsoft.com/application-lb/charts/alb-controller --namespace "alb" --version 1.0.0 --set albController.namespace="alb" --set albController.podIdentity.clientID=$(az identity show -g $group -n $identityName --query clientId -o tsv)
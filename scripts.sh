# LINKS
- https://learn.microsoft.com/en-us/azure/application-gateway/for-containers/quickstart-deploy-application-gateway-for-containers-alb-controller
- https://learn.microsoft.com/en-us/azure/application-gateway/for-containers/quickstart-create-application-gateway-for-containers-managed-by-alb-controller?tabs=new-subnet-aks-vnet
- https://learn.microsoft.com/en-us/azure/application-gateway/for-containers/how-to-path-header-query-string-routing-gateway-api?tabs=alb-managed

# create azure identity
az identity create -g rg-aks-cni -n ryanagc

# grab the principalId for role creation (az identity show -g rg-aks-cni -n ryanagc)
az role assignment create --assignee-object-id dac7b0ce-cbb4-45ef-a91c-08c8865a4632 --assignee-principal-type ServicePrincipal --scope /subscriptions/24ef1668-95f3-4c77-adf2-2d023271a3e1/resourceGroups/MC_rg-aks-cni_cnicluster_eastus2 --role "acdd72a7-3385-48ef-bd42-f606fba81ae7"

# get the OIDC issuer URL
# NOTE: ALB Controller requires a federated credential with the name of azure-alb-identity. Any other federated credential name is unsupported.
az identity federated-credential create -n azure-alb-identity --identity-name ryanagc -g rg-aks-cni --issuer https://eastus2.oic.prod-aks.azure.com/16b3c013-d300-468d-ac64-7eda0820b6d3/6f0805f1-f446-485f-bd4e-14e635d1caeb/ --subject "system:serviceaccount:azure-alb-system:alb-controller-sa"

# optionally, list the federated credentials for an identity
az identity federated-credential list -g rg-aks-cni --identity ryanagc -o table

# install the ALB controllers onto the cluster (--version is required as of writing)
helm install alb-controller oci://mcr.microsoft.com/application-lb/charts/alb-controller --version 0.4.023971 --set albController.podIdentity.clientID=$(az identity show -g rg-aks-cni -n ryanagc --query clientId -o tsv)

# verify they're running
kubectl get pods -n azure-alb-system

# Delegate AppGw for Containers Configuration Manager role to AKS Managed Cluster RG
az role assignment create --assignee-object-id dac7b0ce-cbb4-45ef-a91c-08c8865a4632 --assignee-principal-type ServicePrincipal --scope /subscriptions/24ef1668-95f3-4c77-adf2-2d023271a3e1/resourceGroups/MC_rg-aks-cni_cnicluster_eastus2 --role "fbc52c3f-28ad-4303-a892-8a056630b8f1" 

# Delegate Network Contributor permission for join to association subnet
az role assignment create --assignee-object-id dac7b0ce-cbb4-45ef-a91c-08c8865a4632 --assignee-principal-type ServicePrincipal --scope /subscriptions/24ef1668-95f3-4c77-adf2-2d023271a3e1/resourceGroups/MC_rg-aks-cni_cnicluster_eastus2/providers/Microsoft.Network/virtualNetworks/aks-vnet-23612896/subnets/alb --role "4d97b98b-1d4f-4787-a291-c67834d212e7" 
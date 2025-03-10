. .\vars.ps1

$POLICY_NAME = "waf-policy"
$CLUSTER_NAME = "agccluster"

$NODE_RESOURCE_GROUP = az aks show -n $CLUSTER_NAME -g $GROUP --query nodeResourceGroup -o tsv

$AGC_NAME = az network alb list -g $NODE_RESOURCE_GROUP -o tsv --query "[0].name"


# create a WAF policy
az network application-gateway waf-policy create -g $GROUP -n $POLICY_NAME

# set the policy to Prevention
az network application-gateway waf-config set -g $NODE_RESOURCE_GROUP --gateway-name $AGC_NAME --enabled true --firewall-mode Prevention
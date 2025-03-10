# Azure Application Gateway for Containers

Creates a standard App Gateway for Containers. The AGC resource is created within the MC resource group and gets associated with a "alb" subnet.

## WAF Policies

> This content is TBD

A firewall policy can be created and associated with the ALB gateway. 

## Observations/Notes
- It can still take several minutes to reconcile and create the resources. 
- Once the AGC resource has been associated with the "alb" subnet, it will create a "Frontend" with a URL in the format `RANDOMSTRING.RANDOM.alb.azure.com`

## Links
- [Quickstart: Deploy Application Gateway for Containers ALB Controller](https://learn.microsoft.com/en-us/azure/application-gateway/for-containers/quickstart-deploy-application-gateway-for-containers-alb-controller?tabs=install-helm-windows)
- [Quickstart: Create Application Gateway for Containers managed by ALB Controller](https://learn.microsoft.com/en-us/azure/application-gateway/for-containers/quickstart-create-application-gateway-for-containers-managed-by-alb-controller?tabs=new-subnet-aks-vnet)\
- [waf-appgw-for-containers](https://github.com/Azure/waf-appgw-for-containers)
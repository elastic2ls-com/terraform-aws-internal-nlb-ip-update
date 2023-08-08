# Terraform module to update private ip addresses of internal nlb targets
<p align="center">
<img src="/assets/img/Logo_box-1-150x150.png">
</p>
<p>&nbsp;</p>

![License](https://img.shields.io/badge/license-Apache-brightgreen?logo=apache) ![Status](https://img.shields.io/badge/status-active-brightgreen.svg?logo=git) [![Sponsor](https://img.shields.io/badge/sponsors-AlexanderWiechert-blue.svg?logo=github-sponsors)](https://github.com/sponsors/AlexanderWiechert/) [![Contact](https://img.shields.io/badge/follow-@Elastic2lscom-blue.svg?logo=facebook&style=social)](https://www.facebook.com/Elastic2lscom-241339337786673/) [![Terraform Registry](https://img.shields.io/badge/download-blue.svg?logo=terraform&style=social)](https://registry.terraform.io/modules/elastic2ls-com/internal-nlb-ip-update/aws/latest)





This module helps you to update the private IP addresses as registered target in the internal NLB and of course as Route53 entry, if you have a chained setup of NLB's in your private subnets. 
The problem it would solve is, that the private IP's can change anytime. 

* two lambda functions 
* a sns topic
* a cloudwatch event

## Lambdas to update private IP

### dns
Does an update of an A record with the private ip adresses of an ALB.

### ip_update
Does an update of the nlb target group with the private ip adresses of the ALB.

## Sample Usage
This module requires 4 arguments.
* `stage` the stage name will be used in different places.
* `alb_description_name` the description of the internal NLB which private ip address you want to gather.
* `zone_id` the id of the route53 zone which need to be updated.
* `nlb_tg_arn` the arn of the target loadbalancer, which needs to be updated.


```
module "terraform-aws-internal-nlb-ip-update" {
source = "git@github.com:elastic2ls/terraform-aws-internal-nlb-ip-update.git"

  stage                 = var.stage
  alb_description_name  = var.alb_description_name
  zone_id               = var.zone_id
  nlb_tg_arn            = var.nlb_tg_arn
}
```

The module can also be found in the Terraform Registry https://registry.terraform.io/modules/elastic2ls-com/internal-nlb-ip-update/aws/latest.

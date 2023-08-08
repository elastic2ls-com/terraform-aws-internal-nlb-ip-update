#!/usr/bin/env python3
import boto3
import os

## Define ENV variables
ALB_DESCRIPTION_NAME = os.environ['ALB_DESCRIPTION_NAME']
NLB_TG_ARN = os.environ['NLB_TG_ARN']

## Main programm logic
def lambda_handler(event, context):
    ## Get current private IP's of the ALB
    ec2 = boto3.client('ec2')
    response = ec2.describe_network_interfaces(
        Filters = [
            {
                'Name': 'description',
                'Values': [ALB_DESCRIPTION_NAME]
            }
        ]
    )

    current_elb_ips = []
    for nic in response['NetworkInterfaces']:
        current_elb_ips.append(nic['PrivateIpAddress'])

    ## Get current IP's that are registered in Target Group
    elb = boto3.client('elbv2')
    response = elb.describe_target_health(
        TargetGroupArn=NLB_TG_ARN
    )

    registered_elb_ips = []
    for target in response['TargetHealthDescriptions']:
        registered_elb_ips.append(target['Target']['Id'])

    print('Current ALB IPs: {0}\nRegistered ALB IPs: {1}'.format(current_elb_ips, registered_elb_ips))

    ## Check if there is a difference between registered IP's and actual ALB IP's
    if set(current_elb_ips) == set(registered_elb_ips):
        print('Nothing to do!')
        return

    ## If there is a difference, register new IPs
    new_targets = []
    for ip in current_elb_ips:
        new_targets.append({'Id': ip, 'Port': 443})

    response = elb.register_targets(
        TargetGroupArn=NLB_TG_ARN,
        Targets=new_targets
    )

    print('Registered new ALB IPs: {0}'.format(new_targets))

    ## Possible TODO: remove unhealthy targets from ALB? Check if network flow is interrupted when doing registration of already existing target?


## Call lambda handler if executed from console
if __name__ == "__main__":
    lambda_handler([], [])

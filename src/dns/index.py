#!/usr/bin/env python3
import boto3
import os

## Define ENV variables
ALB_DESCRIPTION_NAME = os.environ['ALB_DESCRIPTION_NAME']
ZONE_ID = os.environ['ZONE_ID']
INTRA_DNS_NAME = os.environ['INTRA_DNS_NAME']

def lambda_handler(event, context):
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
        current_elb_ips.append({'Value': nic['PrivateIpAddress']})

    print('Current ALB IPs: {0}'.format(current_elb_ips))


#TODO #use env variables for names, Values and zonename
    client = boto3.client('route53')
    response = client.change_resource_record_sets(
        HostedZoneId=ZONE_ID,
        ChangeBatch={
            'Changes': [
                {
                    'Action': 'UPSERT',
                    'ResourceRecordSet': {
                        'Name': INTRA_DNS_NAME,
                        'Type': 'A',
                        'TTL': 60,
                        'ResourceRecords': current_elb_ips
                    },
                },
            ],
            'Comment': 'Record to acces private ips of alb',
        },
    )

## Call lambda handler if executed from console
if __name__ == "__main__":
    lambda_handler([], [])

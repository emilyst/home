#!/usr/bin/env python3

import boto3

from os import environ


validation_token = environ['CERTBOT_VALIDATION']
challenge        = [{'Value': '"' + validation_token + '"'}]
zone_name        = '.'.join(environ['CERTBOT_DOMAIN'].split('.')[-2:])
record_name      = '_acme-challenge.' + zone_name
client           = boto3.client('route53')
zone_id          = [zone['Id'] for zone in client.list_hosted_zones_by_name()['HostedZones'] if zone_name in zone['Name']][0]
record_precheck  = client.test_dns_answer(HostedZoneId=zone_id, RecordName=record_name, RecordType='TXT')['RecordData']

if record_precheck:
    for record in record_precheck:
        challenge.append({'Value': record})

changes = {
    'Changes': [
        {
            'Action': 'UPSERT',
            'ResourceRecordSet': {
                'Name':            record_name,
                'Type':            'TXT',
                'TTL':             300,
                'ResourceRecords': challenge
            }
        }
    ]
}

waiter   = client.get_waiter('resource_record_sets_changed')
response = client.change_resource_record_sets(HostedZoneId=zone_id, ChangeBatch=changes)
waiter.wait(Id=response['ChangeInfo']['Id'])

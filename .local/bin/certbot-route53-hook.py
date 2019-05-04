#!/usr/bin/env python3

# see https://github.com/spyoungtech/certbot-route53-hook


import os
import time
import boto3
from pprint import pprint

class ZoneIDNotFoundError(RuntimeError):
    pass


def get_zone_id(client=None, zone_name=None):
    if 'CERTBOT_ZONE_ID' in os.environ:
        return os.environ.get('CERTBOT_ZONE_ID')
    try:
        from config import zone_map
        return zone_map[zone_name]
    except (ImportError, KeyError):
        hosted_zones = client.list_hosted_zones()['HostedZones']
        for z in hosted_zones:
            z_name = z['Name']
            id_ = z['Id']
            if zone_name in z_name:
                return id_
        else:
            raise ZoneIDNotFoundError('Could not identify hosted zone ID for zone {}'.format(zone_name))


def main():
    client = boto3.client('route53')
    domain_name = os.environ.get('CERTBOT_DOMAIN')
    zone_name = '.'.join(domain_name.split('.')[-2:])
    zone_id = get_zone_id(client, zone_name)
    challenge = os.environ.get('CERTBOT_VALIDATION')
    challenge = '"{}"'.format(challenge)
    record_name = '_acme-challenge.' + domain_name
    if 'CERTBOT_AUTH_OUTPUT' in os.environ:
        action = 'DELETE'
    else:
        action = 'CREATE'

    print('Processing recordset "{}" {} request for zone ID {}'.format(zone_name, action, zone_id))

    record_change = {
        'Action': action,
        'ResourceRecordSet': {'Name': record_name,
                              'ResourceRecords': [{'Value': challenge}],
                              'TTL': 300,
                              'Type': 'TXT'}}
    kwargs = {'ChangeBatch': {'Changes': [record_change],
                              'Comment': 'add records for cert update'},
              'HostedZoneId': zone_id}

    waiter = client.get_waiter('resource_record_sets_changed')
    response = client.change_resource_record_sets(**kwargs)
    waiter.wait(Id=response['ChangeInfo']['Id'])


if __name__ == '__main__':
    main()

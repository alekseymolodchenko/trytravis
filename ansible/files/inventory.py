#!/usr/bin/env python

import subprocess
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-c', '--count', action='store_true', required=False, dest='count')
parser.add_argument('--list', action='store_true', required=False, dest='list')
args = parser.parse_args()

bash_out = subprocess.Popen("gcloud compute instances list | awk '{ print $5 }' | sed -n 2,100p", shell=True, stdout=subprocess.PIPE).stdout.read()

servers = {
    'all': {
        'hosts': []
    }
}

# Added some logic to account for newer versions of Ansible formatting newlines differently
if '\\n' in bash_out:
    bash_out_list = bash_out.split('\\n')
else:
    bash_out_list = bash_out.split('\n')

# bash_out_list = str(bash_out).split('\n')

server_list = []

for line in bash_out_list:
    server_list.append(line.replace('\'', '').replace("b", ''))

# exception catch in case there aren't any empty lines
try:
    server_list.remove('')
except ValueError:
    pass

for server in server_list:
    servers['all']['hosts'].append(server)

if args.list:
    print(servers)
else:
    print(len(servers['all']['hosts']))

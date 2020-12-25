#! /usr/bin/env python3

import requests 
import sys

COLORS = {
    'international master' : 'FF8C00',
    'grandmaster' : 'FF0000'
}

name = sys.argv[1]
r = requests.get(f'http://codeforces.com/api/user.info', params = {'handles' : name}).json()
assert(r['status'] == 'OK')
r = r['result'][0]
sys.stdout.write(r'\textcolor[HTML]{%s}{%s}' % (COLORS[r['rank']], name))
sys.exit(0)

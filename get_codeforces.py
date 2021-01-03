#! /usr/bin/env python3

from collections import namedtuple
import pickle
import requests 
import sys
import time

COLORS = {
    'international master' : 'FF8C00',
    'grandmaster' : 'FF0000'
}

Cache = namedtuple('Cache', 'username time data')

name = sys.argv[1]
try:
    cache = pickle.load(open('codeforces.cache', 'rb'))
    if cache.username != name or time.time() - cache.time > 3600:
        cache = None
except FileNotFoundError:
    cache = None
if cache is None:
    try:
        r = requests.get('http://codeforces.com/api/user.info', params = {'handles' : name}).json()
        assert(r['status'] == 'OK')
        r = r['result'][0]
        out = r'\textcolor[HTML]{%s}{%s}' % (COLORS[r['rank']], name)
        pickle.dump(Cache(name, time.time(), out), open('codeforce.cache', 'wb'))
    except:
        out = name
else:
    out = cache.data
sys.stdout.write(out)

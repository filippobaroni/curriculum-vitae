#! /usr/bin/env python3

from collections import namedtuple
import pickle
import requests
import sys
import re
import time

COLORS = {
    'user-yellow' : 'C0C000',
    'user-red' : 'FF0000'
}

Cache = namedtuple('Cache', 'username time data')

name = sys.argv[1]
try:
    cache = pickle.load(open('atcoder.cache', 'rb'))
    if cache.username != name or time.time() - cache.time > 3600:
        cache = None
except FileNotFoundError:
    cache = None
if cache is None:
    try:
        rank = re.search(r'<span class="(.*?)">' + name + '</span>', requests.get(f'http://atcoder.jp/user/{name}').text).group(1)
        out = r'\textcolor[HTML]{%s}{%s}' % (COLORS[rank], name)
        pickle.dump(Cache(name, time.time(), out), open('atcoder.cache', 'wb'))
    except:
        out = name
else:
    out = cache.data
sys.stdout.write(out)

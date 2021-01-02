#! /usr/bin/env python3

import requests
import sys
import re

COLORS = {
    'user-yellow' : 'C0C000'
}

name = sys.argv[1]
rank = re.search(r'<span class="(.*?)">' + name + '</span>', requests.get(f'http://atcoder.jp/user/{name}').text).group(1)
sys.stdout.write(r'\textcolor[HTML]{%s}{%s}' % (COLORS[rank], name))

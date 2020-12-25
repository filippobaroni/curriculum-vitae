#! /usr/bin/env python3

import requests
import sys
from bs4 import BeautifulSoup

COLORS = {
    'user-yellow' : 'C0C000'
}

name = sys.argv[1]
soup = BeautifulSoup(requests.get(f'http://atcoder.jp/user/{name}').content, features = 'html5lib')
rank = soup.find('a', class_ = 'username').find('span')['class'][0]
sys.stdout.write(r'\textcolor[HTML]{%s}{%s}' % (COLORS[rank], name))

#! /usr/bin/python

import subprocess
from sys import argv

url = "192.168.121.108"
path = "/administrator/"


hiddens = []

x = subprocess.check_output( ["cat", argv[1] ] )
lines = x.split("\r")

for line in lines:
    if "<input" in line:
        if "hidden" in line:
            hiddens.append(line)

for hidden in hiddens:
    name = hidden.split('name="')[1]
    name = name.split('"')[0]
    value = hidden.split('value="')[1]
    value = value.split('"')[0]
    if str(value) == "1":
        print name


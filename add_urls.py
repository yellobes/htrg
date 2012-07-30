#! /usr/bin/python

import subprocess

url = "192.168.121.108"
path = "/administrator/"

hiddens = []
login = []

lines = x.split("\r")

x = subprocess.check_output( ["curl", "-s", url+path] )

for line in lines:
    if "<input" in line:
        if "user" or "pass" in line:
            if "hidden" in line:
                pass
            else:
                login.append(line)

        if "hidden" in line:
            hiddens.append(line)



print "login :"+str(login)
print ''
print "hiddens :"+str(hiddens)




#! /usr/bin/python

import subprocess


url = "192.168.121.108"
path = "/administrator/"


def login(username, password):

    # A class that logs into a Joomla website and stores session information.

    hiddens = []
    login = []

    form = {}

    x = subprocess.check_output( ["curl", "-s", url+path] )

    lines = x.split("\r")

    for line in lines:
        if "<input" in line:
            if "user" or "pass" in line:
                if "hidden" in line:
                    pass
                else:
                    login.append(line)

            if "hidden" in line:
                hiddens.append(line)

    for hidden in hiddens:
        name = hidden.split('name="')[1]
        name = name.split('"')[0]
        value = hidden.split('value="')[1]
        value = value.split('"')[0]
        form[name] = value
    
    for field in login:
        if "submit" in field:
            continue
        name = field.split('name="')[1]
        name = name.split('"')[0]
        if "user" in name:
            value = username
        elif "pass" in name:
            value = password
        form[name] = value

    print form

def ex_v(html, delim):
    try:
        field = html.split(delim)[1]
        field = field.split('"')[0]
        return field
    except IndexError:
        pass



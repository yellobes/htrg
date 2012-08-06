#! /usr/bin/python2.7


from sys       import argv
from itertools import combinations


x = argv[1].split("&")

results = [ x for x in combinations("".join(range(x)), len(x)) ]

print results


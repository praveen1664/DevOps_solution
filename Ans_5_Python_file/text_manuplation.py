#!/usr/bin/python
import re
lines=[]
with open("logfile", "r") as sources:
    lines = sources.readlines()
with open("logfile", "w") as sources:
    for line in lines:
        sources.write(re.sub(r'^# deb', 'deb', line))
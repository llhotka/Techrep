#! /usr/bin/python

import sys

def get_number(line):
    val = line.split()[1]
    if val.startswith("[["):
        zac = val.find("][") + 2
        kon = val.find("/", zac)
        return val[zac:kon]
    else:
        return val.split("/")[0]

def auth_line(line):
    auths = line.lstrip().split("  ")[-1]
    aulist = auths.split(", ")
    if len(aulist) > 3:
        return aulist[0] + " et al."
    else: return auths[:-1]

def tit_line(line):
    res = []
    title = line.lstrip().split("  ")[-1]
    while len(title) > 63:
        zlom = title.rfind(" ", 0, 63)
        res.append(title[:zlom])
        title = title[zlom+1:]
    res.append(title[:-1])
    return res

trlist = file(sys.argv[1])
toc = {}

while 1:
    rad = trlist.readline()
    if not rad: break
    text = rad.lstrip()
    if not text.startswith(":PROPERTIES:"): continue
    trno = int(get_number(trlist.readline()))
    toc[trno] = ("[ ] %2d. %s" % (trno, auth_line(trlist.readline())),
                 tit_line(trlist.readline()))
nos = toc.keys()
nos.sort()
for no in nos:
    print toc[no][0]
    for lin in toc[no][1]:
        print " " * 8 + lin
    

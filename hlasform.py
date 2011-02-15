#! /usr/bin/python
# -*- coding: utf-8 -*- 

import sys
import re

nre = re.compile("<<([0-9][0-9])-")
are = re.compile("/Autoři:/(.*)- /Název:/")
tre = re.compile("/Název:/(.*)- /Přijato:/")

def get_number(line):
    val = line.split()[1]
    if val.startswith("[["):
        zac = val.find("][") + 2
        kon = val.find("/", zac)
        return val[zac:kon]
    else:
        return val.split("/")[0]

def auth_line(line):
    auths = line.split(",")
    aulist = [ a.strip() for a in auths]
    if len(aulist) > 3:
        return aulist[0] + " et al."
    else: return ", ".join(aulist)

def tit_line(line):
    res = []
    title = " ".join(line.split())
    while len(title) > 63:
        zlom = title.rfind(" ", 0, 63)
        res.append(title[:zlom])
        title = title[zlom+1:]
    res.append(title)
    return res

def process_tz(tzstr):
    raw = tzstr.split("- /")
    res = {}
    for it in raw[1:]:
        (key, val) = it.split(":/", 1)
        res[key] = val.strip()
    return res
    

trlist = file(sys.argv[1])
raw=""
toc = {}

while 1:
    rad = trlist.readline()
    if rad.startswith("** "): break
    
while not rad.startswith("* Tabulka recenzent"):
    raw += rad
    rad = trlist.readline()

tzrecords = [x for x in raw.split("** ")[1:] if x.startswith("PUBLISHED")]

for tzrec in tzrecords:
    ix = tzrec.find("<<") + 2
    trno = int(tzrec[ix:ix+2])
    data = process_tz(tzrec)
    toc[trno] = ("[ ] %2d. %s" % (trno, auth_line(data["Autoři"])),
                 tit_line(data["Název"]))

nos = toc.keys()
nos.sort()
for no in nos:
    print toc[no][0]
    for lin in toc[no][1]:
        print " " * 8 + lin
    

#! /usr/bin/python

import sys, re
regexp = re.compile("\[\s?[xX]\s?\]\s*(\d{1,2})\.")
result = {}
for fn in sys.argv[1:]:
    inf = file(fn)
    hl = 0
    for line in inf:
        mo = regexp.search(line)
        if mo is not None:
            hl += 1
            if hl > 10: raise ValueError, "%s - more than 10 votes" % fn
            cis = int(mo.group(1))
            if cis in result:
                result[cis] += 1
            else:
                result[cis] = 1
kl = result.keys()
kl.sort()
for k in kl:
    print "%i\t%i" % (k, result[k])




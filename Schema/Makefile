SCHEMA = techrep2
RNGREST = /home/lhotka/Git/RNGreST/rngrest.xsl
.PHONY : all

all: $(SCHEMA).rnc $(SCHEMA).html

%.rnc: %.rng
	rng2rnc $*

%.rest: %.rng
	xsltproc -o $@ $(RNGREST) $<

%.html: %.rest
	rst2html $< $@



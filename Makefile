TR2TEX = /home/lhotka/Devel/Techrep/tr2tex.xsl
TR1TO2 = /home/lhotka/Devel/Techrep/techrep1to2.xsl

.PHONY: all

all: testrep.ps

%.ctr: %.xml
	xsltproc --novalid -o $@ $(TR1TO2) $<

%.tex: %.ctr
	xsltproc -o $@ $(TR2TEX) $<

%.pdf: %.tex
	xetex $<

%.ps: %.dvi
	dvips $<


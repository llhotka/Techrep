TR2TEX = /home/lhotka/Devel/Techrep/trtotex.xsl
TR1TO2 = /home/lhotka/Devel/Techrep/tr1to2.xsl

.PHONY: all

all: techreport.pdf

%.ctr: %.xml
	xsltproc --novalid -o $@ $(TR1TO2) $<

%.tex: %.ctr
	xsltproc -o $@ $(TR2TEX) $<

%.pdf: %.tex
	ixetex $<

%.ps: %.dvi
	dvips $<


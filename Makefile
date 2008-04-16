TR2TEX = /home/lhotka/Devel/Techrep/trtotex.xsl
TR1TO2 = /home/lhotka/Devel/Techrep/tr1to2.xsl
TR2XHTML = /home/lhotka/Devel/Techrep/trtoxhtml.xsl

.PHONY: all

all: eduacc.html

%.ctr: %.xml
	xsltproc --novalid --stringparam nbsp-tilde 1 -o $@ $(TR1TO2) $<

%.tex: %.ctr
	xsltproc -o $@ $(TR2TEX) $<

%.html: %.ctr
	xsltproc -o $@ $(TR2XHTML) $<

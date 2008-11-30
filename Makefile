FN = trname
XSLDIR = /home/lhotka/Projekty/Techrep
TR2TEX = $(XSLDIR)/trtotex.xsl
TR1TO2 = $(XSLDIR)/tr1to2.xsl
TR2XHTML = $(XSLDIR)/trtoxhtml.xsl

.PHONY: all

all: $(FN).html $(FN).pdf

%.ctr: %.xml
	xsltproc --novalid --stringparam nbsp-tilde 1 -o $@ $(TR1TO2) $<

%.tex: %.ctr
	xsltproc -o $@ $(TR2TEX) $<

%.pdf: %.tex
	ixetex $<

%.html: %.ctr
	xsltproc -o $@ $(TR2XHTML) $<

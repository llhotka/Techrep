<?xml version="1.0" encoding="utf-8"?>

<!--

trtoopf.xsl - generates EPUB OPF from Techrep v2 reports.
Copyright © 2010 CESNET
Author: Ladislav Lhotka <Lhotka@cesnet.cz>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:tr="http://cesnet.cz/ns/techrep/base/2.0"
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:opf="http://www.idpf.org/2007/opf"
                version="1.0">

  <xsl:output method="xml" omit-xml-declaration="no" indent="yes"/>

  <!-- Root element -->

  <xsl:template match="tr:report">
    <package version="2.0" unique-identifier="trNumber"
	     xmlns="http://www.idpf.org/2007/opf">
      <metadata>
	<xsl:apply-templates select="tr:title|tr:authors/tr:author|
				     tr:date|tr:abstract|tr:keywords"/>
	<dc:language>
	  <xsl:choose>
	    <xsl:when test="@xml:lang">
	      <xsl:value-of select="@xml:lang"/>
	    </xsl:when>
	    <xsl:otherwise>en</xsl:otherwise>
	  </xsl:choose>
	</dc:language>
	<dc:identifier id="trNumber" opf:scheme="CESNET-TR">
	  <xsl:value-of select="concat('CESNET-TR-', @number)"/>
	</dc:identifier>
	<dc:publisher>CESNET, z. s. p. o.</dc:publisher>
	<dc:rights>
	  <xsl:value-of select="concat('Copyright &#xA9; ',
				substring-after(@number,'/'),
				' CESNET, z. s. p. o.')"/>
	</dc:rights>
      </metadata>
      <manifest>
	<item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>
	<item id="css" href="css/tr.css" media-type="application/x-dtbncx+xml"/>
	<item id="font-main" href="css/DejaVuSerif.otf" media-type="font/opentype"/>
	<item id="font-mono" href="css/DejaVuSansMono.otf" media-type="font/opentype"/>
	<item id="contents" href="etr.html" media-type="application/xhtml+xml"/>
	<xsl:apply-templates
	    select="tr:body//tr:source[@format != 'PDF']" mode="item"/>
      </manifest>
      <spine toc="ncx">
	<itemref idref="contents"/>
      </spine>
    </package>
  </xsl:template>

  <xsl:template match="tr:title">
    <xsl:element name="dc:title">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:date">
    <xsl:element name="dc:date">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:author">
    <xsl:element name="dc:creator">
      <xsl:attribute name="opf:role">aut</xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:abstract">
    <xsl:element name="dc:description">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:keywords">
    <xsl:element name="dc:subject">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:source" mode="item">
    <xsl:element name="item">
      <xsl:attribute name="id">
	<xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:attribute name="href">
	<xsl:value-of select="@file"/>
      </xsl:attribute>
      <xsl:attribute name="media-type">
	<xsl:value-of select="concat('image/',@format)"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:source" mode="itemref">
    <xsl:element name="itemref">
      <xsl:attribute name="idref">
	<xsl:value-of select="generate-id()"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>

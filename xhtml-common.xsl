<?xml version="1.0" encoding="utf-8"?>

<!--

xhtml-common.xsl - common templates for XHTML translation.
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
                version="1.0">

  <xsl:include href="trto-lib.xsl"/>

  <xsl:variable name="version">2.0</xsl:variable>
  <xsl:param name="tr-name">REPORT</xsl:param>

  <!-- Common template for EPUB ToC and title -->

  <xsl:template name="epub-html">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <xsl:attribute name="xml:lang">
	<xsl:choose>
	  <xsl:when test="tr:report/@xml:lang">
	    <xsl:value-of select="tr:report/@xml:lang"/>
	  </xsl:when>
	  <xsl:otherwise>en</xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>
      <head>
	<meta http-equiv="Content-Type"
	      content="application/xhtml+xml; charset=utf-8"/>
	<link rel="stylesheet" href="css/tr.css" type="text/css"/>
	<title>
	  <xsl:value-of select="tr:report/tr:title"/>
	</title>
      </head>
      <body>
	<xsl:apply-templates select="tr:report"/>
      </body>
    </html>
  </xsl:template>

  <!-- Decoder of tabular column alignment -->

  <xsl:template name="col-align">
    <xsl:param name="code"/>
    <xsl:attribute name="align">
      <xsl:choose>
	<xsl:when test="$code='l'">left</xsl:when>
	<xsl:when test="$code='c'">center</xsl:when>
	<xsl:when test="$code='r'">right</xsl:when>
	<xsl:otherwise>char</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
<!--    <xsl:if test="contains('.,', $code)">
      <xsl:attribute name="char">
	<xsl:value-of select="$code"/>
      </xsl:attribute>
    </xsl:if> -->
  </xsl:template>

  <xsl:template match="@xml:id">
    <xsl:attribute name="id">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

</xsl:stylesheet>

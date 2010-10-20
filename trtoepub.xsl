<?xml version="1.0" encoding="utf-8"?>

<!--

trtoxhtml.xsl - translates Techrepv2 to XHTML.
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

  <xsl:include href="xhtml-common.xsl"/>

  <xsl:output method="xml" encoding="UTF-8"/>

  <!-- Root element -->

  <xsl:template match="/">
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
	<link rel="stylesheet" href="css/main.css" type="text/css"/>
	<xsl:element name="title">
	  <xsl:call-template name="select-local">
	    <xsl:with-param name="cs">Technická zpráva &#x2013; </xsl:with-param>
	    <xsl:with-param name="en">Technical report &#x2013; </xsl:with-param>
	  </xsl:call-template>
	  <xsl:value-of select="tr:report/tr:title"/>
	</xsl:element>
      </head>
      <body>
	<xsl:apply-templates select="tr:report"/>
	<xsl:if test="tr:report//tr:footnote">
	  <xsl:element name="hr"/>
	  <xsl:element name="p">
	    <xsl:element name="strong">
	      <xsl:text>Footnotes:</xsl:text>
	    </xsl:element>
	  </xsl:element>
	  <xsl:element name="table">
	    <xsl:element name="tbody">
	      <xsl:attribute name="valign">top</xsl:attribute>
	      <xsl:attribute name="border">0</xsl:attribute>
	      <xsl:apply-templates select="tr:report//tr:footnote"
				   mode="list"/>
	    </xsl:element>
	  </xsl:element>
	</xsl:if>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>

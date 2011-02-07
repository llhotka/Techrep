<?xml version="1.0" encoding="utf-8"?>

<!--

trtoncx.xsl - generates NCX ToC from Techrep v2 reports.
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

  <xsl:output method="xml" omit-xml-declaration="no"
	      indent="yes" encoding="UTF-8"/>

  <xsl:template name="play-order">
    <xsl:attribute name="playOrder">
      <xsl:value-of select="2 + count(preceding-sibling::tr:h1|
			    preceding-sibling::tr:h2|
			    preceding-sibling::tr:h3|
			    preceding-sibling::tr:appendix|
			    preceding-sibling::tr:biblist)"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="navPoint-common">
    <xsl:attribute name="id">
      <xsl:value-of select="generate-id()"/>
    </xsl:attribute>
    <xsl:call-template name="play-order"/>
    <navLabel>
      <text>
	<xsl:apply-templates select="." mode="number"/>
	<xsl:text>&#xA0;&#xA0;</xsl:text>
	<xsl:value-of select="."/>
      </text>
    </navLabel>
    <content>
      <xsl:attribute name="src">
	<xsl:text>etr.html#</xsl:text>
	<xsl:apply-templates select="." mode="id"/>
      </xsl:attribute>
    </content>
  </xsl:template>

  <!-- Root element -->

  <xsl:template match="tr:report">
    <ncx version="2005-1" xmlns="http://www.daisy.org/z3986/2005/ncx/">
      <head>
	<meta name="dtb:uid" content="{concat('CESNET-TR-', @number)}"/>
	<meta name="dtb:depth">
	  <xsl:attribute name="content">
	    <xsl:choose>
	      <xsl:when test="descendant::tr:h3">
		<text>4</text>
	      </xsl:when>
	      <xsl:when test="descendant::tr:h2">
		<text>3</text>
	      </xsl:when>
	      <xsl:when test="descendant::tr:h1|descendant::tr:appendix">
		<text>2</text>
	      </xsl:when>
	      <xsl:otherwise>1</xsl:otherwise>
	    </xsl:choose>
	  </xsl:attribute>
	</meta>
	<meta name="dtb:totalPageCount" content="0"/>
	<meta name="dtb:maxPageNumber" content="0"/>
      </head>
      <docTitle>
	<text>
	  <xsl:value-of select="tr:title"/>
	</text>
      </docTitle>
      <navMap>
	<navPoint id="{generate-id()}" playOrder="1">
	  <navLabel>
	    <text>
	      <xsl:value-of select="tr:title"/>
	    </text>
	  </navLabel>
	  <content src="etr.html"/>
	  <xsl:apply-templates
	      select="tr:body/tr:h1|tr:body/tr:appendix|
		      tr:body/tr:biblist"/>
	</navPoint>
      </navMap>
    </ncx>
  </xsl:template>

  <xsl:template match="tr:h1">
    <navPoint xmlns="http://www.daisy.org/z3986/2005/ncx/">
      <xsl:call-template name="navPoint-common"/>
      <xsl:apply-templates
	  select="following-sibling::tr:h2
		  [(preceding-sibling::tr:h1|
		  preceding-sibling::tr:appendix)[last()]= current()]"/>
    </navPoint>
  </xsl:template>

  <xsl:template match="tr:h2">
    <navPoint xmlns="http://www.daisy.org/z3986/2005/ncx/">
      <xsl:call-template name="navPoint-common"/>
      <xsl:apply-templates
	  select="following-sibling::tr:h3
		  [preceding-sibling::tr:h2[1] = current()]"/>
    </navPoint>
  </xsl:template>

  <xsl:template match="tr:h3">
    <navPoint xmlns="http://www.daisy.org/z3986/2005/ncx/">
      <xsl:call-template name="navPoint-common"/>
    </navPoint>
  </xsl:template>

  <xsl:template match="tr:appendix">
    <navPoint xmlns="http://www.daisy.org/z3986/2005/ncx/"
	      id="{generate-id()}">
      <xsl:call-template name="play-order"/>
      <navLabel>
	<text>
	  <xsl:call-template name="select-local">
	    <xsl:with-param name="cs">Dodatek</xsl:with-param>
	    <xsl:with-param name="en">Appendix</xsl:with-param>
	  </xsl:call-template>
	  <xsl:text>&#xA0;</xsl:text>
	  <xsl:apply-templates select="." mode="number"/>
	  <xsl:text>&#xA0;&#xA0;</xsl:text>
	  <xsl:value-of select="."/>
	</text>
      </navLabel>
      <content>
	<xsl:attribute name="src">
	  <xsl:text>etr.html#</xsl:text>
	  <xsl:apply-templates select="." mode="id"/>
	</xsl:attribute>
      </content>
      <xsl:apply-templates
	  select="following-sibling::tr:h2
		  [preceding-sibling::tr:appendix[1] = current()]"/>
    </navPoint>
  </xsl:template>

  <xsl:template match="tr:biblist">
    <navPoint xmlns="http://www.daisy.org/z3986/2005/ncx/"
	      id="{generate-id()}">
      <xsl:call-template name="play-order"/>
      <navLabel>
	<text>
	  <xsl:call-template name="select-local">
	    <xsl:with-param name="cs">Literatura</xsl:with-param>
	    <xsl:with-param name="en">References</xsl:with-param>
	  </xsl:call-template>
	</text>
      </navLabel>
      <content>
	<xsl:attribute name="src">
	  <xsl:text>etr.html#</xsl:text>
	  <xsl:apply-templates select="." mode="id"/>
	</xsl:attribute>
      </content>
    </navPoint>
  </xsl:template>

</xsl:stylesheet>

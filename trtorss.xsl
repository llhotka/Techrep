<?xml version="1.0" encoding="utf-8"?>

<!--

trtorss.xsl - generates RSS news from Techrepv2 reports.
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

  <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>

  <xsl:param
      name="basedir">http://www.cesnet.cz/doc/techzpravy/2010/</xsl:param>
  <xsl:param name="tr-name">REPORT</xsl:param>

  <xsl:template name="cit-name">
    <xsl:param name="aname"/>
    <xsl:choose>
      <xsl:when test="contains($aname, ' ')">
	<xsl:value-of select="concat(substring($aname,1,1), '. ')"/>
	<xsl:call-template name="cit-name">
	  <xsl:with-param name="aname"
			  select="substring-after($aname, ' ')"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$aname"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Root element -->

  <xsl:template match="tr:report">
    <xsl:element name="item">
      <xsl:element name="title">
	<xsl:value-of select="concat(tr:title, ' (', @number, ')')"/>
      </xsl:element>
      <xsl:element name="link">
	<xsl:value-of select="concat($basedir, $tr-name)"/>
      </xsl:element>
      <xsl:element name="description">
	<xsl:text>AUTHORS: </xsl:text>
	<xsl:for-each select="tr:authors/tr:author">
	  <xsl:call-template name="cit-name">
	    <xsl:with-param name="aname"
			    select="normalize-space()"/>
	  </xsl:call-template>
	  <xsl:choose>
	    <xsl:when test="position() = last()">
	      <xsl:text>. </xsl:text>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:text>, </xsl:text>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:for-each>
	<xsl:apply-templates select="tr:abstract"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>

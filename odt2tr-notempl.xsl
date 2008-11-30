<?xml version="1.0"?>

<!--

Program name: odt2tr.xsl
Description: This style sheet transforms Open Document Format v1.0
             to CESNET technical report format 
Author: Ladislav Lhotka <Lhotka@cesnet.cz>

Copyright (C) 2006 CESNET

This program is free software; you can redistribute it and/or
modify it under the terms of version 2 of the GNU General Public
License as published by the Free Software Foundation.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
02111-1307, USA.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
		xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
		xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
		xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
		xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
                version="1.0">

  <xsl:output method="xml"
	      indent="yes"
	      omit-xml-declaration="no"
	      doctype-public="zprava"
	      doctype-system="techrep.dtd"/>

  <xsl:key name="list-styles" match="text:list-style" use="@style:name"/>

  <xsl:variable name="NL">
    <xsl:text>
</xsl:text>
  </xsl:variable>

  <xsl:variable name="NLNL">
    <xsl:value-of select="$NL"/>
    <xsl:value-of select="$NL"/>
  </xsl:variable>
  
  <!-- Global parameters -->

  <!-- Value of text:h/@text:outline-level for h1 elements -->
  <xsl:param name="tr-nazev">FIXME</xsl:param>
  <xsl:param name="tr-autor">FIXME</xsl:param>
  <xsl:param name="tr-datum">FIXME</xsl:param>
  <xsl:param name="tr-number">XX/2008</xsl:param>
  <xsl:param name="h1-level" select="1"/>
  <xsl:param name="tr-date">24.12.2006</xsl:param>
  <xsl:param name="tt-style">Teletype</xsl:param>

  <!-- Style variables -->

  <xsl:variable name="bold-style"
		select="/office:document-content/office:automatic-styles/style:style[style:text-properties/@fo:font-weight='bold']/@style:name"/>

  <xsl:variable name="italic-style"
		select="/office:document-content/office:automatic-styles/style:style[style:text-properties/@fo:font-style='italic']/@style:name"/>

  <xsl:variable name="superscript-style"
		select="/office:document-content/office:automatic-styles/style:style[starts-with(style:text-properties/@style:text-position,'sup')]/@style:name"/>

  <xsl:variable name="subscript-style"
		select="/office:document-content/office:automatic-styles/style:style[starts-with(style:text-properties/@style:text-position,'sub')]/@style:name"/>

  <!-- The root element -->

  <xsl:template match="office:body">
    <xsl:element name="zprava">
      <xsl:attribute name="cislo">
	<xsl:value-of select="$tr-number"/>
      </xsl:attribute>
      <xsl:value-of select="$NL"/>
      <xsl:element name="nazev">
	<xsl:value-of select="$tr-nazev"/>
      </xsl:element>
      <xsl:value-of select="$NL"/>
      <xsl:element name="autor">
	<xsl:value-of select="$tr-autor"/>
      </xsl:element>
      <xsl:value-of select="$NL"/>
      <xsl:element name="datum">
	<xsl:value-of select="$tr-datum"/>
      </xsl:element>
      <xsl:value-of select="$NLNL"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="text:p">
    <xsl:if test="descendant::text()">
      <xsl:choose>
	<xsl:when test="@text:style-name=$italic-style">
	  <xsl:element name="p">
	    <xsl:element name="i">
	      <xsl:apply-templates/>
	    </xsl:element>
	  </xsl:element>
	</xsl:when>
	<xsl:when test="@text:style-name=$bold-style">
	  <xsl:element name="p">
	    <xsl:element name="b">
	      <xsl:apply-templates/>
	    </xsl:element>
	  </xsl:element>
	</xsl:when>
	<xsl:when test="@text:style-name=$tt-style">
	  <xsl:element name="tt">
	    <xsl:apply-templates/>
	  </xsl:element>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:element name="p">
	    <xsl:apply-templates/>
	  </xsl:element>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="$NL"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="table:table-cell/text:p">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="text:p[draw:frame]">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="text:h">
    <xsl:value-of select="$NL"/>
    <xsl:choose>
      <xsl:when test="@text:outline-level=$h1-level">
	<xsl:element name="h1">
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:when>
      <xsl:when test="@text:outline-level=$h1-level + 1">
	<xsl:element name="h2">
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:when>
      <xsl:when test="@text:outline-level=$h1-level + 2">
	<xsl:element name="h3">
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<unknown-header><xsl:apply-templates/></unknown-header>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$NLNL"/>
  </xsl:template>

  <xsl:template match="text:span">
    <xsl:choose>
      <xsl:when test="@text:style-name=$italic-style">
	<xsl:element name="i">
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:when>
      <xsl:when test="@text:style-name=$bold-style">
	<xsl:element name="b">
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:when>
      <xsl:when test="@text:style-name=$superscript-style">
	<xsl:element name="sup">
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:when>
      <xsl:when test="@text:style-name=$subscript-style">
	<xsl:element name="sub">
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:when>
      <xsl:when test="@text:style-name=$tt-style">
	<xsl:element name="tt">
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="text:list">
    <xsl:value-of select="$NL"/>
    <xsl:variable name="lstyl"
		  select="key('list-styles',@text:style-name)"/>
    <xsl:choose>
      <xsl:when test="$lstyl/text:list-level-style-number">
	<xsl:element name="ol">
	  <xsl:value-of select="$NL"/>
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="ul">
	  <xsl:value-of select="$NL"/>
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$NL"/>
  </xsl:template>

  <xsl:template match="text:list-item">
    <xsl:element name="li">
      <xsl:apply-templates/>
    </xsl:element>
    <xsl:value-of select="$NL"/>
  </xsl:template>

  <xsl:template match="text:a">
    <xsl:element name="a">
      <xsl:attribute name="href">
	<xsl:value-of select="@xlink:href"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="table:table">
    <xsl:value-of select="$NL"/>
    <xsl:element name="tab">
      <xsl:apply-templates select="table:table-row"/>
    </xsl:element>
    <xsl:value-of select="$NL"/>
  </xsl:template>

  <xsl:template match="table:table-row">
    <xsl:element name="tr">
      <xsl:apply-templates select="table:table-cell"/>
    </xsl:element>
    <xsl:value-of select="$NL"/>
  </xsl:template>

  <xsl:template match="table:table-cell">
    <xsl:element name="td">
      <xsl:apply-templates/>
    </xsl:element>
    <xsl:value-of select="$NL"/>
  </xsl:template>

  <xsl:template match="draw:frame">
    <xsl:apply-templates select="descendant::draw:image"/>
  </xsl:template>

  <xsl:template match="draw:image">
    <xsl:element name="obr">
      <xsl:attribute name="src">
	<xsl:value-of select="@xlink:href"/>
      </xsl:attribute>
      <xsl:element name="FIXME"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="text:s">
    <xsl:text> </xsl:text>
  </xsl:template>

</xsl:stylesheet>

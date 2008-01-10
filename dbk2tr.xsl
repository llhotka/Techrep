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
                version="1.0">

  <xsl:output method="xml"
	      indent="yes"
	      omit-xml-declaration="no"
	      doctype-public="zprava"
	      doctype-system="techrep.dtd"/>

  <xsl:variable name="NL">
    <xsl:text>
</xsl:text>
  </xsl:variable>

  <xsl:variable name="NLNL">
    <xsl:value-of select="$NL"/>
    <xsl:value-of select="$NL"/>
  </xsl:variable>
  
  <!-- Global parameters -->

  <xsl:param name="tr-number">XX/2006</xsl:param>
  <xsl:param name="tr-lang">en</xsl:param>

  <xsl:template name="seclevel">
    <xsl:param name="secel"/>
    <xsl:choose>
      <xsl:when test="secel[parent::section]">
	<xsl:variable name="parlev">
	  <xsl:call-template name="seclevel">
	    <xsl:with-param name="secel" select="secel/parent::section"/>
	  </xsl:call-template>
	</xsl:variable>
	<xsl:value-of select="$parlev + 1"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="article">
    <xsl:element name="zprava">
      <xsl:attribute name="cislo">
	<xsl:value-of select="$tr-number"/>
      </xsl:attribute>
      <xsl:attribute name="jazyk">
	<xsl:value-of select="$tr-lang"/>
      </xsl:attribute>
      <xsl:value-of select="$NL"/>
      <xsl:element name="nazev">
	<xsl:value-of select="articleinfo/title"/>
      </xsl:element>
      <xsl:value-of select="$NL"/>
      <xsl:element name="autor">
	<xsl:value-of select="articleinfo/author/firstname"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="articleinfo/author/surname"/>
      </xsl:element>
      <xsl:value-of select="$NL"/>
      <xsl:element name="datum">
	<xsl:value-of select="articleinfo/date"/>
      </xsl:element>
      <xsl:value-of select="$NLNL"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="articleinfo"/>
  <xsl:template match="title"/>

  <xsl:template match="abstract">
    <xsl:element name="h1">
      <xsl:text>Abstract</xsl:text>
    </xsl:element>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="para">
    <xsl:element name="p">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="section">
    <xsl:variable name="secl">
      <xsl:call-template name="seclevel">
	<xsl:with-param name="secel" select="."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$secl=1">
	<xsl:element name="h1">
	  <xsl:value-of select="title"/>
	</xsl:element>
      </xsl:when>
      <xsl:when test="$secl=2">
	<xsl:element name="h2">
	  <xsl:value-of select="title"/>
	</xsl:element>
      </xsl:when>
      <xsl:when test="$secl=3">
	<xsl:element name="h3">
	  <xsl:value-of select="title"/>
	</xsl:element>
      </xsl:when>
    </xsl:choose>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="sect1">
    <xsl:element name="h1">
      <xsl:value-of select="title"/>
    </xsl:element>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="sect2">
    <xsl:element name="h2">
      <xsl:value-of select="title"/>
    </xsl:element>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="sect3">
    <xsl:element name="h3">
      <xsl:value-of select="title"/>
    </xsl:element>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="simplesect">
    <xsl:element name="h3">
      <xsl:value-of select="title"/>
    </xsl:element>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="ulink">
    <xsl:element name="a">
      <xsl:attribute name="href">
	<xsl:value-of select="@url"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="itemizedlist">
    <xsl:element name="ul">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="listitem">
    <xsl:element name="li">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- Sentinel -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

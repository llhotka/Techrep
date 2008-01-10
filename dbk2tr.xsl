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
    <xsl:variable name="secl" select="count(ancestor-or-self::section)"/>
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

  <xsl:template match="acronym">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="programlisting">
    <xsl:element name="pre">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="command">
    <xsl:element name="prikaz">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="filename">
    <xsl:element name="soubor">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="varname|productname">
    <xsl:element name="i">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="link">
    <xsl:choose>
      <xsl:when test="local-name(id(@linkend))='biblioentry'">
	<xsl:element name="cite">
	  <xsl:attribute name="href">
	    <xsl:value-of select="@linkend"/>
	  </xsl:attribute>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="a">
	  <xsl:attribute name="href">
	    <xsl:value-of select="concat('#',@linkend)"/>
	  </xsl:attribute>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="bibliography">
    <xsl:element name="seznamknih">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="biblioentry">
    <xsl:element name="kniha">
      <xsl:apply-templates select="@id"/>
      <xsl:for-each select=".//author">
	<xsl:value-of select="surname"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="substring(firstname,1,1)"/>
	<xsl:text>.</xsl:text>
	<xsl:choose>
	<xsl:when test="position()=last()">
	  <xsl:text>: </xsl:text>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text>, </xsl:text>
	</xsl:otherwise>
	</xsl:choose>
      </xsl:for-each>
      <xsl:apply-templates select="title"/>
      <xsl:apply-templates select="subtitle"/>
      <xsl:apply-templates select="publisher/publishername"/>
      <xsl:apply-templates select="pubdate"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@id">
    <xsl:copy>
      <xsl:value-of select="."/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="bibentry/title|bibentry/subtitle|bibentry/pubdate">
    <xsl:apply-templates/>
    <xsl:text>. </xsl:text>
  </xsl:template>

  <xsl:template match="publishername">
    <xsl:apply-templates/>
    <xsl:text>, </xsl:text>
  </xsl:template>

  <!-- Sentinel -->
  <xsl:template match="*">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

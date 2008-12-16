<?xml version="1.0"?>

<!--

Program name: dbk2tr.xsl
Description: This style sheet transforms DocBook v. 4.5
             to CESNET technical report format, version 2. 
Author: Ladislav Lhotka <Lhotka@cesnet.cz>

Copyright (C) 2008 CESNET

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
		xmlns:tr="http://cesnet.cz/ns/techrep/base/2.0"
                version="1.0">

  <xsl:output method="xml"
	      indent="yes"
	      omit-xml-declaration="no"/>

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
    <xsl:element name="tr:report">
      <xsl:attribute name="number">
	<xsl:value-of select="$tr-number"/>
      </xsl:attribute>
      <xsl:attribute name="xml:lang">
	<xsl:value-of select="$tr-lang"/>
      </xsl:attribute>
      <xsl:apply-templates select="articleinfo|abstract"/>
      <xsl:element name="tr:body">
	<xsl:apply-templates select="section|sect1|para"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="articleinfo">
    <xsl:apply-templates select="title" mode="top"/>
    <xsl:apply-templates select="author|authorgroup"/>
    <xsl:apply-templates select="keywordset"/>
  </xsl:template>

  <xsl:template match="authorgroup">
    <xsl:apply-templates select="author"/>
  </xsl:template>

  <xsl:template match="author">
    <xsl:element name="tr:author">
      <xsl:element name="tr:name">
	<xsl:value-of select="firstname"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="surname"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="title" mode="top">
    <xsl:element name="tr:title">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="title" mode="float">
    <xsl:element name="tr:caption">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="title" mode="sec">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="title" mode="bib">
    <xsl:apply-templates/>
    <xsl:text>. </xsl:text>
  </xsl:template>

  <xsl:template match="title"/>

  <xsl:template match="keywordset">
    <xsl:element name="tr:keywords">
      <xsl:for-each select="keyword">
	<xsl:value-of select="."/>
	<xsl:if test="position()!=last()">, </xsl:if>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="abstract">
    <xsl:element name="tr:abstract">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="listitem/para|listitem/simpara">
    <xsl:choose>
      <xsl:when test="count(preceding-sibling::*|following-sibling::*)=0">
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="tr:p">
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="para|simpara">
    <xsl:element name="tr:p">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="section">
    <xsl:variable name="secl" select="count(ancestor-or-self::section)"/>
    <xsl:choose>
      <xsl:when test="$secl=1">
	<xsl:element name="tr:h1">
	  <xsl:apply-templates select="title" mode="sec"/>
	</xsl:element>
      </xsl:when>
      <xsl:when test="$secl=2">
	<xsl:element name="tr:h2">
	  <xsl:apply-templates select="title" mode="sec"/>
	</xsl:element>
      </xsl:when>
      <xsl:when test="$secl=3">
	<xsl:element name="tr:h3">
	  <xsl:apply-templates select="title" mode="sec"/>
	</xsl:element>
      </xsl:when>
    </xsl:choose>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="sect1">
    <xsl:element name="tr:h1">
      <xsl:apply-templates select="title" mode="sec"/>
    </xsl:element>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="sect2">
    <xsl:element name="tr:h2">
      <xsl:apply-templates select="title" mode="sec"/>
    </xsl:element>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="sect3">
    <xsl:element name="tr:h3">
      <xsl:apply-templates select="title" mode="sec"/>
    </xsl:element>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="simplesect">
    <xsl:element name="tr:h3">
      <xsl:apply-templates select="title" mode="sec"/>
    </xsl:element>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="ulink">
    <xsl:element name="tr:a">
      <xsl:attribute name="href">
	<xsl:value-of select="@url"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="itemizedlist">
    <xsl:element name="tr:ul">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="orderedlist">
    <xsl:element name="tr:ol">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="varlistentry/listitem">
    <xsl:element name="tr:dd">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="listitem">
    <xsl:element name="tr:li">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="variablelist">
    <xsl:element name="tr:dl">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="varlistentry">
    <xsl:apply-templates select="term"/>
    <xsl:apply-templates select="listitem"/>
  </xsl:template>

  <xsl:template match="term">
    <xsl:element name="tr:dt">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="acronym">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="programlisting">
    <xsl:element name="tr:pre">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="command">
    <xsl:element name="tr:command">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="filename">
    <xsl:element name="tr:file">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="varname|productname">
    <xsl:element name="tr:em">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="link">
    <xsl:choose>
      <xsl:when test="local-name(id(@linkend))='biblioentry'">
	<xsl:element name="tr:cite">
	  <xsl:attribute name="bibref">
	    <xsl:value-of select="@linkend"/>
	  </xsl:attribute>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="tr:xref">
	  <xsl:attribute name="linkend">
	    <xsl:value-of select="@linkend"/>
	  </xsl:attribute>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="xref">
    <xsl:element name="tr:xref">
      <xsl:attribute name="linkend">
	<xsl:value-of select="@linkend"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="bibliography">
    <xsl:element name="tr:biblist">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="biblioentry">
    <xsl:element name="tr:bibitem">
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
      <xsl:apply-templates select="title" mode="bib"/>
      <xsl:apply-templates select="subtitle"/>
      <xsl:apply-templates select="publisher/publishername"/>
      <xsl:apply-templates select="pubdate"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@id">
    <xsl:attribute name="xml:id">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="subtitle|pubdate">
    <xsl:apply-templates/>
    <xsl:text>. </xsl:text>
  </xsl:template>

  <xsl:template match="publishername">
    <xsl:apply-templates/>
    <xsl:text>, </xsl:text>
  </xsl:template>

  <xsl:template match="figure">
    <xsl:element name="tr:figure">
      <xsl:apply-templates select="@id"/>
      <xsl:apply-templates select="title" mode="float"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="mediaobject">
    <xsl:element name="tr:image">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="imageobject">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="imageobject">
    <xsl:element name="tr:source">
      <xsl:apply-templates select="imagedata/@format"/>
      <xsl:attribute name="file">
	<xsl:value-of select="imagedata/@fileref"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@format">
    <xsl:attribute name="format">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="table">
    <xsl:element name="tr:table">
      <xsl:apply-templates select="@id"/>
      <xsl:apply-templates select="title" mode="float"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tgroup">
    <xsl:element name="tr:tabular">
      <xsl:attribute name="colspec">
	<xsl:apply-templates select="colspec"/>
      </xsl:attribute>
      <xsl:apply-templates select="thead|tbody"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="colspec">
    <xsl:choose>
      <xsl:when test="@align">
	<xsl:apply-templates select="@align"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="../@align"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="entry/@align">
    <xsl:attribute name="align">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="@align">
    <xsl:choose>
      <xsl:when test=".='center'">c</xsl:when>
      <xsl:when test=".='left'">l</xsl:when>
      <xsl:when test=".='right'">r</xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="thead|tbody">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="row">
    <xsl:element name="tr:tr">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="entry">
    <xsl:variable name="cel">
      <xsl:choose>
	<xsl:when test="ancestor::thead">tr:th</xsl:when>
	<xsl:otherwise>tr:td</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$cel}">
      <xsl:apply-templates select="@align"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="emphasis">
    <xsl:element name="tr:em">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="uri">
    <xsl:element name="tr:uri">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="footnote">
    <xsl:element name="tr:footnote">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="quote">
    <xsl:element name="tr:q">
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

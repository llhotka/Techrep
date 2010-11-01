<?xml version="1.0" encoding="utf-8"?>

<!--

trtoetitle.xsl - translates Techrepv2 to EPUB title page.
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
    <xsl:call-template name="epub-html"/>
  </xsl:template>

  <xsl:template match="tr:report">
    <xsl:apply-templates select="tr:title"/>
    <p xmlns="http://www.w3.org/1999/xhtml">
      <strong>
	<a href="http://www.cesnet.cz/doc/techzpravy/">
	  <xsl:call-template name="select-local">
	    <xsl:with-param name="cs">Technická zpráva CESNETu</xsl:with-param>
	    <xsl:with-param name="en">CESNET technical report</xsl:with-param>
	  </xsl:call-template>
	</a>
	<xsl:text>&#xA0;</xsl:text>
	<xsl:value-of select="@number"/>
      </strong>
      <br/>
    </p>
    <xsl:apply-templates select="tr:authors"/>
    <p xmlns="http://www.w3.org/1999/xhtml">
      <xsl:value-of select="concat('Received ', tr:date)"/>
    </p>
    <xsl:apply-templates select="tr:abstract"/>
    <xsl:apply-templates select="tr:keywords"/>
  </xsl:template>

  <xsl:template match="tr:authors">
    <p xmlns="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates select="tr:author"/>
    </p>
    <p xmlns="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates select="tr:affiliation"/>
    </p>
  </xsl:template>

  <xsl:template match="tr:author">
    <big xmlns="http://www.w3.org/1999/xhtml">
      <strong><xsl:apply-templates/></strong>
    </big>
    <xsl:if test="id(@affil)">
      <xsl:if test="count(parent::*/tr:affiliation)&gt;1
		    and count(parent::*/tr:author)&gt;1">
	<sup xmlns="http://www.w3.org/1999/xhtml">
	  <xsl:for-each select="id(@affil)">
	    <xsl:number/>
	    <xsl:if test="position()!=last()">,</xsl:if>
	  </xsl:for-each>
	</sup>
      </xsl:if>
    </xsl:if>
    <xsl:if test="following-sibling::tr:author">
      <big xmlns="http://www.w3.org/1999/xhtml">
	<strong>, </strong>
      </big>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tr:affiliation">
    <xsl:if test="count(parent::*/tr:affiliation)&gt;1
		  and count(parent::*/tr:author)&gt;1">
      <sup xmlns="http://www.w3.org/1999/xhtml"><xsl:number/></sup>
    </xsl:if>
    <em xmlns="http://www.w3.org/1999/xhtml"><xsl:apply-templates/></em>
    <br xmlns="http://www.w3.org/1999/xhtml"/>
  </xsl:template>

  <xsl:template match="tr:title">
    <h1 xmlns="http://www.w3.org/1999/xhtml"><xsl:apply-templates/></h1>
  </xsl:template>

  <xsl:template match="tr:abstract">
    <h2 xmlns="http://www.w3.org/1999/xhtml">
      <xsl:call-template name="select-local">
	<xsl:with-param name="cs">Abstrakt</xsl:with-param>
	<xsl:with-param name="en">Abstract</xsl:with-param>
      </xsl:call-template>
    </h2>
    <xsl:choose>
      <xsl:when test="tr:p">
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
	<p xmlns="http://www.w3.org/1999/xhtml"><xsl:apply-templates/></p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tr:keywords">
    <p xmlns="http://www.w3.org/1999/xhtml">
      <em>
	<xsl:call-template name="select-local">
	  <xsl:with-param name="cs">Klíčová slova</xsl:with-param>
	  <xsl:with-param name="en">Keywords</xsl:with-param>
	</xsl:call-template>
	<xsl:text>: </xsl:text>
      </em>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="tr:p|tr:pre|tr:ul|tr:dl|tr:dd|tr:li">
    <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates select="@xml:id"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:ol">
    <xsl:element name="ol" namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates select="@xml:id"/>
      <xsl:if test="@continue">
	<xsl:variable name="cnt" select="id(@continue)"/>
	<xsl:choose>
	  <xsl:when test="$cnt">
	    <xsl:attribute name="start">
	      <xsl:variable name="prev">
		<xsl:apply-templates select="$cnt" mode="itemcount"/>
	      </xsl:variable>
	      <xsl:value-of select="$prev+1"/>
	    </xsl:attribute>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:message terminate="no">
	      <xsl:text>Continued list not found: </xsl:text>
	      <xsl:value-of select="@continue"/>
	    </xsl:message>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:ol" mode="itemcount">
    <xsl:choose>
      <xsl:when test="@continue">
	<xsl:variable name="prev">
	  <xsl:apply-templates select="id(@continue)" mode="itemcount"/>
	</xsl:variable>
	<xsl:value-of select="$prev+count(tr:li)"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:number value="count(tr:li)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tr:strong|tr:sup|tr:sub|tr:blockquote">
    <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:dt">
    <xsl:element name="dt" namespace="http://www.w3.org/1999/xhtml">
      <xsl:element name="strong" namespace="http://www.w3.org/1999/xhtml">
	<xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:em|tr:command|tr:file|tr:uri|tr:phrase">
    <xsl:element name="em" namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:tt|tr:input">
    <xsl:element name="code" namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:q">
    <xsl:choose>
      <xsl:when test="ancestor-or-self::*[@xml:lang='cs']">
	<xsl:text>„</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>“</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>“</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>”</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tr:a">
    <xsl:element name="a" namespace="http://www.w3.org/1999/xhtml">
      <xsl:attribute name="href">
	<xsl:value-of select="@href"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:footnote|tr:xref|tr:cite|tr:tabular|
		       tr:image|tr:table|tr:figure">
    <xsl:message terminate="no">
      <xsl:value-of
	  select="concat('Element ', local-name(), ' not allowed.')"/>
    </xsl:message>
  </xsl:template>

</xsl:stylesheet>

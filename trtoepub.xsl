<?xml version="1.0" encoding="utf-8"?>

<!--

trtoepub.xsl - translates Techrepv2 to EPUB.
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

  <xsl:template name="id-attribute">
    <xsl:attribute name="id">
      <xsl:apply-templates select="." mode="id"/>
    </xsl:attribute>
  </xsl:template>

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
	<link rel="stylesheet" href="css/tr.css" type="text/css"/>
	<xsl:element name="title" namespace="http://www.w3.org/1999/xhtml">
	  <xsl:call-template name="select-local">
	    <xsl:with-param name="cs">Technická zpráva &#x2013; </xsl:with-param>
	    <xsl:with-param name="en">Technical report &#x2013; </xsl:with-param>
	  </xsl:call-template>
	  <xsl:value-of select="tr:report/tr:title"/>
	</xsl:element>
      </head>
      <body>
	<xsl:apply-templates select="tr:report/tr:body"/>
	<xsl:if test="tr:report//tr:footnote">
	  <xsl:element name="hr" namespace="http://www.w3.org/1999/xhtml"/>
	  <xsl:element name="p" namespace="http://www.w3.org/1999/xhtml">
	    <xsl:element name="strong" namespace="http://www.w3.org/1999/xhtml">
	      <xsl:text>Footnotes:</xsl:text>
	    </xsl:element>
	  </xsl:element>
	  <xsl:element name="table" namespace="http://www.w3.org/1999/xhtml">
	    <xsl:element name="tbody" namespace="http://www.w3.org/1999/xhtml">
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

  <xsl:template match="tr:authors">
    <xsl:element name="p" namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates select="tr:author"/>
    </xsl:element>
    <xsl:element name="p" namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates select="tr:affiliation"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:author">
    <xsl:element name="big" namespace="http://www.w3.org/1999/xhtml">
      <xsl:element name="strong" namespace="http://www.w3.org/1999/xhtml">
	<xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
    <xsl:if test="id(@affil)">
      <xsl:if test="count(parent::*/tr:affiliation)&gt;1
		    and count(parent::*/tr:author)&gt;1">
	<xsl:element name="sup" namespace="http://www.w3.org/1999/xhtml">
	  <xsl:for-each select="id(@affil)">
	    <xsl:number/>
	    <xsl:if test="position()!=last()">,</xsl:if>
	  </xsl:for-each>
	</xsl:element>
      </xsl:if>
    </xsl:if>
    <xsl:if test="following-sibling::tr:author">
      <xsl:element name="big" namespace="http://www.w3.org/1999/xhtml">
	<xsl:element name="strong" namespace="http://www.w3.org/1999/xhtml">
	  <xsl:text>, </xsl:text>
	</xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tr:affiliation">
    <xsl:if test="count(parent::*/tr:affiliation)&gt;1
		  and count(parent::*/tr:author)&gt;1">
      <xsl:element name="sup" namespace="http://www.w3.org/1999/xhtml">
	<xsl:number/>
      </xsl:element>
    </xsl:if>
    <xsl:element name="em" namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates/>
    </xsl:element>
    <xsl:element name="br" namespace="http://www.w3.org/1999/xhtml"/>
  </xsl:template>

  <xsl:template match="tr:title">
    <xsl:element name="h1" namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:abstract">
    <xsl:element name="h2" namespace="http://www.w3.org/1999/xhtml">
      <xsl:call-template name="select-local">
	<xsl:with-param name="cs">Abstrakt</xsl:with-param>
	<xsl:with-param name="en">Abstract</xsl:with-param>
      </xsl:call-template>
    </xsl:element>
    <xsl:choose>
      <xsl:when test="tr:p">
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="p" namespace="http://www.w3.org/1999/xhtml">
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tr:keywords">
    <xsl:element name="p" namespace="http://www.w3.org/1999/xhtml">
      <xsl:element name="em" namespace="http://www.w3.org/1999/xhtml">
	<xsl:call-template name="select-local">
	  <xsl:with-param name="cs">Klíčová slova</xsl:with-param>
	  <xsl:with-param name="en">Keywords</xsl:with-param>
	</xsl:call-template>
	<xsl:text>: </xsl:text>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:body">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tr:h1">
    <xsl:element name="h2" namespace="http://www.w3.org/1999/xhtml">
      <xsl:call-template name="id-attribute"/>
      <xsl:apply-templates select="." mode="number"/>
      <xsl:text>&#xA0;&#xA0;</xsl:text>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:h2">
    <xsl:element name="h3" namespace="http://www.w3.org/1999/xhtml">
      <xsl:call-template name="id-attribute"/>
      <xsl:apply-templates select="." mode="number"/>
      <xsl:text>&#xA0;&#xA0;</xsl:text>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:h3">
    <xsl:element name="h4" namespace="http://www.w3.org/1999/xhtml">
      <xsl:call-template name="id-attribute"/>
      <xsl:apply-templates select="." mode="number"/>
      <xsl:text>&#xA0;&#xA0;</xsl:text>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:appendix">
    <xsl:element name="h2" namespace="http://www.w3.org/1999/xhtml">
      <xsl:call-template name="id-attribute"/>
      <xsl:call-template name="select-local">
	<xsl:with-param name="cs">Dodatek</xsl:with-param>
	<xsl:with-param name="en">Appendix</xsl:with-param>
      </xsl:call-template>
      <xsl:text>&#xA0;</xsl:text>
      <xsl:apply-templates select="." mode="number"/>
      <xsl:text>&#xA0;&#xA0;</xsl:text>
      <xsl:apply-templates/>
    </xsl:element>
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

  <xsl:template match="tr:footnote">
    <xsl:variable name="fnnum">
      <xsl:number level="any"/>
    </xsl:variable>
    <xsl:element name="sup" namespace="http://www.w3.org/1999/xhtml">
      <xsl:element name="a" namespace="http://www.w3.org/1999/xhtml">
	<xsl:attribute name="href">
	  <xsl:value-of select="concat('#fn_', $fnnum)"/>
	</xsl:attribute>
	<xsl:attribute name="name">
	  <xsl:value-of select="concat('fr_', $fnnum)"/>
	</xsl:attribute>
	<xsl:value-of select="$fnnum"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:footnote" mode="list">
    <xsl:variable name="fnnum">
      <xsl:number level="any"/>
    </xsl:variable>
    <xsl:element name="tr" namespace="http://www.w3.org/1999/xhtml">
      <xsl:element name="td" namespace="http://www.w3.org/1999/xhtml">
	<xsl:element name="a" namespace="http://www.w3.org/1999/xhtml">
	  <xsl:attribute name="name">
	    <xsl:value-of select="concat('fn_', $fnnum)"/>
	  </xsl:attribute>
	  <xsl:attribute name="href">
	    <xsl:value-of select="concat('#fr_', $fnnum)"/>
	  </xsl:attribute>
	  <xsl:number level="any"/>
	  <xsl:text>.</xsl:text>
	</xsl:element>
	<xsl:text>&#xA0;</xsl:text>
      </xsl:element>
      <xsl:element name="td" namespace="http://www.w3.org/1999/xhtml">
	<xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:xref">
    <xsl:variable name="notraw" select="not(@raw='true' or @raw=1)"/>
    <xsl:variable name="reftext">
      <xsl:choose>
	<xsl:when test="id(@linkend)">
	  <xsl:if test="$notraw">
	    <xsl:apply-templates select="id(@linkend)" mode="label"/>
	    <xsl:text>&#xA0;</xsl:text>
	  </xsl:if>
	  <xsl:apply-templates select="id(@linkend)" mode="number"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:message terminate="no">
	    <xsl:text>Cross-reference target not found: </xsl:text>
	    <xsl:value-of select="@linkend"/>
	  </xsl:message>
	  <xsl:element name="strong" namespace="http://www.w3.org/1999/xhtml">
	    <xsl:text>??</xsl:text>
	  </xsl:element>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="a" namespace="http://www.w3.org/1999/xhtml">
      <xsl:attribute name="href">
	<xsl:value-of select="concat('#',@linkend)"/>
      </xsl:attribute>
      <xsl:choose>
	<xsl:when test="descendant::text()">
	  <xsl:apply-templates/>
	  <xsl:choose>
	    <xsl:when test="$notraw">
	      <xsl:text> (</xsl:text>
	      <xsl:value-of select="$reftext"/>
	      <xsl:text>)</xsl:text>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:text>&#xA0;</xsl:text>
	      <xsl:value-of select="$reftext"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$reftext"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:cite">
    <xsl:element name="a" namespace="http://www.w3.org/1999/xhtml">
      <xsl:attribute name="href">
	<xsl:value-of select="concat('#', @bibref)"/>
      </xsl:attribute>
      <xsl:variable name="cit" select="id(@bibref)"/>
      <xsl:choose>
	<xsl:when test="$cit">
	  <xsl:apply-templates select="$cit" mode="number"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:message terminate="no">
	    <xsl:text>Bibliographic reference not found: </xsl:text>
	    <xsl:value-of select="@bibref"/>
	  </xsl:message>
	  <xsl:text>[??]</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:biblist">
    <xsl:element name="h2" namespace="http://www.w3.org/1999/xhtml">
      <xsl:call-template name="id-attribute"/>
      <xsl:call-template name="select-local">
	<xsl:with-param name="cs">Literatura</xsl:with-param>
	<xsl:with-param name="en">References</xsl:with-param>
      </xsl:call-template>
    </xsl:element>
      <xsl:element name="table" namespace="http://www.w3.org/1999/xhtml">
	<xsl:attribute name="border">0</xsl:attribute>
	<xsl:element name="tbody" namespace="http://www.w3.org/1999/xhtml">
	  <xsl:attribute name="valign">top</xsl:attribute>
	  <xsl:apply-templates select="tr:bibitem"/>
	</xsl:element>
      </xsl:element>
  </xsl:template>

  <xsl:template match="tr:bibitem">
    <xsl:element name="tr" namespace="http://www.w3.org/1999/xhtml">
      <xsl:element name="td" namespace="http://www.w3.org/1999/xhtml">
	<xsl:element name="a" namespace="http://www.w3.org/1999/xhtml">
	  <xsl:attribute name="name">
	    <xsl:value-of select="@xml:id"/>
	  </xsl:attribute>
	  <xsl:apply-templates select="." mode="number"/>
	</xsl:element>
	<xsl:text>&#xA0;</xsl:text>
      </xsl:element>
      <xsl:element name="td" namespace="http://www.w3.org/1999/xhtml">
	<xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:tabular">
    <xsl:element name="table" namespace="http://www.w3.org/1999/xhtml">
      <xsl:attribute name="cellspacing">0</xsl:attribute>
      <xsl:attribute name="class">sede blockcenter</xsl:attribute>
      <xsl:apply-templates select="tr:tr"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:tr">
    <xsl:element name="tr" namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates select="@bgcolor|tr:th|tr:td"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:th|tr:td">
    <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates select="@bgcolor|@align|@colspan"/>
      <xsl:variable name="colnum">
	<xsl:number/>
      </xsl:variable>
      <xsl:call-template name="col-align">
	<xsl:with-param
	    name="code"
	    select="substring(ancestor::tr:tabular/@colspec, $colnum, 1)"/>
      </xsl:call-template>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@bgcolor|@align|@colspan">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="tr:image">
    <xsl:variable name="srcfile" select="tr:source[@format='JPEG' or
				@format='PNG' or @format='GIF' or
				@format='SVG']/@file"/>
      <xsl:element name="img" namespace="http://www.w3.org/1999/xhtml">
	<xsl:attribute name="src">
	  <xsl:choose>
	    <xsl:when test="$srcfile">
	      <xsl:value-of select="$srcfile[1]"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="tr:source[1]/@file"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:attribute>
	<xsl:attribute name="alt">[Image]</xsl:attribute>
      </xsl:element>
  </xsl:template>

  <xsl:template match="tr:table|tr:figure">
    <xsl:element name="div" namespace="http://www.w3.org/1999/xhtml">
      <xsl:attribute name="class">center</xsl:attribute>
      <xsl:apply-templates select="@xml:id"/>
      <xsl:apply-templates select="tr:p|tr:pre|tr:blockquote|tr:image|
				   tr:tabular|tr:ol|tr:ul|tr:dl"/>
      <xsl:apply-templates select="tr:caption"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:caption">
    <xsl:element name="p" namespace="http://www.w3.org/1999/xhtml">
      <xsl:element name="em" namespace="http://www.w3.org/1999/xhtml">
	<xsl:apply-templates select="parent::*" mode="label"/>
	<xsl:text>&#xA0;</xsl:text>
	<xsl:apply-templates select="parent::*" mode="number"/>
	<xsl:text>.&#xA0;</xsl:text>
	<xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>

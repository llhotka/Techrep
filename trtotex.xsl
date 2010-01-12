<?xml version="1.0" encoding="utf-8"?>

<!--
Program name: trtotex.xsl
Description: This stylesheet translates Techrep2 to TeX macros
Author: Ladislav Lhotka <lhotka@cesnet.cz>

Copyright © 2007-2009 CESNET

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

  <xsl:include href="trto-lib.xsl"/>

  <!-- Final mode switch -->
  <xsl:param name="final" select="0"/>

  <!-- Item labels for an unordered list with respect to its depth -->
  <xsl:param name="bullets">&#x2014;&#x2022;&#x2013;-------</xsl:param>

  <!-- Characters that do no need preceding italic correction -->
  <xsl:param name="noic">.,</xsl:param>

  <!-- Table spacing -->
  <xsl:param name="tabskip">1em</xsl:param>

  <xsl:output method="text"/>

  <xsl:strip-space elements="tr:body tr:blockquote tr:ol tr:ul tr:dl
			     tr:figure tr:table tr:tr tr:td tr:th"/>

  <xsl:variable name="NL">
    <xsl:text>
</xsl:text>
  </xsl:variable>

  <xsl:variable name="NLNL">
    <xsl:value-of select="concat($NL,$NL)"/>
  </xsl:variable>

  <!-- Translation variables 
       characters that have special meaning in TeX are mapped to their
       exotic Unicode relatives (mainly FULLWIDTH ...) and these are
       then made active and appropriately defined for XeTeX.
  -->

  <xsl:variable name="chfrom">#$%&amp;\^_{}~</xsl:variable>

  <xsl:variable name="chto">&#xff03;&#xff04;&#xff05;&#xff06;&#xff3c;&#xff3e;&#xff3f;&#xff5b;&#xff5d;&#xff5e;</xsl:variable>

  <xsl:template name="TeXopt">
    <xsl:param name="arg"/>
    <xsl:text>[</xsl:text>
    <xsl:value-of select="$arg"/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template name="TeXgroup">
    <xsl:param name="arg"/>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="$arg"/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template name="TeX-table-template">
    <xsl:param name="colspec"/>
    <xsl:if test="string-length($colspec)&gt;0">
      <xsl:variable name="result">
	<xsl:choose>
	  <xsl:when test="starts-with($colspec,'l')">
	    <xsl:text>#\hfil</xsl:text>
	  </xsl:when>
	  <xsl:when test="starts-with($colspec,'c')">
	    <xsl:text>\hfil#\hfil</xsl:text>
	  </xsl:when>
	  <xsl:when test="starts-with($colspec,'r')">
	    <xsl:text>\hfil#</xsl:text>
	  </xsl:when>
	</xsl:choose>
      </xsl:variable>
      <xsl:choose>
	<xsl:when test="string-length($colspec)=1">
	  <xsl:value-of select="concat($result,'\tabskip=0pt\cr ')"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="concat($result,'&amp;')"/>
	  <xsl:call-template name="TeX-table-template">
	    <xsl:with-param name="colspec" select="substring($colspec,2)"/>
	  </xsl:call-template>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name="table-cell">
    <xsl:param name="content"/>
    <xsl:apply-templates select="@colspan"/>
    <xsl:if test="@align='right' or @align='center'">
      <xsl:text>\hfill </xsl:text>
    </xsl:if>
    <xsl:value-of select="$content"/>
    <xsl:if test="@align='left' or @align='center'">
      <xsl:text>\hfill </xsl:text>
    </xsl:if>
    <xsl:if test="position()!=last()">
      <xsl:text>&amp;</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@colspan">
    <xsl:text>\multispan</xsl:text>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg" select="."/>
    </xsl:call-template>
  </xsl:template>

  <!-- Root element -->

  <xsl:template match="tr:report">
    <xsl:text>\input techrep</xsl:text>
    <xsl:value-of select="$NL"/>
    <xsl:if test="$final=1 or @status='final'">
      <xsl:text>\finalMode</xsl:text>
      <xsl:value-of select="$NL"/>
    </xsl:if>
    <xsl:if test="@xml:lang">
      <xsl:text>\setlang</xsl:text>
      <xsl:call-template name="TeXgroup">
	<xsl:with-param name="arg" select="@xml:lang"/>
      </xsl:call-template>
      <xsl:value-of select="$NL"/>
    </xsl:if>
    <xsl:value-of select="concat('\report',$NL)"/>
    <xsl:apply-templates select="@number"/>
    <xsl:apply-templates select="tr:title"/>
    <xsl:apply-templates select="tr:authors"/>
    <xsl:apply-templates select="tr:date"/>
    <xsl:if test="tr:title">
      <xsl:text>\makeTitle</xsl:text>
      <xsl:value-of select="$NLNL"/>
    </xsl:if>
    <xsl:apply-templates select="tr:abstract"/>
    <xsl:apply-templates select="tr:keywords"/>
    <xsl:apply-templates select="tr:body"/>
    <xsl:value-of select="$NL"/>
    <xsl:value-of select="concat('\endReport',$NL)"/>
  </xsl:template>

  <xsl:template match="tr:report/@number">
    <xsl:text>\repnumber</xsl:text>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg" select="."/>
    </xsl:call-template>
    <xsl:value-of select="$NL"/>
  </xsl:template>

  <xsl:template match="tr:date">
    <xsl:text>\recdate</xsl:text>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg" select="."/>
    </xsl:call-template>
    <xsl:value-of select="$NL"/>
  </xsl:template>

  <xsl:template match="tr:title">
    <xsl:text>\title</xsl:text>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:value-of select="$NL"/>
    <xsl:if test="@short">
      <xsl:text>\shortTitle</xsl:text>
      <xsl:call-template name="TeXgroup">
	<xsl:with-param name="arg">
	  <xsl:value-of select="@short"/>
	</xsl:with-param>
      </xsl:call-template>
    <xsl:value-of select="$NL"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tr:authors">
    <xsl:apply-templates select="tr:author"/>
    <xsl:apply-templates select="tr:affiliation"/>
  </xsl:template>

  <xsl:template match="tr:author">
    <xsl:text>\author</xsl:text>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg" select="."/>
    </xsl:call-template>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:for-each select="id(@affil)">
	  <xsl:number/>
	  <xsl:if test="position()!=last()">,</xsl:if>
	</xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg" select="tr:email"/>
    </xsl:call-template>
    <xsl:value-of select="$NL"/>
  </xsl:template>

  <xsl:template match="tr:affiliation">
    <xsl:text>\affiliation</xsl:text>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg" select="."/>
    </xsl:call-template>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:number/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:value-of select="$NL"/>
  </xsl:template>

  <xsl:template match="tr:abstract">
    <xsl:text>\abstract</xsl:text>
    <xsl:value-of select="$NL"/>
    <xsl:text>\noindent </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\endAbstract</xsl:text>
    <xsl:value-of select="$NLNL"/>
  </xsl:template>

  <xsl:template match="tr:keywords">
    <xsl:text>\keywords</xsl:text>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:value-of select="$NLNL"/>
  </xsl:template>

  <xsl:template match="tr:body">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tr:h1">
    <xsl:choose>
      <xsl:when test="@role='loose'">
	<xsl:text>\section{}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>\section</xsl:text>
	<xsl:call-template name="TeXgroup">
	  <xsl:with-param name="arg">
	    <xsl:apply-templates select="." mode="number"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:value-of select="$NLNL"/>
  </xsl:template>

  <xsl:template match="tr:h2">
    <xsl:text>\subsection</xsl:text>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:apply-templates select="." mode="number"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:value-of select="$NLNL"/>
  </xsl:template>

  <xsl:template match="tr:h3">
    <xsl:text>\subsubsection</xsl:text>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:apply-templates select="." mode="number"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:value-of select="$NLNL"/>
  </xsl:template>

  <xsl:template match="tr:appendix">
    <xsl:text>\appendix</xsl:text>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:apply-templates select="." mode="number"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:value-of select="$NLNL"/>
  </xsl:template>

  <xsl:template match="tr:p">
    <xsl:if test="name(preceding-sibling::*[1])='h1' or
		  name(preceding-sibling::*[1])='h2' or
		  name(preceding-sibling::*[1])='h3'">
      <xsl:text>\noindent </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:value-of select="$NLNL"/>
  </xsl:template>

  <xsl:template match="tr:pre">
    <xsl:choose>
      <xsl:when test="@numbered='true'">
	<xsl:text>\numberedVerbatim</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>\verbatim</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$NL"/>
    <xsl:value-of select="."/>
    <xsl:value-of select="concat('&#xa4;',$NLNL)"/>
  </xsl:template>

  <xsl:template match="tr:blockquote">
    <xsl:text>\blockQuote</xsl:text>
    <xsl:value-of select="$NL"/>
    <xsl:apply-templates/>
    <xsl:text>\endBlockQuote</xsl:text>
    <xsl:value-of select="$NLNL"/>
  </xsl:template>

  <xsl:template match="tr:ol">
    <xsl:text>\orderedList</xsl:text>
    <!-- Is it single-sentence list? -->
    <xsl:if test="ancestor::tr:p">
      <xsl:call-template name="TeXopt">
	<xsl:with-param name="arg">)</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:choose>
	  <xsl:when test="@labels">
	    <xsl:value-of select="@labels"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:variable name="llev"
			  select="count(ancestor::tr:ol)"/>
	    <xsl:choose>
	      <xsl:when test="$llev=0">arabic</xsl:when>
	      <xsl:when test="$llev=1">alpha</xsl:when>
	      <xsl:when test="$llev=2">roman</xsl:when>
	      <xsl:otherwise>callout</xsl:otherwise>
	    </xsl:choose>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="test-compact"/>
    <xsl:if test="@continue">
      <xsl:text>\itemCount=</xsl:text>
      <xsl:apply-templates select="id(@continue)" mode="itemcount"/>
    </xsl:if>
    <xsl:value-of select="$NL"/>
    <xsl:apply-templates/>
    <xsl:text>\endList</xsl:text>
    <xsl:value-of select="$NLNL"/>    
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

  <xsl:template name="test-compact">
      <xsl:if test="@compact='true' or @compact=1 or ancestor::p">
	<xsl:text>\compactList</xsl:text>
      </xsl:if>
  </xsl:template>

  <xsl:template match="tr:li">
    <xsl:text>\item </xsl:text>
    <xsl:apply-templates/>
    <xsl:value-of select="$NL"/>
  </xsl:template>

  <xsl:template match="tr:ul">
    <xsl:text>\unorderedList</xsl:text>
    <xsl:call-template name="TeXopt">
      <xsl:with-param
	  name="arg"
	  select="substring($bullets,count(ancestor-or-self::tr:ul),1)"/>
    </xsl:call-template>
    <xsl:call-template name="test-compact"/>
    <xsl:value-of select="$NL"/>
    <xsl:apply-templates/>
    <xsl:text>\endList</xsl:text>
    <xsl:value-of select="$NLNL"/>
  </xsl:template>

  <xsl:template match="tr:dl">
    <xsl:text>\definitionList</xsl:text>
    <xsl:value-of select="$NL"/>
    <xsl:apply-templates/>
    <xsl:text>\endList</xsl:text>
    <xsl:value-of select="$NLNL"/>
  </xsl:template>

  <xsl:template match="tr:dt">
    <xsl:text>\term</xsl:text>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:value-of select="$NL"/>
  </xsl:template>

  <xsl:template match="tr:dd">
    <xsl:text>\description </xsl:text>
    <xsl:apply-templates/>
    <xsl:value-of select="$NL"/>
  </xsl:template>

  <xsl:template name="figtab-body">
    <xsl:text>\setbox0=\vbox{</xsl:text>
    <xsl:apply-templates select="tr:p|tr:pre|tr:blockquote|tr:image|
				 tr:tabular|tr:ol|tr:ul|tr:dl"/>
    <xsl:value-of select="concat('}',$NL)"/>
    <xsl:text>\centerline{\box0}</xsl:text>
    <xsl:value-of select="$NL"/>
  </xsl:template>

  <xsl:template match="tr:figure">
    <xsl:text>\figure</xsl:text>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:apply-templates select="." mode="number"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="figtab-body"/>
    <xsl:value-of select="concat('\medskip',$NL)"/>
    <xsl:apply-templates select="tr:caption"/>
    <xsl:text>\endFigure</xsl:text>
    <xsl:value-of select="$NLNL"/>
  </xsl:template>

  <xsl:template match="tr:table">
    <xsl:text>\table</xsl:text>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:apply-templates select="." mode="number"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:value-of select="$NL"/>
    <xsl:apply-templates select="tr:caption"/>
    <xsl:value-of select="concat('\medskip',$NL)"/>
    <xsl:call-template name="figtab-body"/>
    <xsl:text>\endTable</xsl:text>
    <xsl:value-of select="$NLNL"/>
  </xsl:template>

  <xsl:template match="tr:image">
    <xsl:text>\image</xsl:text>
    <xsl:variable name="pdf-source"
		  select="tr:source[@format='PDF']/@file"/>
    <xsl:choose>
      <xsl:when test="$pdf-source">
	<xsl:call-template name="TeXgroup">
	  <xsl:with-param name="arg">PDF</xsl:with-param>
	</xsl:call-template>
	<xsl:call-template name="TeXgroup">
	  <xsl:with-param name="arg"
			  select="$pdf-source"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name="TeXgroup">
	  <xsl:with-param name="arg" select="tr:source[1]/@format"/>
	</xsl:call-template>
	<xsl:call-template name="TeXgroup">
	  <xsl:with-param name="arg"
			  select="tr:source[1]/@file"/>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="concat('%',$NL)"/>
  </xsl:template>

  <xsl:template match="tr:caption">
    <xsl:text>\caption</xsl:text>
    <xsl:value-of select="$NL"/>
    <xsl:apply-templates/>
    <xsl:text>\endCaption</xsl:text>
    <xsl:value-of select="$NL"/>
  </xsl:template>

  <xsl:template match="tr:tabular">
    <xsl:text>\halign{\tabskip=</xsl:text>
    <xsl:value-of select="$tabskip"/>
    <xsl:value-of select="$NL"/>
    <xsl:call-template name="TeX-table-template">
      <xsl:with-param name="colspec" select="@colspec"/>
    </xsl:call-template>
    <xsl:apply-templates select="tr:tr"/>
    <xsl:value-of select="concat('}',$NL)"/>
  </xsl:template>

  <xsl:template match="tr:tr">
    <xsl:apply-templates select="tr:th|tr:td"/>
    <xsl:text>\cr </xsl:text>
  </xsl:template>

  <xsl:template match="tr:td">
    <xsl:call-template name="table-cell">
      <xsl:with-param name="content">
	<xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tr:th">
    <xsl:call-template name="table-cell">
      <xsl:with-param name="content">
	<xsl:call-template name="TeXgroup">
	  <xsl:with-param name="arg">
	    <xsl:text>\bf </xsl:text>
	    <xsl:apply-templates/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Inline elements -->

  <xsl:template match="tr:tt">
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:text>\tt </xsl:text>
	<xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tr:sup">
    <xsl:text>${}^{</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>}$</xsl:text>
  </xsl:template>

  <xsl:template match="tr:sub">
    <xsl:text>${}_{</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>}$</xsl:text>
  </xsl:template>

  <xsl:template match="tr:em">
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:choose>
	  <xsl:when test="parent::tr:title|parent::tr:h1|
			  parent::tr:h2|parent::tr:h3">
	    <xsl:text>\ib </xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:text>\it </xsl:text>
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:apply-templates/>
	<xsl:variable name="nextchar"
		      select="substring(normalize-space(following-sibling::text()[1]),1,1)"/>
	<xsl:if test="not(contains($noic,$nextchar))">
	  <xsl:text>\/</xsl:text>
	</xsl:if>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tr:tt|tr:input">
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:text>\tt </xsl:text>
	<xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tr:strong">
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:text>\bf </xsl:text>
	<xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tr:phrase|tr:command|tr:uri|tr:file">
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:text>\sl </xsl:text>
	<xsl:apply-templates/>
	<xsl:variable name="nextchar"
		      select="substring(normalize-space(following-sibling::text()[1]),1,1)"/>
	<xsl:if test="not(contains($noic,$nextchar))">
	  <xsl:text>\/</xsl:text>
	</xsl:if>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tr:footnote">
    <xsl:text>\footNote</xsl:text>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
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
    <xsl:apply-templates/>
    <xsl:text>\footNote</xsl:text>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:value-of select="concat('\tt ',translate(@href,$chfrom,$chto))"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tr:xref">
    <xsl:apply-templates/>
    <xsl:choose>
      <xsl:when test="descendant::text()">
	<xsl:if test="not(@raw='true' or @raw=1)">
	  <xsl:text> (</xsl:text>
	  <xsl:apply-templates select="id(@linkend)"
			       mode="label"/>
	</xsl:if>
	<xsl:text>&#xA0;</xsl:text>
	<xsl:apply-templates select="id(@linkend)"
			     mode="number"/>
	<xsl:if test="not(@raw='true' or @raw=1)">
	  <xsl:text>)</xsl:text>
	</xsl:if>
      </xsl:when>
      <xsl:otherwise>
	<xsl:if test="not(@raw='true' or @raw=1)">
	  <xsl:apply-templates select="id(@linkend)"
			       mode="label"/>
	  <xsl:text>&#xA0;</xsl:text>
	</xsl:if>
	<xsl:apply-templates select="id(@linkend)"
			     mode="number"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tr:cite">
    <xsl:apply-templates select="id(@bibref)" mode="number"/> 
  </xsl:template>

  <xsl:template match="tr:index">
    <xsl:choose>
      <xsl:when test="@silent='true'">
	<xsl:text>\silentIndex</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>\index</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@under">
      <xsl:call-template name="TeXopt">
	<xsl:with-param name="arg" select="@under"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@role">
	<xsl:call-template name="TeXgroup">
	  <xsl:with-param name="arg" select="@role"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name="TeXgroup">
	  <xsl:with-param name="arg">no</xsl:with-param>
	</xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg" select="."/>
    </xsl:call-template>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg" select="."/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tr:br">
    <xsl:value-of select="concat('\hfil\break',$NL)"/>
  </xsl:template>

  <xsl:template match="tr:biblist">
    <xsl:value-of select="concat('\section{}{References}',$NLNL)"/>
    <xsl:value-of select="concat('\bibList',$NL)"/>
    <xsl:apply-templates/>
    <xsl:value-of select="concat('\endList',$NLNL)"/>
  </xsl:template>

  <xsl:template match="tr:bibitem">
    <xsl:text>\bibItem</xsl:text>
    <xsl:call-template name="TeXgroup">
      <xsl:with-param name="arg">
	<xsl:apply-templates select="." mode="number"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:value-of select="translate(.,$chfrom,$chto)"/>
  </xsl:template>

</xsl:stylesheet>

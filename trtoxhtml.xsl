<?xml version="1.0" encoding="utf-8"?>

<!--
trtoxhtml.xsl: translates techrep XML v2 to XHTML
Copyright © 2008 CESNET
Author: Ladislav Lhotka
-->


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:tr="http://cesnet.cz/ns/techrep/base/2.0"
		xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

  <xsl:output method="xml" indent="yes"/>

  <xsl:include href="cesnet-head.xsl"/>
  <xsl:include href="cesnet-body.xsl"/>

  <xsl:variable name="version">2.0</xsl:variable>

  <!-- Selection of localised terms -->

  <xsl:template name="select-local">
    <xsl:param name="cs"/>
    <xsl:param name="en"/>
    <xsl:choose>
      <xsl:when test="ancestor-or-self::tr:*[@xml:lang='cs']">
	<xsl:value-of select="$cs"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$en"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:variable name="NL">
    <xsl:text>
</xsl:text>
  </xsl:variable>

  <xsl:variable name="NLNL">
    <xsl:value-of select="concat($NL,$NL)"/>
  </xsl:variable>

  <!-- Autogenerated references
       "label" mode generates the element's label for crossrefs
       "number" mode generates the number of the matched element -->


  <xsl:template match="tr:h1|tr:h2|tr:h3" mode="label">
    <xsl:call-template name="select-local">
      <xsl:with-param name="cs">Oddíl</xsl:with-param>
      <xsl:with-param name="en">Section</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tr:h1[not(@role='loose')]" mode="number">
    <xsl:number value="count(preceding-sibling::tr:h1[not(@role='loose')])+1"/>
  </xsl:template>
  
  <xsl:template match="tr:h2" mode="number">
    <xsl:variable
	name="mysec"
	select="(preceding-sibling::tr:h1|preceding-sibling::tr:appendix)[last()]"/>
    <xsl:apply-templates select="$mysec" mode="number"/>
    <xsl:text>.</xsl:text>
    <xsl:number
	value="count(preceding-sibling::tr:h2[preceding-sibling::tr:h1[1]=$mysec])+1"/>
  </xsl:template>

  <xsl:template match="tr:h3" mode="number">
    <xsl:variable name="mysubsec" select="preceding-sibling::tr:h2[1]"/>
    <xsl:apply-templates select="$mysubsec" mode="number"/>
    <xsl:text>.</xsl:text>
    <xsl:number
	value="count(preceding-sibling::tr:h3[preceding-sibling::tr:h2[1]=$mysubsec])+1 "/>
  </xsl:template>

  <xsl:template match="tr:appendix" mode="label">
    <xsl:call-template name="select-local">
      <xsl:with-param name="cs">Dodatek</xsl:with-param>
      <xsl:with-param name="en">Appendix</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tr:appendix" mode="number">
    <xsl:number format="A"/>
  </xsl:template>
  
  <xsl:template match="tr:figure" mode="label">
    <xsl:call-template name="select-local">
      <xsl:with-param name="cs">Obrázek</xsl:with-param>
      <xsl:with-param name="en">Figure</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tr:figure" mode="number">
    <xsl:number/>
  </xsl:template>

  <xsl:template match="tr:table" mode="label">
    <xsl:call-template name="select-local">
      <xsl:with-param name="cs">Tabulka</xsl:with-param>
      <xsl:with-param name="en">Table</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tr:table" mode="number">
    <xsl:number/>
  </xsl:template>

  <xsl:template match="tr:ol/tr:li" mode="label">
    <xsl:call-template name="select-local">
      <xsl:with-param name="cs">položka</xsl:with-param>
      <xsl:with-param name="en">item</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tr:bibitem" mode="number">
    <xsl:text>[</xsl:text>
    <xsl:number/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  <!-- Root element -->

  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:element name="head">
	<xsl:element name="meta">
	  <xsl:attribute name="http-equiv">Content-Type</xsl:attribute>
	  <xsl:attribute name="content">text/html</xsl:attribute>
	  <xsl:attribute name="charset">utf-8</xsl:attribute>
	</xsl:element>
	<xsl:element name="meta">
	  <xsl:attribute name="name">generator</xsl:attribute>
	  <xsl:attribute name="content">
	     <xsl:value-of select="concat('trtoxhtml ', $version)"/>
	  </xsl:attribute>
	</xsl:element>
	<xsl:call-template name="ceshead"/>
	<xsl:element name="title">
	  <xsl:value-of select="tr:report/tr:title"/>
	</xsl:element>
      </xsl:element>
      <xsl:element name="body">
	<xsl:call-template name="cesbody"/>
	<div id="ramecek">
	  <div id="main">
	    <xsl:apply-templates select="tr:report"/>
	    <xsl:if test="tr:report//tr:footnote">
	      <xsl:element name="hr"/>
	      <xsl:element name="p">
		<xsl:element name="strong">
		  <xsl:text>Footnotes:</xsl:text>
		</xsl:element>
	      </xsl:element>
	      <xsl:element name="table">
		<xsl:attribute name="border">0</xsl:attribute>
		<xsl:apply-templates select="tr:report//tr:footnote"
				     mode="list"/>
	      </xsl:element>
	    </xsl:if>
	  </div>
	</div>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@xml:id">
    <xsl:element name="a">
      <xsl:attribute name="name">
	<xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:report">
    <xsl:apply-templates select="tr:title"/>
    <xsl:element name="p">
      <xsl:element name="strong">
	<xsl:call-template name="select-local">
	  <xsl:with-param name="cs">Technická zpráva</xsl:with-param>
	  <xsl:with-param name="en">Technical report</xsl:with-param>
	</xsl:call-template>
	<xsl:text>&#xa0;</xsl:text>
	<xsl:value-of select="@number"/>
      </xsl:element>
    </xsl:element>
    <xsl:element name="p">
      <xsl:element name="big">
	<xsl:element name="strong">
	  <xsl:for-each select="tr:author">
	    <xsl:value-of select="tr:name"/>
	    <xsl:if test="position() != last()">
	      <xsl:text>, </xsl:text>
	    </xsl:if>
	  </xsl:for-each>
	  <xsl:element name="br"/>
	  <xsl:value-of select="tr:date"/>
	</xsl:element>
      </xsl:element>
    </xsl:element>
    <xsl:apply-templates select="tr:abstract"/>
    <xsl:apply-templates select="tr:keywords"/>
    <xsl:apply-templates select="tr:body"/>
  </xsl:template>

  <xsl:template match="tr:title">
    <xsl:element name="h1">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:abstract">
    <xsl:element name="h2">
      <xsl:call-template name="select-local">
	<xsl:with-param name="cs">Abstrakt</xsl:with-param>
	<xsl:with-param name="en">Abstract</xsl:with-param>
      </xsl:call-template>
    </xsl:element>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tr:keywords">
    <xsl:element name="p">
      <xsl:element name="strong">
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
    <xsl:element name="h2">
      <xsl:apply-templates select="@xml:id"/>
      <xsl:apply-templates select="." mode="number"/>
      <xsl:text>&#xA0;&#xA0;</xsl:text>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:h2">
    <xsl:element name="h3">
      <xsl:apply-templates select="@xml:id"/>
      <xsl:apply-templates select="." mode="number"/>
      <xsl:text>&#xA0;&#xA0;</xsl:text>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:h3">
    <xsl:element name="h4">
      <xsl:apply-templates select="@xml:id"/>
      <xsl:apply-templates select="." mode="number"/>
      <xsl:text>&#xA0;&#xA0;</xsl:text>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:appendix">
    <xsl:element name="h2">
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

  <xsl:template match="tr:p|tr:pre|tr:ol|tr:ul|tr:dl|tr:dd|tr:li">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@xml:id"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:strong|tr:sup|tr:sub|tr:blockquote">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:dt">
    <xsl:element name="dt">
      <xsl:element name="strong">
	<xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:em|tr:command|tr:file|tr:uri|tr:phrase">
    <xsl:element name="em">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:tt|tr:input">
    <code><xsl:apply-templates/></code>
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
    <xsl:element name="a">
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
    <xsl:element name="sup">
      <xsl:element name="a">
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
    <xsl:element name="tr">
      <xsl:element name="td">
	<xsl:element name="a">
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
      <xsl:element name="td">
	<xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:xref">
    <xsl:element name="a">
      <xsl:attribute name="href">
	<xsl:value-of select="concat('#',@linkend)"/>
      </xsl:attribute>
      <xsl:choose>
	<xsl:when test="descendant::text()">
	  <xsl:apply-templates/>
	  <xsl:text>&#xA0;</xsl:text>
	  <xsl:apply-templates select="id(@linkend)"
			       mode="number"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:if test="not(@raw='true' or @raw=1)">
	    <xsl:apply-templates select="id(@linkend)"
				 mode="label"/>
	    <xsl:text>&#xa0;</xsl:text>
	  </xsl:if>
	  <xsl:apply-templates select="id(@linkend)"
			       mode="number"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:cite">
    <xsl:element name="a">
      <xsl:attribute name="href">
	<xsl:value-of select="concat('#', @bibref)"/>
      </xsl:attribute>
      <xsl:apply-templates select="id(@bibref)" mode="number"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr:biblist">
    <xsl:element name="h2">
      <xsl:apply-templates select="@xml:id"/>
      <xsl:call-template name="select-local">
	<xsl:with-param name="cs">Literatura</xsl:with-param>
	<xsl:with-param name="en">References</xsl:with-param>
      </xsl:call-template>
    </xsl:element>
      <xsl:element name="table">
	<xsl:attribute name="border">0</xsl:attribute>
	<xsl:element name="tbody">
	  <xsl:attribute name="valign">top</xsl:attribute>
	  <xsl:apply-templates select="tr:bibitem"/>
	</xsl:element>
      </xsl:element>
  </xsl:template>

  <xsl:template match="tr:bibitem">
    <xsl:element name="tr">
      <xsl:element name="td">
	<xsl:element name="a">
	  <xsl:attribute name="name">
	    <xsl:value-of select="@xml:id"/>
	  </xsl:attribute>
	  <xsl:apply-templates select="." mode="number"/>
	</xsl:element>
	<xsl:text>&#xA0;</xsl:text>
      </xsl:element>
      <xsl:element name="td">
	<xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>

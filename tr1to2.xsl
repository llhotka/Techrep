<?xml version="1.0"?>

<!-- Program name: tr1to2.xsl

© CESNET, 2007

Translates the original techrep v1 to version 2.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://cesnet.cz/ns/techrep/base/2.0"
                version="1.0">

  <xsl:output method="xml" indent="yes"/>

  <!-- This parameter controls whether tilde is used as no-break space -->
  <xsl:param name="nbsp-tilde" select="0"/>

  <xsl:strip-space elements="li dd"/>

  <xsl:key name="parpar"
	   match="p"
	   use="generate-id((..|preceding-sibling::h1)[last()])"/>

  <xsl:key name="parblock"
	   match="p|h2|h3|ul|ol|dl|blockquote|obr|tab|pre"
	   use="generate-id((..|preceding-sibling::h1)[last()])"/>

  <xsl:template name="parse-authors">
    <xsl:param name="authors"/>
    <xsl:variable name="ret" select="normalize-space($authors)"/>
    <xsl:choose>
      <xsl:when test="contains($ret,',')">
	<xsl:element name="author">
	  <xsl:element name="name">
	    <xsl:value-of
		select="normalize-space(substring-before($ret,','))"/>
	  </xsl:element>
	</xsl:element>
	<xsl:call-template name="parse-authors">
	  <xsl:with-param name="authors" select="substring-after($ret,',')"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="author">
	  <xsl:element name="name">
	    <xsl:value-of select="$ret"/>
	  </xsl:element>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="handle-secname">
    <xsl:param name="secname"/>
    <xsl:choose>
      <xsl:when
	  test="starts-with(normalize-space(translate($secname,'appendix','APPENDIX')),
		'APPENDIX')">
	<xsl:element name="appendix">
	  <xsl:apply-templates select="@id"/>
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="h1">
	  <xsl:apply-templates select="@id"/>
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="handle-hybrid">
    <!-- Loosely based on recipe 5.3 in XSLT Cookbook -->
    <xsl:choose>
      <xsl:when test="p|pre|blockquote|ol|ul|dl">
	<xsl:apply-templates
	    select="p|pre|blockquote|ol|ul|dl"
	    mode="hybrid"/>
	<xsl:variable
	    name="dernier"
	    select="(p|pre|blockquote|ol|ul|dl)[last()]"/>
	<xsl:variable name="fin"
		      select="$dernier/following-sibling::node()"/>
	<xsl:if test="$fin">
	  <xsl:element name="p">
	    <xsl:apply-templates select="$fin"/>
	  </xsl:element>
	</xsl:if>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="p|pre|blockquote|ol|ul|dl"
		mode="hybrid">
    <xsl:variable name="prev"
		  select="preceding-sibling::*[self::p or
			  self::pre
			  or self::blockquote
			  or self::ol
			  or self::ul
			  or self::dl][last()]"/>
    <xsl:choose>
      <xsl:when test="$prev">
	<xsl:variable name="inter"
		      select="count($prev/following-sibling::node())-
			      count(following-sibling::node())"/>
	<xsl:if test="$inter &gt; 1">
	  <xsl:element name="p">
	    <xsl:apply-templates
		select="$prev/following-sibling::node()
			[position() &lt; $inter]"/>
	  </xsl:element>
	</xsl:if>
      </xsl:when>
      <xsl:otherwise>
	<xsl:if test="preceding-sibling::node()">
	  <xsl:element name="p">
	    <xsl:apply-templates select="preceding-sibling::node()"/>
	  </xsl:element>
	</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="."/>
  </xsl:template>

  <xsl:template match="@id">
    <xsl:attribute name="xml:id">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="@jazyk">
    <xsl:attribute name="xml:lang">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="@cislo">
    <xsl:attribute name="number">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="zprava">
    <xsl:element name="report">
      <xsl:apply-templates select="@*|nazev|autor|datum"/>
      <xsl:variable name="fpar"
		    select="key('parpar',generate-id())[1]"/>
      <xsl:choose>
	<xsl:when
	    test="normalize-space(translate(h1[1],'abstrackKt','ABSTRACCCT'))='ABSTRACT'">
	  <xsl:apply-templates select="$fpar"
			       mode="kw-abs"/>
	  <xsl:apply-templates select="h1[1]" mode="abstract"/>
	</xsl:when>
	<xsl:otherwise>	        <!-- No abstract -->
	  <xsl:choose>
	    <xsl:when test="name($fpar/*[1])='b' and
			    starts-with(normalize-space(
			    translate($fpar/b[1],'keywords','KEYWORDS')),'KEYWORDS')">
	      <xsl:apply-templates select="$fpar" mode="kw-noabs"/>
	    </xsl:when>
	    <xsl:otherwise>     <!-- No keywords -->
	      <xsl:element name="body">
		<xsl:apply-templates
		    select="p|h1|h2|h3|ul|ol|dl|blockquote|obr|tab|pre|seznamknih"/>
	      </xsl:element>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template match="h1" mode="abstract">
    <xsl:element name="abstract">
      <xsl:apply-templates select="@id"/>
      <xsl:apply-templates select="key('parblock',generate-id())"/>
    </xsl:element>
    <xsl:element name="body">
      <xsl:apply-templates select="following-sibling::h1"
			   mode="chunks"/>
      <xsl:apply-templates select="../seznamknih"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="h1" mode="chunks">
    <xsl:call-template name="handle-secname">
      <xsl:with-param name="secname" select="."/>
    </xsl:call-template>
    <xsl:apply-templates select="key('parblock',generate-id())"/>
  </xsl:template>

  <xsl:template match="h1">
    <xsl:call-template name="handle-secname">
      <xsl:with-param name="secname" select="."/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="/zprava/nazev">
    <xsl:element name="title">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="autor">
    <xsl:call-template name="parse-authors">
      <xsl:with-param name="authors" select="."/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="datum">
    <xsl:element name="date">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="p" mode="kw-noabs">
    <xsl:element name="keywords">
      <xsl:value-of select="text()"/>
    </xsl:element>
    <xsl:element name="body">
      <xsl:apply-templates select="following-sibling::*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="p" mode="kw-abs">
    <xsl:element name="keywords">
      <xsl:value-of select="text()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="p|h2|h3|dl|dt|blockquote|pre">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@id"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dd|li">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@id"/>
      <xsl:call-template name="handle-hybrid"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ol|ul">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@id"/>
      <xsl:apply-templates select="@compact"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@compact">
    <xsl:attribute name="compact">
      <xsl:choose>
	<xsl:when test=".='1'">
	  <xsl:text>true</xsl:text>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text>false</xsl:text>	
	</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="obr">
    <xsl:element name="figure">
      <xsl:apply-templates select="@id"/>
      <xsl:element name="image">
	<xsl:element name="source">
	  <xsl:attribute name="file">
	    <xsl:value-of select="@src"/>
	  </xsl:attribute>
	</xsl:element>
      </xsl:element>
      <xsl:element name="caption">
	<xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tab">
    <xsl:element name="table">
      <xsl:apply-templates select="@id"/>
      <xsl:apply-templates select="nazev"/>
      <xsl:element name="tabular">
	<xsl:attribute name="colspec">
	  <xsl:value-of select="@sloupce"/>
	</xsl:attribute>
	<xsl:apply-templates select="tr"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tab/nazev">
    <xsl:element name="caption">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tr">
    <xsl:element name="tr">
      <xsl:apply-templates select="@bgcolor"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="td|th">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@bgcolor|@colspan|@align"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@bgcolor|@colspan|@align">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="seznamknih">
    <xsl:element name="biblist">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="kniha">
    <xsl:element name="bibitem">
      <xsl:apply-templates select="@id"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="cite">
    <xsl:element name="cite">
      <xsl:attribute name="bibref">
	<xsl:value-of select="@href"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="a">
    <xsl:choose>
      <xsl:when test="starts-with(@href,'#')">
	<xsl:value-of select="."/>
	<xsl:text>&#xA0;</xsl:text>
	<xsl:element name="xref">
	  <xsl:attribute name="raw">
	    <xsl:text>true</xsl:text>
	  </xsl:attribute>
	  <xsl:attribute name="linkend">
	    <xsl:value-of select="substring(@href,2)"/>
	  </xsl:attribute>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="a">
	  <xsl:attribute name="href">
	    <xsl:value-of select="@href"/>
	  </xsl:attribute>
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tt|sup|sub|footnote">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="b">
    <xsl:element name="strong">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="i">
    <xsl:element name="em">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="soubor">
    <xsl:element name="file">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="prikaz">
    <xsl:element name="command">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="vstup">
    <xsl:element name="input">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="adresa">
    <xsl:element name="uri">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="uv">
    <xsl:element name="q">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:choose>
      <xsl:when test="$nbsp-tilde>0">
	<xsl:value-of select="translate(.,'~','&#xA0;')"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>

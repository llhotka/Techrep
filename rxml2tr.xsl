<?xml version="1.0"?>

<!-- Program name: techrep2rxml.xsl -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:output method="xml" indent="yes"/>

  <xsl:param name="lang">en</xsl:param>
  <xsl:param name="tr-number">XX/2006</xsl:param>

  <xsl:variable name="NL">
    <xsl:text>
</xsl:text>
  </xsl:variable>

  <xsl:variable name="NLNL">
    <xsl:value-of select="$NL"/>
    <xsl:value-of select="$NL"/>
  </xsl:variable>
  
  <xsl:template name="basename">
    <xsl:param name="fname"/>
    <xsl:value-of select="substring-before($fname,'.')"/>
  </xsl:template>

  <!-- The root element -->

  <xsl:template match="document">
    <xsl:element name="zprava">
      <xsl:attribute name="jazyk">
	<xsl:value-of select="$lang"/>
      </xsl:attribute>
      <xsl:attribute name="cislo">
	<xsl:value-of select="$tr-number"/>
      </xsl:attribute>
      <xsl:apply-templates select="title"/>
      <xsl:apply-templates select="docinfo/author"/>
      <xsl:apply-templates select="docinfo/date"/>
      <xsl:apply-templates select="topic[@classes='abstract']"/>
      <xsl:apply-templates select="docinfo/field[field_name='Keywords']"/>
      <xsl:apply-templates select="section|p"/>
      <xsl:if test="//citation">
	<xsl:element name="seznamknih">
	  <xsl:apply-templates select="//citation"/>
	</xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <xsl:template match="document/title">
    <xsl:value-of select="$NL"/>
    <xsl:element name="nazev">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="docinfo/author">
    <xsl:value-of select="$NL"/>
    <xsl:element name="autor">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="docinfo/date">
    <xsl:value-of select="$NL"/>
    <xsl:element name="datum">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="docinfo/field[field_name='Keywords']">
    <xsl:value-of select="$NLNL"/>
    <xsl:element name="p">
      <xsl:element name="b">
	<xsl:text>Keywords:</xsl:text>
      </xsl:element>
	<xsl:text> </xsl:text>
      <xsl:value-of select="field_body/paragraph"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="topic[@classes='abstract']">
    <xsl:value-of select="$NLNL"/>
    <xsl:element name="h1">
      <xsl:text>Abstract</xsl:text>
    </xsl:element>
    <xsl:apply-templates select="paragraph|block_quote"/>
  </xsl:template>

  <xsl:template match="paragraph">
    <xsl:value-of select="$NL"/>
    <xsl:element name="p">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="paragraph" mode="open">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="section">
    <xsl:apply-templates select="title|paragraph|section|
				 block_quote|bullet_list|
				 enumerated_list|definition_list|
				 figure|literal_block"/>
  </xsl:template>

  <xsl:template match="section/title">
    <xsl:value-of select="$NLNL"/>
    <xsl:element name="{concat('h',
		       format-number(count(ancestor::section),'#'))}">
      <xsl:attribute name="id">
	<xsl:value-of select="../@ids"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="bullet_list">
    <xsl:value-of select="$NL"/>
    <xsl:element name="ul">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="enumerated_list">
    <xsl:value-of select="$NL"/>
    <xsl:element name="ol">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="list_item">
    <xsl:value-of select="$NL"/>
    <xsl:element name="li">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="definition_list">
    <xsl:value-of select="$NL"/>
    <xsl:element name="dl">
      <xsl:apply-templates
	  select="definition_list_item/term|definition_list_item/definition"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="definition_list_item/term">
    <xsl:value-of select="$NL"/>
    <xsl:element name="dt">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="definition_list_item/definition">
    <xsl:value-of select="$NL"/>
    <xsl:element name="dd">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="block_quote">
    <xsl:value-of select="$NLNL"/>
    <xsl:element name="blockquote">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="reference">
    <xsl:element name="a">
      <xsl:apply-templates select="@refuri|@refid"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="reference/@refuri">
    <xsl:attribute name="href">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="reference/@refid">
    <xsl:attribute name="href">
      <xsl:text>#</xsl:text>
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="emphasis">
    <xsl:element name="i">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="strong">
    <xsl:element name="b">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="literal">
    <xsl:element name="tt">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="superscript">
    <xsl:element name="sup">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="subscript">
    <xsl:element name="sub">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="figure">
    <xsl:value-of select="$NLNL"/>
    <xsl:element name="obr">
      <xsl:attribute name="src">
	<xsl:choose>
	  <xsl:when test="reference">
	    <xsl:call-template name="basename">
	      <xsl:with-param name="fname" select="reference/image/@uri"/>
	    </xsl:call-template>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:call-template name="basename">
	      <xsl:with-param name="fname" select="image/@uri"/>
	    </xsl:call-template>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates select="caption"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="figure/caption">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="literal_block">
    <xsl:value-of select="$NL"/>
    <xsl:element name="pre">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="citation_reference">
    <xsl:element name="cite">
      <xsl:attribute name="href">
	<xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="citation">
    <xsl:value-of select="$NL"/>
    <xsl:element name="kniha">
      <xsl:attribute name="id">
	<xsl:value-of select="label"/>
      </xsl:attribute>
      <xsl:apply-templates select="paragraph" mode="open"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>

<?xml version="1.0"?>

<!--

rxml2tr.xsl - transforms reStructuredText XML to Techrep2
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
		xmlns="http://cesnet.cz/ns/techrep/base/2.0"
                version="1.0">

  <xsl:output method="xml" indent="yes"/>

  <xsl:param name="lang">en</xsl:param>
  <xsl:param name="tr-number">XX/20XX</xsl:param>

  <xsl:template name="parse-authors">
    <xsl:param name="authors"/>
    <xsl:variable name="ret" select="normalize-space($authors)"/>
    <xsl:choose>
      <xsl:when test="contains($ret,',')">
	<xsl:element name="author">
	  <xsl:value-of
	      select="normalize-space(substring-before($ret,','))"/>
	</xsl:element>
	<xsl:call-template name="parse-authors">
	  <xsl:with-param name="authors" select="substring-after($ret,',')"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="author">
	  <xsl:value-of select="$ret"/>
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="guess-img-format">
    <xsl:param name="filename"/>
    <xsl:variable name="rest" select="substring-after($filename,'.')"/>
    <xsl:choose>
      <xsl:when test="contains($rest,'.')">
	<xsl:call-template name="guess-img-format">
	  <xsl:with-param name="filename" select="$rest"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:choose>
	  <xsl:when test="$rest='eps' or $rest='ps'">EPS</xsl:when>
	  <xsl:when test="$rest='gif'">GIF</xsl:when>
	  <xsl:when test="$rest='jpg' or $rest='jpeg'">JPEG</xsl:when>
	  <xsl:when test="$rest='pdf'">PDF</xsl:when>
	  <xsl:when test="$rest='png'">PNG</xsl:when>
	  <xsl:when test="$rest='svg'">SVG</xsl:when>
	  <xsl:otherwise>UNKNOWN</xsl:otherwise>
	</xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="repeat-string">
    <xsl:param name="str"/>
    <xsl:param name="rep"/>
    <xsl:value-of select="$str"/>
    <xsl:if test="$rep>1">
      <xsl:call-template name="repeat-string">
	<xsl:with-param name="str" select="$str"/>
	<xsl:with-param name="rep" select="$rep -1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- The root element -->

  <xsl:template match="document">
    <xsl:element name="report">
      <xsl:attribute name="xml:lang">
	<xsl:value-of select="$lang"/>
      </xsl:attribute>
      <xsl:attribute name="number">
	<xsl:value-of select="$tr-number"/>
      </xsl:attribute>
      <xsl:apply-templates select="title"/>
      <xsl:apply-templates select="docinfo/author"/>
      <xsl:apply-templates select="docinfo/date"/>
      <xsl:apply-templates select="topic[@classes='abstract']"/>
      <xsl:apply-templates
	  select="docinfo/field[field_name='Keywords']"/>
      <xsl:element name="body">
	<xsl:apply-templates select="section|p"/>
	<xsl:if test="//citation">
	  <xsl:element name="biblist">
	    <xsl:apply-templates select="//citation"/>
	  </xsl:element>
	</xsl:if>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="document/title">
    <xsl:element name="title">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="docinfo/author">
    <xsl:element name="authors">
      <xsl:call-template name="parse-authors">
	<xsl:with-param name="authors" select="."/>
      </xsl:call-template>
    </xsl:element>
  </xsl:template>

  <xsl:template match="docinfo/date">
    <xsl:element name="date">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="docinfo/field[field_name='Keywords']">
    <xsl:element name="keywords">
      <xsl:value-of select="field_body/paragraph"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="topic[@classes='abstract']">
    <xsl:element name="abstract">
      <xsl:apply-templates select="paragraph|block_quote"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="paragraph">
    <xsl:element name="p">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="paragraph" mode="open">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="section">
    <xsl:if test="@names!='bibliography'">
      <xsl:apply-templates select="title|paragraph|section|
				   block_quote|bullet_list|
				   enumerated_list|definition_list|
				   figure|table|literal_block"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="section/title">
    <xsl:element name="{concat('h',
		       format-number(count(ancestor::section),'#'))}">
      <xsl:attribute name="xml:id">
	<xsl:value-of select="../@ids"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="bullet_list">
    <xsl:element name="ul">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="enumerated_list">
    <xsl:element name="ol">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="list_item">
    <xsl:element name="li">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="definition_list">
    <xsl:element name="dl">
      <xsl:apply-templates
	  select="definition_list_item/term|definition_list_item/definition"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="definition_list_item/term">
    <xsl:element name="dt">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="definition_list_item/definition">
    <xsl:element name="dd">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="block_quote">
    <xsl:choose>
      <xsl:when
	  test="not (figure|bullet_list|enumerated_list|definition_list)">
	<xsl:element name="blockquote">
	  <xsl:apply-templates/>
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="literal_block">
    <xsl:element name="pre">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="reference[@refuri]">
    <xsl:element name="a">
      <xsl:attribute name="href">
	<xsl:value-of select="@refuri"/>
      </xsl:attribute>
      <xsl:value-of select="@name"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="reference[@refid]">
    <xsl:element name="xref">
      <xsl:attribute name="linkend">
	<xsl:value-of select="@refid"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="emphasis">
    <xsl:element name="em">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="strong">
    <xsl:element name="strong">
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
    <xsl:element name="figure">
      <xsl:attribute name="xml:id">
	<xsl:text>fig00</xsl:text>
      </xsl:attribute>
      <xsl:element name="image">
	<xsl:element name="source">
	  <xsl:variable name="fn">
	    <xsl:choose>
	      <xsl:when test="reference">
		<xsl:value-of select="reference/image/@uri"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="image/@uri"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:variable>
	  <xsl:attribute name="format">
	    <xsl:call-template name="guess-img-format">
	      <xsl:with-param name="filename" select="$fn"/>
	    </xsl:call-template>
	  </xsl:attribute>
	  <xsl:attribute name="file">
	    <xsl:value-of select="$fn"/>
	  </xsl:attribute>
	</xsl:element>
      </xsl:element>
      <xsl:apply-templates select="caption"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="caption">
    <xsl:element name="caption">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="table|thead|tbody">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tgroup">
    <xsl:element name="tabular">
      <xsl:attribute name="colspec">
	<xsl:call-template name="repeat-string">
	  <xsl:with-param name="str">l</xsl:with-param>
	  <xsl:with-param name="rep" select="@cols"/>
	</xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates select="thead|tbody"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="row">
    <xsl:element name="tr">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="entry[ancestor::thead]">
    <xsl:element name="th">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="entry[ancestor::tbody]">
    <xsl:element name="td">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="citation_reference">
    <xsl:element name="cite">
      <xsl:attribute name="bibref">
	<xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="citation">
    <xsl:element name="bibitem">
      <xsl:attribute name="xml:id">
	<xsl:value-of select="label"/>
      </xsl:attribute>
      <xsl:apply-templates select="paragraph" mode="open"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>

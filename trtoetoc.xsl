<?xml version="1.0" encoding="utf-8"?>

<!--

trtoetoc.xsl - translates Techrepv2 to EPUB ToC page.
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
    <h2 xmlns="http://www.w3.org/1999/xhtml">Table of Contents</h2>
    <xsl:apply-templates select="tr:body"/>
  </xsl:template>

  <xsl:template match="tr:body">
    <xsl:apply-templates select="tr:h1|tr:appendix|tr:biblist"/>
  </xsl:template>

  <xsl:template match="tr:title">
    <h1 xmlns="http://www.w3.org/1999/xhtml"><xsl:apply-templates/></h1>
  </xsl:template>

  <xsl:template match="tr:h1">
    <p xmlns="http://www.w3.org/1999/xhtml" class="toc1">
      <a>
	<xsl:attribute name="href">
	  <xsl:text>etr.html#</xsl:text>
	  <xsl:apply-templates select="." mode="id"/>
	</xsl:attribute>
	<xsl:apply-templates select="." mode="number"/>
	<xsl:text>&#xA0;&#xA0;</xsl:text>
	<xsl:apply-templates/>
      </a>
      <xsl:apply-templates
	  select="following-sibling::tr:h2
		  [preceding-sibling::tr:h1[1] = current()]"/>
    </p>
  </xsl:template>

  <xsl:template match="tr:appendix">
    <p xmlns="http://www.w3.org/1999/xhtml" class="toc1">
      <a>
	<xsl:attribute name="href">
	  <xsl:text>etr.html#</xsl:text>
	  <xsl:apply-templates select="." mode="id"/>
	</xsl:attribute>
	<xsl:call-template name="select-local">
	  <xsl:with-param name="cs">Dodatek</xsl:with-param>
	  <xsl:with-param name="en">Appendix</xsl:with-param>
	</xsl:call-template>
	<xsl:text>&#xA0;</xsl:text>
	<xsl:apply-templates select="." mode="number"/>
	<xsl:text>&#xA0;&#xA0;</xsl:text>
	<xsl:apply-templates/>
      </a>
      <xsl:apply-templates
	  select="following-sibling::tr:h2
		  [preceding-sibling::tr:appendix[1] = current()]"/>
    </p>
  </xsl:template>

  <xsl:template match="tr:h2">
    <p xmlns="http://www.w3.org/1999/xhtml" class="toc2">
      <a>
	<xsl:attribute name="href">
	  <xsl:text>etr.html#</xsl:text>
	  <xsl:apply-templates select="." mode="id"/>
	</xsl:attribute>
	<xsl:apply-templates select="." mode="number"/>
	<xsl:text>&#xA0;&#xA0;</xsl:text>
	<xsl:apply-templates/>
      </a>
      <xsl:apply-templates
	  select="following-sibling::tr:h3
		  [preceding-sibling::tr:h3[1] = current()]"/>
    </p>
  </xsl:template>

  <xsl:template match="tr:h3">
    <p xmlns="http://www.w3.org/1999/xhtml" class="toc3">
      <a>
	<xsl:attribute name="href">
	  <xsl:text>etr.html#</xsl:text>
	  <xsl:apply-templates select="." mode="id"/>
	</xsl:attribute>
	<xsl:apply-templates select="." mode="number"/>
	<xsl:text>&#xA0;&#xA0;</xsl:text>
	<xsl:apply-templates/>
      </a>
    </p>
  </xsl:template>

  <xsl:template match="tr:biblist">
    <p xmlns="http://www.w3.org/1999/xhtml" class="toc1">
      <a>
	<xsl:attribute name="href">
	  <xsl:text>etr.html#</xsl:text>
	  <xsl:apply-templates select="." mode="id"/>
	</xsl:attribute>
	<xsl:call-template name="select-local">
	  <xsl:with-param name="cs">Literatura</xsl:with-param>
	  <xsl:with-param name="en">References</xsl:with-param>
	</xsl:call-template>
      </a>
    </p>
  </xsl:template>

  <xsl:template match="tr:strong|tr:sup|tr:sub|tr:blockquote">
    <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates/>
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

</xsl:stylesheet>

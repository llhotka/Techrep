<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xh="http://www.w3.org/1999/xhtml"
		xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="wwwpath">https://www.cesnet.cz/doc/tr/</xsl:param>

  <!-- Root element -->

  <xsl:template match="/xh:html">
    <xsl:comment>#include virtual="i-start1-u8.html"</xsl:comment>
    <xsl:copy-of select="xh:head/xh:title"/>
    <xsl:comment>#include virtual="i-start2-u8.html"</xsl:comment>
    <xsl:apply-templates select="xh:body"/>
    <xsl:comment>#include virtual="i-stop-u8.html"</xsl:comment>
  </xsl:template>

  <xsl:template match="xh:body">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="xh:h3/xh:span[@class='target']">
    <xsl:element name="a">
      <xsl:attribute name="href">
	<xsl:value-of select="concat($wwwpath,.)"/>
      </xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>

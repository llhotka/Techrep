<?xml version="1.0" encoding="utf-8"?>

<!--
trtorss.xsl: translates techrep XML v2 to RSS item
Copyright © 2009 CESNET
Author: Ladislav Lhotka
-->


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:tr="http://cesnet.cz/ns/techrep/base/2.0"
                version="1.0">

  <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>

  <xsl:param
      name="basedir">http://www.cesnet.cz/doc/techzpravy/2009/</xsl:param>
  <xsl:param name="tr-name">REPORT</xsl:param>

  <xsl:template name="cit-name">
    <xsl:param name="aname"/>
    <xsl:choose>
      <xsl:when test="contains($aname, ' ')">
	<xsl:value-of select="concat(substring($aname,1,1), '. ')"/>
	<xsl:call-template name="cit-name">
	  <xsl:with-param name="aname"
			  select="substring-after($aname, ' ')"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$aname"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Root element -->

  <xsl:template match="tr:report">
    <xsl:element name="item">
      <xsl:element name="title">
	<xsl:value-of select="concat(tr:title, ' (', @number, ')')"/>
      </xsl:element>
      <xsl:element name="link">
	<xsl:value-of select="concat($basedir, $tr-name)"/>
      </xsl:element>
      <xsl:element name="description">
	<xsl:text>AUTHORS: </xsl:text>
	<xsl:for-each select="tr:author">
	  <xsl:call-template name="cit-name">
	    <xsl:with-param name="aname"
			    select="normalize-space(tr:name)"/>
	  </xsl:call-template>
	  <xsl:choose>
	    <xsl:when test="position() = last()">
	      <xsl:text>. </xsl:text>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:text>, </xsl:text>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:for-each>
	<xsl:apply-templates select="tr:abstract"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>

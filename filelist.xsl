<?xml version="1.0" encoding="utf-8"?>

<!--

filelist.xsl - generates list of files belonging to the tarball.
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

  <xsl:output method="text"/>

  <xsl:param name="tr-name"/>

  <xsl:template match="tr:report">
    <xsl:value-of select="concat($tr-name, '.pdf ')"/>
    <xsl:value-of select="concat($tr-name, '.epub ')"/>
    <xsl:value-of select="concat($tr-name, '.rss ')"/>
    <xsl:text>index.html </xsl:text>
    <xsl:apply-templates
	select="descendant::tr:image/tr:source[@format!='PDF']"/>
  </xsl:template>

  <xsl:template match="tr:source">
    <xsl:value-of select="concat(@file, ' ')"/>
  </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="utf-8"?>

<!--

trtoopf.xsl - generates NCX ToC from Techrep v2 reports.
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

  <xsl:output method="xml" omit-xml-declaration="no" indent="yes"/>

  <!-- Root element -->

  <xsl:template match="tr:report">
    <ncx version="2005-1" xmlns="http://www.daisy.org/z3986/2005/ncx/">
      <head>
	<meta name="dtb:uid" content="{concat('CESNET-TR-', @number)}"/>
	<meta name="dtb:depth" content="1"/>
	<meta name="dtb:totalPageCount" content="0"/>
	<meta name="dtb:maxPageNumber" content="0"/>
      </head>
      <docTitle>
	<text>
	  <xsl:value-of select="tr:title"/>
	</text>
      </docTitle>
      <navMap>
	<navPoint id="navPoint-1" playOrder="1">
	  <navLabel>
	    <text>
	      <xsl:value-of select="tr:title"/>
	    </text>
	  </navLabel>
	  <content src="etr.html"/>
	</navPoint>
      </navMap>
    </ncx>
  </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

<xsl:template name="cesbody">
<div id="header">
    <div id="homelink"><a href="/">CESNET<span>&#xA0;</span></a></div>

<div id="search">

 <form method="get" action="http://www.google.com/search"><p>hledat:
 <input type="text" name="q" alt="hledaný text" maxlength="255" />
 <input type="hidden" name="sitesearch" value="www.cesnet.cz" />
 <input type="hidden" name="ie" value="UTF-8" />
 <input type="hidden" name="hl" value="cs" />
 </p></form>
</div>
</div>
</xsl:template>
</xsl:stylesheet>

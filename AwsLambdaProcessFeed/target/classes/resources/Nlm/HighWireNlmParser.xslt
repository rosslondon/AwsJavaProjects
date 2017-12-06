<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="nlmParser.xslt"/>
<xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8"/>
<xsl:strip-space elements="*"/>
  <xsl:template name="nlm_CoverDate">
    <xsl:element name="CoverDate">
      <xsl:element name="Year">
        <xsl:value-of select="front/article-meta/pub-date[@pub-type='publication-year']/year"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template match="/">
    <xsl:call-template name="nlm_Parser"/>
  </xsl:template>
</xsl:stylesheet>
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../Nlm/nlmParser.xslt"/>
  <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  <xsl:template name="Item_Identity">
    <xsl:element name="Identity">
      <xsl:value-of select="front/article-meta/article-id[@pub-id-type='doi']"/>
    </xsl:element>
  </xsl:template>
  <xsl:template name="nlm_Citations"/>
  <xsl:template match="article">
    <xsl:call-template name="nlm_Parser"/>
  </xsl:template>
</xsl:stylesheet>
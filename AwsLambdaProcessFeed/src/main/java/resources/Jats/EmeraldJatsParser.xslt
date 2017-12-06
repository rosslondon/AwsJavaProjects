<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../Nlm/nlmParser.xslt"/>
  <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  <xsl:template name="nlm_CoverDate">
    <xsl:element name="CoverDate">
      <xsl:element name="Year">
        <xsl:value-of select="front/article-meta/pub-date/year"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template name="Item_Identity">
    <xsl:element name="Identity">
      <xsl:value-of select="front/article-meta/article-id[@pub-id-type='doi']"/>
    </xsl:element>
  </xsl:template>
  <xsl:template name="Item_Abstract">
    <xsl:element name="Abstract">
      <xsl:for-each select="front/article-meta/abstract/sec">
        <xsl:value-of select="title"/>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="p"/>
        <xsl:text>  </xsl:text>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  <!-- <xsl:template name="nlm_Citations"/>   citations currently ENABLED (but changes every 2 hours...) -->
  <xsl:template match="article">
    <xsl:call-template name="nlm_Parser"/>
  </xsl:template>
</xsl:stylesheet>
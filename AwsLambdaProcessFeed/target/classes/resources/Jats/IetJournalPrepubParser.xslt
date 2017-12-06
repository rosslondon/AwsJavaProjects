<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../Nlm/formattings.xslt"/>
  <xsl:import href="../Nlm/nlmPublication.xslt"/>
  <xsl:import href="../Nlm/nlmItem.xslt"/>
  <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  <xsl:template name="Item_Identity">
    <xsl:element name="Identity">
      <xsl:choose>
        <xsl:when test="front/article-meta/article-id[@pub-id-type='manuscript'] != ''">
          <xsl:value-of select="front/article-meta/article-id[@pub-id-type='manuscript']"/>
        </xsl:when>
        <xsl:when test="front/article-meta/article-id[@pub-id-type='publisher-id'] != ''">
          <xsl:value-of select="front/article-meta/article-id[@pub-id-type='publisher-id']"/>
        </xsl:when>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  <xsl:template match="article">
    <xsl:element name="CaptureData">
      <xsl:call-template name="nlm_Publication"/>
      <xsl:call-template name="nlm_Item"/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
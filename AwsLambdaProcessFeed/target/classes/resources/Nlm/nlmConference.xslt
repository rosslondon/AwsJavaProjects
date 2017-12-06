<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ms="urn:schemas-microsoft-com:xslt">
  <xsl:template name="nlm_Conference">
    <xsl:element name="Conference">
      <xsl:element name="Title">
        <xsl:value-of select="front/article-meta/conference[@content-type='volume']/conf-name" />
      </xsl:element>
      <xsl:element name="Location">
        <xsl:element name="UnparsedText">
          <xsl:value-of select="front/article-meta/conference[@content-type='volume']/conf-loc" />
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>

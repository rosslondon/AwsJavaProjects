<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tranobj="urn:transform-ext">
  <xsl:template name="nlm_Book">
    <xsl:element name="Publication">
      <xsl:element name="Title">
        <xsl:apply-templates select="//book-meta/book-title-group/book-title" />
      </xsl:element>
      <xsl:element name="Subtitle">
        <xsl:apply-templates select="//book-meta/book-title-group/subtitle" />
      </xsl:element>
      <xsl:element name="Doi">
        <xsl:value-of select="//book-meta/book-id[@pub-id-type='doi']" />
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>

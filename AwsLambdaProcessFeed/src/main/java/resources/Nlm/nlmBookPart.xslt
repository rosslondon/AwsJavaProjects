<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tranobj="urn:transform-ext">
  <xsl:include href="nlmBookAffiliateList.xslt"/>
  <xsl:template name="nlm_BookPart">
    <xsl:element name="Item">
      <xsl:element name="Identity">
        <xsl:value-of select="//book-part-meta/book-part-id" />
      </xsl:element>
      <xsl:element name="Title">
        <xsl:apply-templates select="//book-part-meta/title-group/title" />
      </xsl:element>
      <xsl:element name="Abstract">
        <xsl:apply-templates  select="//book-part-meta/abstract"/>
      </xsl:element>
      <xsl:call-template name="nlm_AuthorsAndAffiliations"/>
      <xsl:element name="Doi">
        <xsl:value-of select="//book-part-meta/book-part-id[@pub-id-type='doi']" />
      </xsl:element>
      <xsl:element name="Pagination">
        <xsl:element name="Page">
          <xsl:value-of  select="//book-part-meta/fpage"/>
        </xsl:element>
        <xsl:element name="ToPage">
          <xsl:value-of  select="//book-part-meta/lpage"/>
        </xsl:element>
        <xsl:element name="PageCount">
          <xsl:value-of  select="//book-part-meta/counts/page-count/@count"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="Copyright">
        <xsl:value-of select="concat('Copyright © ', //book-part-meta/permissions/copyright-year, ' ', //book-part-meta/permissions/copyright-holder)"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>

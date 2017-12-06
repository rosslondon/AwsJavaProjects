<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ms="urn:schemas-microsoft-com:xslt">
  <xsl:include href="nlmItemAffiliateList.xslt"/>
  <xsl:template name="Item_Identity">
    <xsl:element name="Identity">
      <xsl:value-of select="front/article-meta/article-id[@pub-id-type='publisher-id']"/>
    </xsl:element>
  </xsl:template>
  <xsl:template name="Item_Abstract">
    <xsl:element name="Abstract">
      <xsl:apply-templates  select="front/article-meta/abstract[not(@xml:lang)]"/>
    </xsl:element>
  </xsl:template>
  <xsl:template name="nlm_Item">
    <xsl:element name="Item">
      <xsl:call-template name="Item_Identity"/>
      <xsl:element name="Title">
        <xsl:apply-templates  select="front/article-meta/title-group/article-title" />
      </xsl:element>
      <xsl:call-template name="Item_Abstract"/>
      <xsl:call-template name="nlm_AuthorsAndAffiliations"/>
      <xsl:element name="Doi">
        <xsl:value-of select="front/article-meta/article-id[@pub-id-type='doi']"/>
      </xsl:element>
      <xsl:element name="Pagination">
        <xsl:element name="Page">
          <xsl:value-of  select="front/article-meta/fpage"/>
        </xsl:element>
        <xsl:element name="ToPage">
          <xsl:value-of  select="front/article-meta/lpage"/>
        </xsl:element>
        <xsl:element name="PageCount">
          <xsl:value-of  select="//counts/page-count/@count"/>
        </xsl:element>
      </xsl:element>
      <xsl:choose>
        <xsl:when test="count(//ref) &gt; 0">
          <xsl:element name="CitationCount">
            <xsl:value-of select="count(//ref)"/>
          </xsl:element>
        </xsl:when>
        <xsl:when test="//counts/ref-count/@count != ''">
          <xsl:element name="CitationCount">
            <xsl:value-of select="//counts/ref-count/@count"/>
          </xsl:element>
        </xsl:when>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
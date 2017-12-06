<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:ms="urn:schemas-microsoft-com:xslt"
                xmlns:tranobj="urn:transform-ext">
<xsl:import href="nlmCitations.xslt"/>
<xsl:include href="formattings.xslt"/>
<xsl:include href="MathML.xsl"/>
<xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8"/>
<xsl:strip-space elements="*"/>
  <xsl:template name="nlm_CitationAffiliateList">
    <xsl:param name="persontype"/>
    <xsl:for-each select="..//person-group[@person-group-type=$persontype]/name">
      <xsl:choose>
        <xsl:when test="count(given-names) = 0 and count(surname) &gt; 0">
          <xsl:element name="Affiliate">
            <xsl:element name="Organisation">
              <xsl:element name ="UnparsedText">
                <xsl:value-of select="surname"/>
              </xsl:element>
              <xsl:element name ="Name">
                <xsl:value-of select="surname"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:element name="Affiliate">
            <xsl:element name ="Person">
              <xsl:element name ="Surname">
                <xsl:value-of select="surname"/>
              </xsl:element>
              <xsl:variable name="fn">
                <xsl:apply-templates select="given-names"/>
              </xsl:variable>
              <xsl:copy-of select="tranobj:SplitForenames($fn)" />
              <xsl:element name ="Prefix">
                <xsl:value-of select="prefix"/>
              </xsl:element>
              <xsl:element name ="Suffix">
                <xsl:value-of select="suffix"/>
              </xsl:element>
              <xsl:element name ="Email">
                <xsl:value-of select="email"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:for-each select="collab">
      <xsl:element name="Affiliate">
        <xsl:element name ="Organisation">
          <xsl:copy-of select="tranobj:ParseOrganisation(.)" />
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
    <xsl:if test="etal">
      <xsl:element name ="Etal"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="/">
    <xsl:element name="CaptureData">
      <xsl:call-template name="nlm_Citations"/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
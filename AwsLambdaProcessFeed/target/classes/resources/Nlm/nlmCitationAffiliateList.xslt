<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ms="urn:schemas-microsoft-com:xslt"
                xmlns:tranobj="urn:transform-ext">
  <xsl:template name="nlm_CitationAffiliateList">
    <xsl:param name="persontype"/>
      <xsl:for-each select="..//person-group[@person-group-type=$persontype]/node()[local-name () = 'string-name' or local-name () = 'name']|node()[local-name () = 'string-name' or local-name () = 'name']">
        <xsl:element name="affiliate">
          <xsl:element name ="person">
            <xsl:choose>
              <xsl:when test="count(surname) &gt; 0">
                <xsl:element name ="surname">
                  <xsl:value-of select="surname"/>
                </xsl:element>
                <xsl:variable name="fn">
                  <xsl:apply-templates select="given-names"/>
                </xsl:variable>
                <!--<xsl:copy-of select="tranobj:SplitForenames($fn)" />-->
                <xsl:element name ="prefix">
                  <xsl:value-of select="prefix"/>
                </xsl:element>
                <xsl:element name ="suffix">
                  <xsl:value-of select="suffix"/>
                </xsl:element>
                <xsl:element name ="email">
                  <xsl:value-of select="email"/>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <!--<xsl:copy-of select="tranobj:ParsePerson(.)" />-->
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
      <xsl:for-each select="collab">
        <xsl:element name="affiliate">
          <xsl:element name ="organisation">
            <!--<xsl:copy-of select="tranobj:ParseOrganisation(.)" />-->
          </xsl:element>
          </xsl:element>
      </xsl:for-each>
      <xsl:if test="etal">
        <xsl:element name ="etal"/>
      </xsl:if>
    </xsl:template>
</xsl:stylesheet>

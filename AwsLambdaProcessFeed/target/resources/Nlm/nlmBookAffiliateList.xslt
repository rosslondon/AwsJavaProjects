<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ms="urn:schemas-microsoft-com:xslt"
                xmlns:tranobj="urn:transform-ext">
  <xsl:template name="nlm_AuthorsAndAffiliations">
    <xsl:element name="Authors">
      <xsl:for-each select="//book-part-meta/contrib-group/contrib">
        <xsl:variable name="x">
          <xsl:choose>
            <xsl:when test="contains(xref[@ref-type='aff']/@rid,' ')">
              <xsl:value-of select ="substring-before(xref[@ref-type='aff']/@rid,' ')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select ="xref[@ref-type='aff']/@rid"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:element name="Affiliate">
          <xsl:for-each select="node()[local-name () = 'string-name' or local-name () = 'name']">
            <xsl:element name="Person">
              <xsl:choose>
                <xsl:when test="count(surname) &gt; 0">
                  <xsl:element name="Surname">
                    <xsl:value-of select="surname"/>
                  </xsl:element>
                  <xsl:variable name="fn">
                    <xsl:apply-templates select="given-names"/>
                  </xsl:variable>
                  <xsl:copy-of select="tranobj:SplitForenames($fn)" />
                  <xsl:element name="Email">
                    <xsl:value-of select="../email"/>
                  </xsl:element>
                  <xsl:element name="Orcid">
                    <xsl:value-of select="../contrib-id[@contrib-id-type='orcid']"/>
                  </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:copy-of select="tranobj:ParsePerson(.)" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
          </xsl:for-each>
          <xsl:variable name="orgns">
            <xsl:for-each select="//aff">
              <xsl:if test="string($x) = string(@id)">
                <xsl:element name ="Organisation">
                  <xsl:variable name="ut">
                    <xsl:for-each select="./node()">
                      <xsl:apply-templates select="."/>
                      <xsl:text> </xsl:text>
                    </xsl:for-each>
                  </xsl:variable>
                  <xsl:element name ="UnparsedText">
                    <xsl:value-of select="normalize-space($ut)"/>
                  </xsl:element>
                  <xsl:element name ="Name">
                    <xsl:apply-templates select="institution/node()[not(self::named-content)]"/>
                  </xsl:element>
                  <xsl:element name ="Department">
                    <xsl:apply-templates select="institution/named-content[@content-type='dept']"/>
                  </xsl:element>
                  <xsl:element name ="Address">
                    <xsl:for-each select="addr-line">
                      <xsl:element name ="AddressLine">
                        <xsl:value-of select="."/>
                      </xsl:element>
                    </xsl:for-each>
                    <xsl:element name ="City">
                      <xsl:apply-templates select=".//named-content[@content-type='city']"/>
                    </xsl:element>
                    <xsl:element name ="State">
                      <xsl:apply-templates select=".//named-content[@content-type='state']"/>
                    </xsl:element>
                    <xsl:element name ="Country">
                      <xsl:value-of select="country"/>
                    </xsl:element>
                    <xsl:element name ="Postcode">
                      <xsl:apply-templates select=".//named-content[@content-type='postalcode']"/>
                    </xsl:element>
                  </xsl:element>
                </xsl:element>
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>
          <!--<xsl:copy-of select="ms:node-set($orgns)/Organisation[1]"/>-->
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
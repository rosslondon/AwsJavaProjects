<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tranobj="urn:transform-ext">
  <xsl:import href="nlmCitationAffiliateList.xslt"/>
  <xsl:template name="nlm_CitationOtherPublications">
    <!-- Book details -->
    <xsl:if test="@publication-type = 'book' or @publication-type = 'book-chapter' or count(chapter-title) &gt; 0">
      <xsl:element name ="book">
          <xsl:element name ="chapter">
            <xsl:apply-templates select="chapter-title"/>
          </xsl:element>
      </xsl:element>
    </xsl:if>
    <!-- Conference details -->
    <xsl:if test="@publication-type = 'conference' or @publication-type = 'confproc' or count(conf-name) &gt; 0 or count(conf-loc) &gt; 0">
      <xsl:element name ="conference">
        <xsl:element name ="title">
          <xsl:apply-templates select="conf-name"/>
        </xsl:element>
        <xsl:element name ="location">
          <!--<xsl:copy-of select="tranobj:ParsePlace(conf-loc)" />-->
        </xsl:element>
        <xsl:element name ="date">
          <!--<xsl:copy-of select="tranobj:ParseInexactDateRange(conf-date)" />-->
        </xsl:element>
        <xsl:element name ="sponsor">
          <!--<xsl:copy-of select="tranobj:ParseOrganisation(conf-sponsor)" />-->
        </xsl:element>
      </xsl:element>
    </xsl:if>
    <!-- Dissertation details -->
    <xsl:if test="@publication-type = 'thesis' or count(degree) &gt; 0">
      <xsl:element name ="dissertation">
          <xsl:element name ="degree">
            <xsl:apply-templates select="degree"/>
          </xsl:element>
          <xsl:element name ="university">
            <xsl:element name ="name">
              <xsl:apply-templates select="publisher-name"/>
            </xsl:element>
          </xsl:element>
      </xsl:element>
    </xsl:if>
    <!-- Patent details -->
    <xsl:if test="@publication-type = 'patent' or count(patent) &gt; 0">
      <xsl:element name ="patent">
        <xsl:element name ="identity">
          <xsl:value-of select="patent"/>
        </xsl:element>
        <xsl:element name="assignees">
          <xsl:for-each select="person-group">
            <xsl:if test="@person-group-type = 'assignee'">
              <xsl:call-template name="nlm_CitationAffiliateList">
                <xsl:with-param name="persontype" select="@person-group-type" />
              </xsl:call-template>
            </xsl:if>
          </xsl:for-each>
        </xsl:element>
        <xsl:element name ="country">
          <xsl:value-of select="patent/@country"/>
        </xsl:element>
      </xsl:element>
    </xsl:if>
    <!-- Report details -->
    <xsl:if test="@publication-type = 'gov' or count(gov) &gt; 0">
      <xsl:element name ="report">
        <xsl:element name ="identity">
          <xsl:value-of select="issue"/>
        </xsl:element>
      </xsl:element>
    </xsl:if>
    <!-- Standard details -->
    <xsl:if test="@publication-type = 'std' or count(std) &gt; 0">
      <xsl:element name ="standard">
        <xsl:element name ="identity">
          <xsl:value-of select="std"/>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
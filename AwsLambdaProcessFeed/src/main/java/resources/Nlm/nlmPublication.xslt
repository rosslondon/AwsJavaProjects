<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tranobj="urn:transform-ext">
  <xsl:include href="nlmConference.xslt" />
  <xsl:template name="nlm_CoverDate">
    <xsl:element name="CoverDate">
      <xsl:element name="UnparsedText">
        <xsl:apply-templates select="front/article-meta/pub-date[@pub-type='ppub']/string-date"/>
      </xsl:element>
      <xsl:element name="Day">
        <xsl:value-of select="front/article-meta/pub-date[@pub-type='ppub']/day"/>
      </xsl:element>
      <xsl:element name="Month">
        <xsl:value-of select="front/article-meta/pub-date[@pub-type='ppub']/month"/>
      </xsl:element>
      <xsl:element name="Year">
        <xsl:value-of select="front/article-meta/pub-date[@pub-type='ppub']/year"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template name="nlm_Publication">
    <xsl:element name="Publication">
      <xsl:element name="Identity">
        <xsl:value-of select="front/journal-meta/journal-id[@journal-id-type='publisher-id']"/>
      </xsl:element>
      <xsl:element name="Title">
        <xsl:apply-templates select="//journal-title" />
      </xsl:element>
      <xsl:element name="AbbreviatedTitle">
        <xsl:apply-templates select="//abbrev-journal-title" />
      </xsl:element>
      <xsl:call-template name="nlm_CoverDate"/>
      <xsl:element name="Issue">
        <xsl:element name="Volume">
          <xsl:value-of select="front/article-meta/volume"/>
        </xsl:element>
        <xsl:element name="Number">
          <xsl:value-of select="front/article-meta/issue"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="Isbn">
        <xsl:value-of select="front/journal-meta/isbn"/>
      </xsl:element>
      <xsl:element name="Issn">
        <xsl:choose>
          <xsl:when test="count(front/journal-meta/issn[@pub-type='ppub']) &gt; 0">
            <xsl:value-of select="front/journal-meta/issn[@pub-type='ppub']"/>
          </xsl:when>
          <xsl:when test="count(front/journal-meta/issn[@pub-type='epub']) &gt; 0">
            <xsl:value-of select="front/journal-meta/issn[@pub-type='epub']"/>
          </xsl:when>
          <xsl:when test="count(front/journal-meta/issn) &gt; 0">
            <xsl:value-of select="front/journal-meta/issn"/>
          </xsl:when>
        </xsl:choose>
      </xsl:element>
      <xsl:element name="Coden">
        <xsl:choose>
          <xsl:when test="count(front/journal-meta/journal-id[@journal-id-type='coden']) &gt; 0">
            <xsl:value-of select="tranobj:ValidateCoden(front/journal-meta/journal-id[@journal-id-type='coden'])"/>
          </xsl:when>
          <xsl:when test="count(front/article-meta/article-id[@pub-id-type='coden']) &gt; 0">
            <xsl:value-of select="tranobj:ValidateCoden(front/article-meta/article-id[@pub-id-type='coden'])"/>
          </xsl:when>
        </xsl:choose>
      </xsl:element>
      <xsl:element name="Publisher">
        <xsl:element name="Name">
          <xsl:apply-templates select="front/journal-meta/publisher/publisher-name[1]"/>
        </xsl:element>
        <xsl:if test="count(front/journal-meta/publisher/publisher-loc) &gt; 0">
          <xsl:element name ="Address">
            <!--<xsl:copy-of select="tranobj:ParsePlace(front/journal-meta/publisher/publisher-loc)" />-->
          </xsl:element>
        </xsl:if>
      </xsl:element>
      <xsl:call-template name="nlm_Conference"/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:c="http://data.iet.org/schemas/core"
    xmlns:ag="http://data.iet.org/schemas/agency"
    xmlns:an="http://data.iet.org/schemas/annotation"
    xmlns:co="http://data.iet.org/schemas/concept"
    xmlns:ev="http://data.iet.org/schemas/inspec/event"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0"
>
  <xsl:include href="nlmConference.xslt" />
  <xsl:template name="nlm_CoverDate">
    <xsl:element name="coverDate">
      <!--<xsl:element name="UnparsedText">
        <xsl:apply-templates select="front/article-meta/pub-date[@pub-type='ppub']/string-date"/>
      </xsl:element>-->
	  <xsl:element name="From">
        <xsl:attribute name="day">
          <xsl:value-of select="front/article-meta/pub-date[@pub-type='ppub']/day"/>
        </xsl:attribute>
        <xsl:attribute name="month">
          <xsl:value-of select="front/article-meta/pub-date[@pub-type='ppub']/month"/>
        </xsl:attribute>
        <xsl:attribute name="year">
          <xsl:value-of select="front/article-meta/pub-date[@pub-type='ppub']/year"/>
        </xsl:attribute>
	  </xsl:element>
    </xsl:element>
  </xsl:template>
  <xsl:template name="nlm_Publication">
    <xsl:element name="periodical">
      <!--<xsl:element name="Identity">
        <xsl:value-of select="front/journal-meta/journal-id[@journal-id-type='publisher-id']"/>
      </xsl:element>-->
      <xsl:element name="title">
        <xsl:apply-templates select="//journal-title" />
      </xsl:element>
      <xsl:element name="abbreviatedTitle">
        <xsl:apply-templates select="//abbrev-journal-title" />
      </xsl:element>
      <xsl:element name="coden">
        <xsl:choose>
          <xsl:when test="count(front/journal-meta/journal-id[@journal-id-type='coden']) &gt; 0">
            <xsl:value-of select="front/journal-meta/journal-id[@journal-id-type='coden']"/>
          </xsl:when>
          <xsl:when test="count(front/article-meta/article-id[@pub-id-type='coden']) &gt; 0">
            <xsl:value-of select="front/article-meta/article-id[@pub-id-type='coden']"/>
          </xsl:when>
        </xsl:choose>
      </xsl:element>
      <xsl:if test="count(front/journal-meta/issn[@pub-type='ppub']) &gt; 0">
          <xsl:element name="issn">
            <xsl:value-of select="front/journal-meta/issn[@pub-type='ppub']"/>
          </xsl:element>
        </xsl:if>
      <xsl:if test="count(front/journal-meta/issn[@pub-type='epub']) &gt; 0">
        <xsl:element name="eissn">
          <xsl:value-of select="front/journal-meta/issn[@pub-type='epub']"/>
        </xsl:element>
      </xsl:if>
      <xsl:if test="count(front/journal-meta/issn) &gt; 0">
        <xsl:element name="issn">
          <xsl:value-of select="front/journal-meta/issn"/>
        </xsl:element>
      </xsl:if>
      <xsl:element name="issue">
        <xsl:attribute name="volume">
          <xsl:value-of select="front/article-meta/volume"/>
        </xsl:attribute>
        <xsl:attribute name="number">
          <xsl:value-of select="front/article-meta/issue"/>
        </xsl:attribute>
	    <xsl:element name="isbn">
          <xsl:value-of select="front/journal-meta/isbn"/>
        </xsl:element>
		<xsl:call-template name="nlm_CoverDate"/>
        <!--<xsl:element name="name">
          <xsl:apply-templates select="front/journal-meta/publisher/publisher-name[1]"/>
        </xsl:element>
        <xsl:if test="count(front/journal-meta/publisher/publisher-loc) &gt; 0">
          <xsl:element name ="address">
            <xsl:value-of select="front/journal-meta/publisher/publisher-loc" />
          </xsl:element>
        </xsl:if>
      </xsl:element>-->
        <!--<xsl:call-template name="nlm_Conference"/>-->

	  </xsl:element>
	</xsl:element>
  </xsl:template>
</xsl:stylesheet>
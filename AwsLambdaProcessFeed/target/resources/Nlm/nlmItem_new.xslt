<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	elementFormDefault="qualified"
    targetNamespace="http://data.iet.org/schemas/inspec/content"
	xmlns="http://data.iet.org/schemas/inspec/content"
    xmlns:c="http://data.iet.org/schemas/core"
    xmlns:ag="http://data.iet.org/schemas/agency"
    xmlns:an="http://data.iet.org/schemas/annotation"
    xmlns:co="http://data.iet.org/schemas/concept"
    xmlns:ev="http://data.iet.org/schemas/inspec/event"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0">
	<xsl:output indent="yes"/>
    <xsl:strip-space elements="*"/>

  <xsl:include href="nlmItemAffiliateList_new.xslt"/>
  <xsl:template name="Item_Abstract">
    <xsl:element name="abstract">
      <xsl:apply-templates select="front/article-meta/abstract[not(@xml:lang)]"/>
    </xsl:element>
  </xsl:template>
  <xsl:template name="nlm_Item">
    <xsl:element name="item">
      <!--<xsl:call-template name="Item_Identity"/>-->
      <xsl:element name="title">
        <xsl:apply-templates  select="front/article-meta/title-group/article-title" />
      </xsl:element>
      <xsl:call-template name="Item_Abstract"/>
      <xsl:variable name="from">
        <xsl:value-of select="front/article-meta/fpage"/>
      </xsl:variable>
	  <xsl:variable name="to">
        <xsl:value-of select="front/article-meta/lpage"/>
      </xsl:variable>
	  <xsl:if test="($from != '') or ($to != '')">
        <xsl:element name="pageRange">
		  <xsl:if test="$from != ''">
            <xsl:attribute name="from">
              <xsl:value-of  select="$from"/>
            </xsl:attribute>
		  </xsl:if>
		  <xsl:if test="$to != ''">
            <xsl:attribute name="to">
              <xsl:value-of  select="$to"/>
            </xsl:attribute>
          </xsl:if>
        </xsl:element>
      </xsl:if>
	  <xsl:choose>
        <xsl:when test="count(//ref) &gt; 0">
          <xsl:element name="referenceCount">
            <xsl:value-of select="count(//ref)"/>
          </xsl:element>
        </xsl:when>
        <xsl:when test="//counts/ref-count/@count != ''">
          <xsl:element name="referenceCount">
            <xsl:value-of select="//counts/ref-count/@count"/>
          </xsl:element>
        </xsl:when>
      </xsl:choose>
	  <xsl:element name="doi">
		<xsl:attribute name="identifier">
          <xsl:value-of select="front/article-meta/article-id[@pub-id-type='doi']"/>
		</xsl:attribute>
      </xsl:element>
	  <xsl:call-template name="nlm_AuthorsAndAffiliations"/>
	  
	  <xsl:element name="originatorTag">
        <xsl:value-of select="front/article-meta/article-id[@pub-id-type='publisher-id:aipid']"/>
      </xsl:element>
	  
	  <xsl:call-template name="nlm_Citations"/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
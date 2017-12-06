<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    elementFormDefault="qualified"
    targetNamespace="http://data.iet.org/schemas/inspec/content"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  
	xsi:schemaLocation="http://data.iet.org/schemas/inspec/content inspec-content.xsd"
    xmlns="http://data.iet.org/schemas/inspec/content"
    xmlns:c="http://data.iet.org/schemas/core"
    xmlns:ag="http://data.iet.org/schemas/agency"
    xmlns:an="http://data.iet.org/schemas/annotation"
    xmlns:co="http://data.iet.org/schemas/concept"
    xmlns:ev="http://data.iet.org/schemas/inspec/event"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0">
  <xsl:template name="nlm_AuthorsAndAffiliations">
    <xsl:for-each select="front/article-meta/contrib-group/contrib[@contrib-type='author']">
      <xsl:element name="author">
		<xsl:if test="email != ''">
		  <xsl:attribute name="email">
            <xsl:value-of select="email"/>
          </xsl:attribute>
		</xsl:if>
        <xsl:if test="contrib-id[@contrib-id-type='orcid'] != ''">
		  <xsl:attribute name="orcid">
            <xsl:value-of select="contrib-id[@contrib-id-type='orcid']"/>
          </xsl:attribute>
		</xsl:if>
		<xsl:call-template name="AuthorEmail">
			<xsl:with-param name="rid" select="xref[@ref-type='author-note']/@rid"/>
		</xsl:call-template>
		<xsl:for-each select="node()[local-name () = 'string-name' or local-name () = 'name']">
		  <xsl:choose>
            <xsl:when test="count(surname) &gt; 0">
			  <xsl:element name="firstName">
                <xsl:variable name="forename">
				  <xsl:value-of select="given-names"/>
				</xsl:variable>
				<xsl:attribute name="initial">
				  <xsl:value-of select="substring($forename,1,1)"/>
				</xsl:attribute>
				<xsl:attribute name="value">
					<xsl:value-of select="$forename"/>
				</xsl:attribute>
				
              </xsl:element>
			  <xsl:element name="familyName">
                <xsl:value-of select="surname"/>
              </xsl:element>
			  
              <!--<xsl:copy-of select="tranobj:SplitForenames($fn)" />-->
            </xsl:when>
            <xsl:otherwise>
              <!--<xsl:copy-of select="tranobj:ParsePerson(.)" />-->
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
		<xsl:call-template name="AuthorAffiliation">
			<xsl:with-param name="rid" select="xref[@ref-type='aff']/@rid"/>
		</xsl:call-template>
      </xsl:element>
	</xsl:for-each>
	
	<xsl:for-each select="front/article-meta/contrib-group/aff">
      <xsl:element name="affiliateOrganisation">
		<xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
		<xsl:variable name="ut">
          <xsl:for-each select="./node()">
            <xsl:apply-templates select="."/>
            <xsl:text> </xsl:text>
          </xsl:for-each>
        </xsl:variable>
        <xsl:element name ="unparsedText">
          <xsl:value-of select="normalize-space($ut)"/>
        </xsl:element>
		<xsl:element name ="fullName">
          <xsl:apply-templates select="institution/node()[not(self::named-content)]"/>
        </xsl:element>
        <xsl:element name ="department">
          <xsl:apply-templates select="institution/named-content[@content-type='dept']"/>
        </xsl:element>
        <xsl:for-each select="addr-line">
		  <xsl:variable name="i" select="position()" />
		  <xsl:variable name="addressLine" select="concat('addressLine', $i)" />	
		  <xsl:element name ="{$addressLine}">
            <xsl:value-of select="."/>
          </xsl:element>
        </xsl:for-each>
        <xsl:element name ="city">
          <xsl:apply-templates select=".//named-content[@content-type='city']"/>
        </xsl:element>
        <xsl:element name ="state">
          <xsl:apply-templates select=".//named-content[@content-type='state']"/>
        </xsl:element>
        <xsl:element name ="country">
          <xsl:value-of select="country"/>
        </xsl:element>
        <xsl:element name ="postcode">
          <xsl:apply-templates select=".//named-content[@content-type='postalcode']"/>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="AuthorAffiliation">
    <xsl:param name="rid"/>
	<xsl:choose>
	  <xsl:when test="contains($rid,' ')">
		<xsl:element name="affiliatedOrganisation">
		  <xsl:attribute name="id">	
			<xsl:value-of select ="substring-before($rid,' ')"/>
		  </xsl:attribute>
		</xsl:element>
		<xsl:variable name="rid">
		  <xsl:value-of select ="substring-after($rid,' ')"/>
		</xsl:variable>
		<xsl:call-template name="AuthorAffiliation">
		  <xsl:with-param name="rid" select="$rid"/>
		</xsl:call-template>
	  </xsl:when>
	  <xsl:otherwise>
		<xsl:element name="affiliatedOrganisation">
		  <xsl:attribute name="id">	
			<xsl:value-of select ="$rid"/>
		  </xsl:attribute>
		</xsl:element>
	  </xsl:otherwise>
	</xsl:choose>
  </xsl:template>
  <xsl:template name="AuthorEmail">
    <xsl:param name="rid"/>
	<xsl:for-each select="//author-notes/fn">
		<!--<xsl:attribute name="email">
			<xsl:value-of select ="$rid"/>
		  </xsl:attribute>-->
		<xsl:if test="@id=$rid">
		<xsl:attribute name="email">
		  <xsl:apply-templates select="p/ext-link[@ext-link-type='email']"/>
		</xsl:attribute>
	  </xsl:if>
	</xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
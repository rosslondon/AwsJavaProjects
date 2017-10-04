<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tranobj="urn:transform-ext">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
 
  <xsl:template name="ietTv_Publication">
    <xsl:element name="Publication">
      <xsl:element name="Title">
        <xsl:value-of select="//Events/Event/EventName"/>
      </xsl:element>
      <xsl:element name="CoverDate">
        <xsl:element name="Day">
          <xsl:call-template name="getday">
            <xsl:with-param name="text" select="Video/BasicInfo/VideoCreatedDate"/>
          </xsl:call-template>
        </xsl:element>
        <xsl:element name="Month">
          <xsl:call-template name="getmonth">
            <xsl:with-param name="text" select="Video/BasicInfo/VideoCreatedDate"/>
          </xsl:call-template>
        </xsl:element>
        <xsl:element name="Year">
          <xsl:call-template name="getyear">
            <xsl:with-param name="text" select="Video/BasicInfo/VideoCreatedDate"/>
          </xsl:call-template>
        </xsl:element>
      </xsl:element>
      <xsl:element name="Publisher">
        <xsl:element name="Name">
          IET
        </xsl:element>
        <xsl:element name="Address">
          <xsl:element name="City">
            Stevenage
          </xsl:element>
          <xsl:element name="Country">
            UK
          </xsl:element>
        </xsl:element>
      </xsl:element>
      <xsl:element name="Pagination">
        <xsl:element name ="Page">
          Video
        </xsl:element>
      </xsl:element>
      <xsl:element name="IssuedIn">
        UK
      </xsl:element>
      <xsl:element name="Medium">
        Video
      </xsl:element>

      
    </xsl:element>
  </xsl:template>

  <xsl:template name="ietTv_Item">
    <xsl:element name="Item">
      <xsl:element name="Identity">
        <xsl:value-of select="concat('iettv-inspec_', Video/@ID)"/>
      </xsl:element>
      <xsl:element name="Title">
        <xsl:value-of select="Video/BasicInfo/Title"/>
      </xsl:element>
      <xsl:element name="Abstract">
        <xsl:call-template name="strip-tags">
          <xsl:with-param name="text" select="Video/InspecAbstract"/>
        </xsl:call-template>
        <!--<xsl:value-of select="Video/BasicInfo/Abstract"/>-->
      </xsl:element>
      <xsl:call-template name="ietTv_AuthorsAndAffiliations"/>
      <xsl:element name="Doi">
        <xsl:value-of select="Video/PublishInfo/VideoPublish/DOI"/>
      </xsl:element>
 
      <!--<xsl:element name="Url">
        <xsl:value-of select="//VideoURL"/>
      </xsl:element>-->
      <xsl:element name="Language">
        <xsl:text>English</xsl:text>
      </xsl:element>

      
    </xsl:element>
  </xsl:template>

  <xsl:template name="ietTv_AuthorsAndAffiliations">
    <xsl:element name="Authors">
      <xsl:for-each select="Video/Speakers/Person">
        <xsl:element name="Affiliate">
          <xsl:element name="Person">
            <xsl:element name="Surname">
              <xsl:value-of select="Name/Surname"/>
            </xsl:element>
            <xsl:copy-of select="tranobj:SplitForenames(Name/Given-Name)" />
            <xsl:element name="Email">
              <xsl:value-of select="EmailID"/>
            </xsl:element>
          </xsl:element>
          <!--<xsl:if test="Video/Speakers/Person/Affiliations/Affiliation/Organization">-->
            <xsl:element name ="Organisation">
              <xsl:element name="Name">
                <xsl:value-of select="Affiliations/Affiliation/Organization/OrganizationName"/>
              </xsl:element>
              <xsl:element name="Department">
                <xsl:value-of select="Affiliations/Affiliation/Organization/Department/DepartmentName"/>
              </xsl:element>
              <xsl:element name="Address">
                <xsl:if test="Affiliations/Affiliation/Organization/Address/Addr-Line">
                  <xsl:element name="AddressLine">
                    <xsl:value-of select="Affiliations/Affiliation/Organization/Address/Addr-Line"/>
                  </xsl:element>
                </xsl:if>
                <xsl:element name="City">
                  <xsl:value-of select="Affiliations/Affiliation/Organization/Address/City"/>
                </xsl:element>
                <xsl:element name="Country">
                  <xsl:choose>
                    <xsl:when test="Affiliations/Affiliation/Organization/Address/Country !=null">
                      <xsl:value-of select="Affiliations/Affiliation/Organization/Address/Country"/>
                    </xsl:when>
                    <xsl:otherwise>
                      UK
                    </xsl:otherwise>
                  </xsl:choose>
                  
                </xsl:element>
                <xsl:element name="Postcode">
                  <xsl:value-of select="Affiliations/Affiliation/Organization/Address/Postcode"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          <!--</xsl:if>-->
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  

  <xsl:template match="/">
    <xsl:element name="CaptureData">
      <xsl:call-template name="ietTv_Publication"/>
      <xsl:call-template name="ietTv_Item"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="strip-tags">
    <xsl:param name="text"/>
    <xsl:choose>
      <xsl:when test="contains($text, '&lt;')">
        <xsl:value-of select="substring-before($text, '&lt;')"/>
        <xsl:call-template name="strip-tags">
          <xsl:with-param name="text" select="substring-after($text, '&gt;')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="getday">
    <xsl:param name="text"/>
    <xsl:value-of select="substring($text, 9, 2)"/>
  </xsl:template>

  <xsl:template name="getmonth">
    <xsl:param name="text"/>
    <xsl:value-of select="substring($text, 6, 2)"/>
  </xsl:template>

  <xsl:template name="getyear">
    <xsl:param name="text"/>
    <xsl:value-of select="substring-before($text, '-')"/>
  </xsl:template>

  <xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="$text = '' or $replace = ''or not($replace)" >
        <!-- Prevent this routine from hanging -->
        <xsl:value-of select="$text" />
      </xsl:when>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$by" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>


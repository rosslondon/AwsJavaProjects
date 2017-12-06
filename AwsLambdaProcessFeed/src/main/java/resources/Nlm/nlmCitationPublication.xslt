<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tranobj="urn:transform-ext">
  <xsl:import href="nlmCitationAffiliateList.xslt"/>
  <xsl:template name="nlm_CitationPublication">
    <xsl:element name="publication">
      <xsl:choose>
        <xsl:when test="count(source) &gt; 0">
          <xsl:element name="title">
            <xsl:apply-templates select="source"/>
          </xsl:element>
        </xsl:when>
        <xsl:when test="count(gov) &gt; 0">
          <xsl:element name="title">
            <xsl:apply-templates select="gov"/>
          </xsl:element>
        </xsl:when>
        <xsl:when test="count(gov) = 0 and count(source) = 0 and (@publication-type = 'gov' or @publication-type = 'report')">
          <xsl:element name="title">
            <xsl:apply-templates select="article-title"/>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:element name="title">
            <xsl:apply-templates select="patent"/>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:element name="translatedTitle">
        <xsl:apply-templates select="trans-source"/>
      </xsl:element>
      <xsl:element name ="coverDate">
        <xsl:element name ="day">
          <xsl:apply-templates select="day"/>
        </xsl:element>
        <xsl:if test="month">
          <xsl:element name ="month">
            <xsl:apply-templates select="month"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="season">
          <xsl:element name ="season">
            <xsl:apply-templates select="season"/>
          </xsl:element>
        </xsl:if>
        <xsl:element name ="year">
          <xsl:apply-templates select="year"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="issue">
        <xsl:element name ="special">
          <xsl:apply-templates select="supplement"/>
        </xsl:element>
        <xsl:element name="volume">
          <xsl:value-of select="volume"/>
        </xsl:element>
        <xsl:choose>
          <xsl:when test="count(series) = 0 and count(volume-series) &gt; 0">
            <xsl:element name ="series">
              <xsl:apply-templates select="volume-series"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="series">
              <xsl:value-of select="series"/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="@publication-type != 'gov' and @publication-type != 'report'">
          <xsl:element name="number">
            <xsl:value-of select="issue"/>
          </xsl:element>
        </xsl:if>
        <xsl:element name="edition">
          <xsl:value-of select="edition"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="isbn">
        <xsl:value-of select="isbn"/>
      </xsl:element>
      <xsl:element name="issn">
        <xsl:value-of select="issn"/>
      </xsl:element>
      <xsl:for-each select="pub-id">
        <xsl:if test="@pub-id-type = 'coden'">
          <xsl:element name ="coden">
            <xsl:apply-templates select="."/>
          </xsl:element>
        </xsl:if>
      </xsl:for-each>
      <xsl:if test="count(publisher-name) &gt; 0 or count(publisher-loc) &gt; 0">
        <xsl:element name="publisher">
          <xsl:element name ="name">
            <xsl:apply-templates select="publisher-name"/>
          </xsl:element>
          <xsl:if test="publisher-loc">
            <xsl:element name ="address">
              <!--<xsl:copy-of select="tranobj:ParsePlace(publisher-loc)" />-->
            </xsl:element>
          </xsl:if>
        </xsl:element>
      </xsl:if>
      <xsl:element name ="editors">
        <xsl:for-each select="person-group">
            <xsl:if test="@person-group-type = 'editor' or @person-group-type = 'guest-editor'">
              <xsl:call-template name="nlm_CitationAffiliateList">
                <xsl:with-param name="persontype" select="@person-group-type" />
              </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
      </xsl:element>
      <xsl:element name ="translators">
        <xsl:for-each select="person-group">
          <xsl:if test="@person-group-type = 'translator'">
            <xsl:call-template name="nlm_CitationAffiliateList">
              <xsl:with-param name="persontype" select="@person-group-type" />
            </xsl:call-template>
          </xsl:if>
        </xsl:for-each>
      </xsl:element>
      <xsl:element name ="translationEditors">
        <xsl:for-each select="person-group">
          <xsl:if test="@person-group-type = 'transed'">
            <xsl:call-template name="nlm_CitationAffiliateList">
              <xsl:with-param name="persontype" select="@person-group-type" />
            </xsl:call-template>
          </xsl:if>
        </xsl:for-each>
      </xsl:element>
      <xsl:element name ="compilers">
        <xsl:for-each select="person-group">
          <xsl:if test="@person-group-type = 'compiler'">
            <xsl:call-template name="nlm_CitationAffiliateList">
              <xsl:with-param name="persontype" select="@person-group-type" />
            </xsl:call-template>
          </xsl:if>
        </xsl:for-each>
      </xsl:element>
      <xsl:if test="count(fpage) &gt; 0 or count(lpage) &gt; 0 or count(page-count) &gt; 0">
        <xsl:element name="pagination">
          <xsl:if test="fpage">
            <xsl:element name ="page">
              <xsl:value-of select="fpage"/>
            </xsl:element>
          </xsl:if>
          <xsl:if test="count(lpage) &gt; 0 and count(fpage) &gt; 0">
            <xsl:element name ="toPage">
              <xsl:value-of select="lpage"/>
            </xsl:element>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="count(page-count)  &gt; 0">
              <xsl:element name ="pageCount">
                <xsl:value-of select="page-count"/>
              </xsl:element>
            </xsl:when>
            <xsl:when test="size/@units = 'page'">
              <xsl:element name ="pageCount">
                <xsl:value-of select="size"/>
              </xsl:element>
            </xsl:when>
            <xsl:when test="count(lpage) &gt; 0 and count(fpage) = 0">
              <xsl:element name ="pageCount">
                <xsl:value-of select="lpage"/>
              </xsl:element>
            </xsl:when>
           </xsl:choose>
           <xsl:element name ="prefix">
             <xsl:value-of select="//pub-id[@pub-id-type = 'publisher-id']"/>
           </xsl:element>
        </xsl:element>
      </xsl:if>
      <xsl:if test="count(uri) &gt; 0">
        <xsl:element name ="Url">
           <xsl:apply-templates select="uri"/>
        </xsl:element>
      </xsl:if>
      <xsl:if test="count(ext-link) &gt; 0 and count(uri) = 0">
        <xsl:if test="@ext-link-type = 'uri' or @ext-link-type = 'aoi' or @ext-link-type = 'ftp'">
          <xsl:element name ="url">
            <xsl:apply-templates select="."/>
          </xsl:element>
        </xsl:if>
      </xsl:if>
      <xsl:element name="availableFrom">
        <xsl:apply-templates select="comment/ext-link"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
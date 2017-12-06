<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ms="urn:schemas-microsoft-com:xslt">
  <xsl:include href="nlmCitationItem.xslt"/>
  <xsl:include href="nlmCitationPublication.xslt"/>
  <xsl:include href="nlmCitationOtherPublications.xslt"/>
  <xsl:variable name="punctuations">&#32;!"#$%&amp;'()*+,-./:;&lt;=&gt;?@[\]^_`{|}~bB</xsl:variable>
  <xsl:variable name="NlmToIdeas" >
    <pubtype nlm="journal">Journal</pubtype>
    <pubtype nlm="book">Book</pubtype>
    <pubtype nlm="book-chapter">Book</pubtype>
    <pubtype nlm="thesis">Dissertation</pubtype>
    <pubtype nlm="gov">Report</pubtype>
    <pubtype nlm="report">Report</pubtype>
    <pubtype nlm="conference">Conference</pubtype>
    <pubtype nlm="confproc">Conference</pubtype>
    <pubtype nlm="conf-proc">Conference</pubtype>
    <pubtype nlm="conf-paper">Conference</pubtype>
    <pubtype nlm="paper">Conference</pubtype>
    <pubtype nlm="web">Internet</pubtype>
    <pubtype nlm="web-page">Internet</pubtype>
    <pubtype nlm="discussion">Internet</pubtype>
    <pubtype nlm="list">Internet</pubtype>
    <pubtype nlm="commun">Communication</pubtype>
    <pubtype nlm="communication">Communication</pubtype>
    <pubtype nlm="patent">Patent</pubtype>
    <pubtype nlm="standard">Standard</pubtype>
    <pubtype nlm="other"></pubtype>
    <pubtype nlm="legal-doc"></pubtype>
    <pubtype nlm="unknown"></pubtype>
  </xsl:variable>
  <xsl:template name="nlm_Citations">
    <xsl:for-each select="//ref-list/ref/node()[local-name () = 'element-citation' or local-name () = 'nlm-citation' or local-name () = 'mixed-citation']">
      <xsl:element name="citation">
        <xsl:if test="@publication-type">
          <xsl:variable name="ptype" select="@publication-type"/>
          <!--<xsl:variable name="tptype" select="ms:node-set($NlmToIdeas)/pubtype[@nlm=$ptype]"/>-->
          <!--<xsl:if test="$tptype != ''">
            <xsl:element name="Type">
              <xsl:value-of select="$tptype"/>
            </xsl:element>
          </xsl:if>-->
        </xsl:if>
        <xsl:if test="@citation-type">
          <xsl:variable name="ptype" select="@citation-type"/>
          <!--<xsl:variable name="tptype" select="ms:node-set($NlmToIdeas)/pubtype[@nlm=$ptype]"/>-->
          <!--<xsl:if test="$tptype != ''">
            <xsl:element name="Type">
              <xsl:value-of select="$tptype"/>
            </xsl:element>
          </xsl:if>-->
        </xsl:if>
        <xsl:element name="label">
          <xsl:value-of select="translate(../label,$punctuations,'')"/>
        </xsl:element>
        <xsl:element name ="comment">
          <xsl:apply-templates select="comment"/>
        </xsl:element>

        <xsl:if test="date-in-citation">
          <xsl:element name ="citedDate">
            <xsl:apply-templates select="date-in-citation"/>
          </xsl:element>
        </xsl:if>
        <xsl:if test="count(access-date) &gt; 0 and count(date-in-citation) = 0">
          <xsl:element name ="citedDate">
            <xsl:apply-templates select="access-date"/>
          </xsl:element>
        </xsl:if>

        <xsl:call-template name="nlm_CitationPublication"/>

        <xsl:call-template name="nlm_CitationOtherPublications"/>

        <xsl:call-template name="nlm_CitationItem"/>

      </xsl:element>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ms="urn:schemas-microsoft-com:xslt">
  <xsl:import href="nlmCitationAffiliateList.xslt"/>
  <xsl:template name="nlm_CitationItem">
      <xsl:element name="item">
        <xsl:element name="title">
          <xsl:apply-templates select="article-title"/>
        </xsl:element>
        <xsl:element name="translatedTitle">
          <xsl:apply-templates select="trans-title"/>
        </xsl:element>
        <xsl:choose>
          <xsl:when test="count(person-group) &gt; 0">
            <xsl:element name ="authors">
              <xsl:for-each select="person-group">
                <xsl:if test="@person-group-type = 'author' or @person-group-type = 'allauthors'">
                  <xsl:call-template name="nlm_CitationAffiliateList">
                     <xsl:with-param name="persontype" select="@person-group-type" />
                  </xsl:call-template>
                </xsl:if>
              </xsl:for-each>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name ="authors">
              <xsl:call-template name="nlm_CitationAffiliateList">
                <xsl:with-param name="persontype" select="'author'" />
              </xsl:call-template>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:variable name="doi-list">
          <xsl:for-each select="pub-id">
            <xsl:if test="@pub-id-type = 'doi'">
              <xsl:element name ="doi">
                <xsl:apply-templates select="."/>
              </xsl:element>
            </xsl:if>
          </xsl:for-each>
        </xsl:variable>
        <!--<xsl:if test="count(ms:node-set($doi-list)/doi) &gt; 0">
          <xsl:element name ="Doi">
            <xsl:apply-templates select="ms:node-set($doi-list)/doi[last()]"/>
          </xsl:element>
        </xsl:if>-->
        <xsl:for-each select="pub-id">
          <xsl:if test="@pub-id-type = 'arxiv'">
            <xsl:element name ="arxiv">
              <xsl:value-of select="."/>
            </xsl:element>
          </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="pub-id">
          <xsl:if test="@pub-id-type = 'pii'">
            <xsl:element name ="Pii">
              <xsl:value-of select="."/>
            </xsl:element>
          </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="pub-id">
          <xsl:if test="@pub-id-type = 'sici'">
            <xsl:element name ="Sici">
              <xsl:value-of select="."/>
            </xsl:element>
          </xsl:if>
        </xsl:for-each>
      </xsl:element>
  </xsl:template>
</xsl:stylesheet>
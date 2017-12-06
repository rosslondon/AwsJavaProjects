<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="italic">
    <xsl:element name="i">
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>
  <xsl:template match="bold">
    <xsl:element name="b">
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>
  <xsl:template match="underline">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="sub">
    <xsl:element name="sub">
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>
  <xsl:template match="sup">
    <xsl:element name="sup">
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>
  <xsl:template match="p">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="formula">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="inline-formula">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="x">
    <xsl:text> </xsl:text>
  </xsl:template>
  <xsl:template match="front/article-meta/abstract/title"/>
  <xsl:template match="aff/x/sup"/>
  <xsl:template match="aff/x/sub"/>
  <xsl:template match="aff/label"/>
  <xsl:template match="aff/sup"/>
  <xsl:template match="aff/sub"/>
</xsl:stylesheet>
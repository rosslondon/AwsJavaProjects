﻿<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:include href="formattings.xslt" />
  <xsl:include href="nlmPublication.xslt" />
  <xsl:include href="nlmItem.xslt" />
  <xsl:include href="MathML.xsl" />
  <xsl:template name="nlm_Parser">
    <xsl:element name="CaptureData">
      <xsl:call-template name="nlm_Publication" />
      <xsl:call-template name="nlm_Item" />
    </xsl:element>
  </xsl:template>
  <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" />
  <xsl:strip-space elements="*" />
  <xsl:template match="article">
    <xsl:call-template name="nlm_Parser" />
  </xsl:template>
</xsl:stylesheet>

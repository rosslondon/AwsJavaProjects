<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:include href="formattings.xslt"/>
<xsl:include href="nlmPublication.xslt"/>
<xsl:include href="nlmItem.xslt"/>
<xsl:include href="nlmCitations.xslt"/>
<xsl:include href="MathML.xsl"/>
  <xsl:template name="nlm_Parser">
    <xsl:element name="CaptureData">
      <xsl:call-template name="nlm_Publication"/>
      <xsl:call-template name="nlm_Item"/>
      <xsl:call-template name="nlm_Citations"/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
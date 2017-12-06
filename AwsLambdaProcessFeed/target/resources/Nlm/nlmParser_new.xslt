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
<xsl:include href="formattings.xslt"/>
<xsl:include href="nlmPublication_new.xslt"/>	
<xsl:include href="nlmItem_new.xslt"/>
<xsl:include href="nlmCitations.xslt"/>
<xsl:include href="MathML.xsl"/>
  <xsl:template name="nlm_Parser">
    <xsl:element name="itemWrapper">
	  <xsl:call-template name="nlm_Publication"/>
	  <xsl:element name="items">
	    <xsl:call-template name="nlm_Item"/>
      </xsl:element>
	</xsl:element>
  </xsl:template>
</xsl:stylesheet>
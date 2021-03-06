<?xml version="1.0" encoding="UTF-8"?>
<!--
This file was generated by Altova MapForce 2018

YOU SHOULD NOT MODIFY THIS FILE, BECAUSE IT WILL BE
OVERWRITTEN WHEN YOU RE-RUN CODE GENERATION.

Refer to the Altova MapForce Documentation for further details.
http://www.altova.com/mapforce
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<xsl:variable name="var1_initial" select="."/>
		<item xmlns="http://data.iet.org/schemas/inspec/content" xmlns:ag="http://data.iet.org/schemas/agency" xmlns:an="http://data.iet.org/schemas/annotation" xmlns:co="http://data.iet.org/schemas/concept" xmlns:c="http://data.iet.org/schemas/core" xmlns:ev="http://data.iet.org/schemas/inspec/event">
			<xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance">http://data.iet.org/schemas/inspec/content file:///C:/GitHub/Inspec2/iet-schemas/src/main/resources/schemas/inspec2/inspec-content.xsd</xsl:attribute>
			<author>
				<xsl:for-each select="(./*[local-name()='article' and namespace-uri()='']/*[local-name()='front' and namespace-uri()='']/*[local-name()='article-meta' and namespace-uri()='']/*[local-name()='author-notes' and namespace-uri()='']/*[local-name()='fn' and namespace-uri()='']/*[local-name()='p' and namespace-uri()='']/*[local-name()='email' and namespace-uri()='']/node())[./self::text()]">
					<xsl:variable name="var2_filter" select="."/>
					<xsl:attribute name="email" namespace="">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>
				<xsl:for-each select="*[local-name()='article' and namespace-uri()='']/*[local-name()='front' and namespace-uri()='']/*[local-name()='article-meta' and namespace-uri()='']/*[local-name()='author-notes' and namespace-uri()='']/*[local-name()='fn' and namespace-uri()='']/*[local-name()='p' and namespace-uri()='']/*[local-name()='email' and namespace-uri()='']/node()">
					<xsl:variable name="var3_filter" select="."/>
					<xsl:copy-of select="/.."/>
				</xsl:for-each>
			</author>
		</item>
	</xsl:template>
</xsl:stylesheet>

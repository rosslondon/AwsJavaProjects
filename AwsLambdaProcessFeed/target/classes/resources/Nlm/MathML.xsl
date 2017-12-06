<?xml version='1.0' encoding="UTF-8"?>
<!-- ********************************************************************
	 Author: Steve Allen
	 Date  : 2009
	 ********************************************************************

   This file is for converting mml:mathMl
	 Default namespace is the XML mml:mathml tag namespace (mml)

     ******************************************************************** -->
<!--Amendments
		02/06/2010 - Use b and i tags for bold and italic for InspecML
-->
<!-- ==================================================================== -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		 		xmlns:exsl="urn:schemas-mml:microsoft-com:xslt"
				extension-element-prefixes="exsl"
	    	xmlns:msxsl="urn:schemas-mml:microsoft-com:xslt"
				xmlns:mml="http://www.w3.org/1998/Math/MathML"
				version="1.0">

  <xsl:output method="xml"/>
  <!-- xml output so that angle brackets, ampersands defined as entities-->

  <xsl:param name="print" select="'no'"/>
  <xsl:param name="printWidth" select="0"/>

  <!-- Characters we'll support.
       We could add control chars 0-31 and 127-159, but we won't. -->
  <xsl:variable name="ascii">&#32;!"#$%&amp;'()*+,-./0123456789:;&lt;=&gt;?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~</xsl:variable>

  <xsl:variable
	name="latin1">&#160;&#161;&#162;&#163;&#164;&#165;&#166;&#167;&#168;&#169;&#170;&#171;&#172;&#173;&#174;&#175;&#176;&#177;&#178;&#179;&#180;&#181;&#182;&#183;&#184;&#185;&#186;&#187;&#188;&#189;&#190;&#191;&#192;&#193;&#194;&#195;&#196;&#197;&#198;&#199;&#200;&#201;&#202;&#203;&#204;&#205;&#206;&#207;&#208;&#209;&#210;&#211;&#212;&#213;&#214;&#215;&#216;&#217;&#218;&#219;&#220;&#221;&#222;&#223;&#224;&#225;&#226;&#227;&#228;&#229;&#230;&#231;&#232;&#233;&#234;&#235;&#236;&#237;&#238;&#239;&#240;&#241;&#242;&#243;&#244;&#245;&#246;&#247;&#248;&#249;&#250;&#251;&#252;&#253;&#254;&#255;</xsl:variable>

  <!-- Characters that usually don't need to be escaped -->
  <xsl:variable
	name="safe">!$&amp;'()*-./0123456789:=;?@ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~</xsl:variable>

  <xsl:variable name="hex" >0123456789abcdef</xsl:variable>

  <xsl:template match="mml:math" >
    <xsl:apply-templates />
  </xsl:template>


  <!-- mml:mathMl templates -->
  <xsl:template match="mml:msup" >
    <xsl:param name="flag" select="'0'"/>

    <xsl:choose>
      <xsl:when test="count(mml:mrow)=0">
        <xsl:for-each select="*">
          <xsl:variable name="elem">
            <xsl:value-of select="name()"/>
          </xsl:variable>

          <xsl:choose>
            <xsl:when test="position()=1">
              <xsl:apply-templates select="."/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="name()='mml:msup'">
                  <xsl:text disable-output-escaping="yes">&lt;sup&gt;</xsl:text>
                  <xsl:apply-templates select=".">
                    <xsl:with-param name="flag" select="'1'"/>
                  </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="name()='mml:msub'">
                  <xsl:text disable-output-escaping="yes">&lt;sub&gt;</xsl:text>
                  <xsl:apply-templates select=".">
                    <xsl:with-param name="flag" select="'2'"/>
                  </xsl:apply-templates>
                </xsl:when>

                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="$flag='0'">
                      <xsl:text disable-output-escaping="yes">&lt;sup&gt;</xsl:text>
                      <xsl:apply-templates select="."/>

                      <xsl:text disable-output-escaping="yes">&lt;/sup&gt;</xsl:text>
                    </xsl:when>

                    <xsl:when test="$flag='1'">
                      <xsl:text>%</xsl:text>
                      <xsl:apply-templates select="."/>
                      <xsl:text disable-output-escaping="yes">&lt;/sup&gt;</xsl:text>
                    </xsl:when>

                    <xsl:when test="$flag='2'">
                      <xsl:text disable-output-escaping="yes">&lt;/sup&gt;</xsl:text>
                      <xsl:text disable-output-escaping="yes">&lt;sup&gt;</xsl:text>
                      <xsl:apply-templates select="."/>
                      <xsl:text disable-output-escaping="yes">&lt;/sup&gt;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                    </xsl:otherwise>
                  </xsl:choose>

                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="count(mml:mrow)=1">
        <xsl:for-each select="*">
          <xsl:variable name="elem">
            <xsl:value-of select="name()"/>
            <xsl:value-of select="position()"/>
          </xsl:variable>

          <xsl:choose>
            <xsl:when test="$elem='mml:mrow1'">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="substring($elem, 1, 4)='mml:mrow'">
              <xsl:text disable-output-escaping="yes">&lt;sup&gt;</xsl:text>
              <xsl:apply-templates/>
              <xsl:text disable-output-escaping="yes">&lt;/sup&gt;</xsl:text>
            </xsl:when>
            <xsl:when test="substring($elem, 1, 2)='mml:mi'">
              <!-- if no following siblings, then surround by sup-->
              <xsl:if test="name(following-sibling::*)=''">
                <xsl:text disable-output-escaping="yes">&lt;sup&gt;</xsl:text>
              </xsl:if>
              <xsl:call-template name="mml:mi"/>
              <!-- must call "mml:mi" by name else default template is called -->
              <xsl:if test="name(following-sibling::*)=''">
                <xsl:text disable-output-escaping="yes">&lt;/sup&gt;</xsl:text>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="count(mml:mrow)=2">
        <xsl:for-each select="mml:mrow">
          <xsl:choose>
            <xsl:when test="position()=1">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="position()=2">
              <xsl:text disable-output-escaping="yes">&lt;sup&gt;</xsl:text>
              <xsl:apply-templates/>
              <xsl:text disable-output-escaping="yes">&lt;/sup&gt;</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="mml:msub">
    <xsl:param name="flag" select="'0'"/>

    <xsl:choose>
      <xsl:when test="count(mml:mrow)=0">
        <xsl:for-each select="*">
          <xsl:variable name="elem">
            <xsl:value-of select="name()"/>
          </xsl:variable>

          <xsl:choose>
            <xsl:when test="position()=1">
              <xsl:apply-templates select="."/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="name()='mml:msub'">
                  <xsl:text disable-output-escaping="yes">&lt;sub&gt;</xsl:text>
                  <xsl:apply-templates select=".">
                    <xsl:with-param name="flag" select="'1'"/>
                  </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="name()='mml:msup'">
                  <xsl:text disable-output-escaping="yes">&lt;sup&gt;</xsl:text>
                  <xsl:apply-templates select=".">
                    <xsl:with-param name="flag" select="'2'"/>
                  </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="$flag='0'">
                      <xsl:text disable-output-escaping="yes">&lt;sub&gt;</xsl:text>
                      <xsl:apply-templates select="."/>

                      <xsl:text disable-output-escaping="yes">&lt;/sub&gt;</xsl:text>
                    </xsl:when>

                    <xsl:when test="$flag='1'">
                      <xsl:text>%</xsl:text>
                      <xsl:apply-templates select="."/>
                      <xsl:text disable-output-escaping="yes">&lt;/sub&gt;</xsl:text>
                    </xsl:when>

                    <xsl:when test="$flag='2'">
                      <xsl:text disable-output-escaping="yes">&lt;/sub&gt;</xsl:text>
                      <xsl:text disable-output-escaping="yes">&lt;sub&gt;</xsl:text>
                      <xsl:apply-templates select="."/>
                      <xsl:text disable-output-escaping="yes">&lt;/sub&gt;</xsl:text>
                    </xsl:when>

                    <xsl:otherwise>
                    </xsl:otherwise>
                  </xsl:choose>

                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="count(mml:mrow)=1">
        <xsl:for-each select="*">
          <xsl:variable name="elem">
            <xsl:value-of select="name()"/>
            <xsl:value-of select="position()"/>
          </xsl:variable>

          <xsl:choose>
            <xsl:when test="$elem='mml:mrow1'">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="substring($elem, 1, 4)='mml:mrow'">
              <xsl:text disable-output-escaping="yes">&lt;sub&gt;</xsl:text>
              <xsl:apply-templates/>
              <xsl:text disable-output-escaping="yes">&lt;/sub&gt;</xsl:text>
            </xsl:when>
            <xsl:when test="substring($elem, 1, 2)='mml:mi'">
              <!-- if no following siblings, then surround by sup-->
              <xsl:if test="name(following-sibling::*)=''">
                <xsl:text disable-output-escaping="yes">&lt;sub&gt;</xsl:text>
              </xsl:if>
              <xsl:call-template name="mml:mi"/>
              <!-- must call "mml:mi" by name else default template is called -->
              <xsl:if test="name(following-sibling::*)=''">
                <xsl:text disable-output-escaping="yes">&lt;/sub&gt;</xsl:text>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="count(mml:mrow)=2">
        <xsl:for-each select="mml:mrow">
          <xsl:choose>
            <xsl:when test="position()=1">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="position()=2">
              <xsl:text disable-output-escaping="yes">&lt;sub&gt;</xsl:text>
              <xsl:apply-templates/>
              <xsl:text disable-output-escaping="yes">&lt;/sub&gt;</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="mml:msup1">
    <xsl:choose>
      <xsl:when test="count(mml:mrow)=0">
        <xsl:variable name="supstr">
          <xsl:apply-templates select="*"/>
        </xsl:variable>

        <xsl:value-of select="substring($supstr, 1, 1)"/>

        <xsl:text disable-output-escaping="yes">&lt;sup&gt;</xsl:text>
        <xsl:value-of select="substring($supstr, 2, 1)"/>
        <xsl:text disable-output-escaping="yes">&lt;/sup&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="count(mml:mrow)=1">
        <xsl:for-each select="*">
          <xsl:variable name="elem">
            <xsl:value-of select="name()"/>
            <xsl:value-of select="position()"/>
          </xsl:variable>

          <xsl:choose>
            <xsl:when test="$elem='mml:mrow1'">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="substring($elem, 1, 4)='mml:mrow'">
              <xsl:text disable-output-escaping="yes">&lt;sup&gt;</xsl:text>
              <xsl:apply-templates/>
              <xsl:text disable-output-escaping="yes">&lt;/sup&gt;</xsl:text>
            </xsl:when>
            <xsl:when test="substring($elem, 1, 2)='mml:mi'">
              <xsl:call-template name="mml:mi"/>
              <!-- must call "mml:mi" by name else default template is called -->
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="count(mml:mrow)=2">
        <xsl:for-each select="mml:mrow">
          <xsl:choose>
            <xsl:when test="position()=1">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="position()=2">
              <xsl:text disable-output-escaping="yes">&lt;sup&gt;</xsl:text>
              <xsl:apply-templates/>
              <xsl:text disable-output-escaping="yes">&lt;/sup&gt;</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="mml:msub1">
    <xsl:choose>
      <xsl:when test="count(mml:mrow)=0">
        <xsl:variable name="substr">
          <xsl:apply-templates select="*"/>
        </xsl:variable>

        <xsl:value-of select="substring($substr, 1, 1)"/>

        <xsl:text disable-output-escaping="yes">&lt;sub&gt;</xsl:text>
        <xsl:value-of select="substring($substr, 2, 1)"/>
        <xsl:text disable-output-escaping="yes">&lt;/sub&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="count(mml:mrow)=1">
        <xsl:for-each select="*">
          <xsl:variable name="elem">
            <xsl:value-of select="name()"/>
            <xsl:value-of select="position()"/>
          </xsl:variable>

          <xsl:choose>
            <xsl:when test="$elem='mml:mrow1'">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="substring($elem, 1, 4)='mml:mrow'">
              <xsl:text disable-output-escaping="yes">&lt;sub&gt;</xsl:text>
              <xsl:apply-templates/>
              <xsl:text disable-output-escaping="yes">&lt;/sub&gt;</xsl:text>
            </xsl:when>
            <xsl:when test="substring($elem, 1, 2)='mml:mi'">
              <xsl:call-template name="mml:mi"/>
              <!-- must call "mml:mi" by name else default template is called -->
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="count(mml:mrow)=2">
        <xsl:for-each select="mml:mrow">
          <xsl:choose>
            <xsl:when test="position()=1">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="position()=2">
              <xsl:text disable-output-escaping="yes">&lt;sub&gt;</xsl:text>
              <xsl:apply-templates/>
              <xsl:text disable-output-escaping="yes">&lt;/sub&gt;</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--<xsl:template match="mml:mrow">
	<xsl:for-each select="*">
		<xsl:apply-templates/>
	</xsl:for-each>
</xsl:template>-->

  <!-- fractions -->
  <xsl:template match="mml:mfrac">

    <xsl:choose>
      <xsl:when test="count(mml:mrow)=0">
        <!-- SIMPLE fraction -->
        <!-- encase the simple fraction in () if not followed by a space-->
        <xsl:if test="name(following-sibling::*)!='mspace'">
          <xsl:if test="name(following-sibling::*)!=''">
            <xsl:text>(</xsl:text>
          </xsl:if>
        </xsl:if>

        <xsl:for-each select="*">
          <xsl:if test="position()=2">
            <xsl:text>/</xsl:text>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="name()='mml:mi'">
              <xsl:call-template name="mml:mi"/>
              <!-- must call "mml:mi" by name else default template is called -->
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <xsl:if test="name(following-sibling::*)!='mspace'">
          <xsl:if test="name(following-sibling::*)!=''">
            <xsl:text>)</xsl:text>
          </xsl:if>
        </xsl:if>
      </xsl:when>
      <xsl:when test="count(mml:mrow)=1">
        <xsl:for-each select="*">
          <xsl:if test="name()='mml:mrow'">
            <xsl:text>[</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>]</xsl:text>
          </xsl:if>
          <xsl:if test="position()=2">
            <xsl:text>/</xsl:text>
          </xsl:if>
          <xsl:if test="name() !='mml:mrow'">
            <xsl:choose>
              <xsl:when test="name()='mml:mi'">
                <xsl:call-template name="mml:mi"/>
                <!-- must call "mml:mi" by name else default template is called -->
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="count(mml:mrow)=2">
        <xsl:for-each select="mml:mrow">
          <xsl:text>[</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>]</xsl:text>
          <xsl:if test="position()=1">
            <xsl:text>/</xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- <mml:msubsup>	foo	bar	baz</mml:msubsup> ==> foo<sub>bar</sub><sup>baz</sup> -->
  <xsl:template match="mml:msubsup">
    <xsl:for-each select="*">
      <xsl:choose>
        <xsl:when test="position()=1">
          <xsl:if test="name()='mml:mi'">
            <xsl:call-template name="mml:mi"/>
          </xsl:if>
          <xsl:if test="name()!='mml:mi'">
            <xsl:apply-templates/>
          </xsl:if>
        </xsl:when>
        <xsl:when test="position()=2">
          <xsl:element name="sub">
            <xsl:if test="name()='mml:mi'">
              <xsl:call-template name="mml:mi"/>
            </xsl:if>
            <xsl:if test="name()!='mml:mi'">

              <!-- need special processing here if mml:msup or mml:msub children
						     - skip the e tags and use &darr; -->


              <xsl:apply-templates mode="Insubsup"/>
            </xsl:if>
          </xsl:element>
        </xsl:when>
        <xsl:when test="position()=3">
          <xsl:element name="sup">
            <xsl:if test="name()='mml:mi'">
              <xsl:call-template name="mml:mi"/>
            </xsl:if>
            <xsl:if test="name()!='mml:mi'">

              <!-- need special processing here if mml:msup or mml:msub children
						     - skip the e tags and use &darr; -->

              <xsl:apply-templates mode="Insubsup"/>
            </xsl:if>
          </xsl:element>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>


  <xsl:template match="mml:mi" name="mml:mi">

    <xsl:variable name="cnt">
      <xsl:value-of select="count(*)"/>
    </xsl:variable>

    <xsl:variable name="len">
      <xsl:value-of select="string-length(.)"/>
    </xsl:variable>

    <xsl:variable name="totlen" select="number($cnt + $len)"/>

    <xsl:if test="$totlen=1">
      <!--<xsl:text disable-output-escaping="yes">&lt;e1&gt;</xsl:text>    REMOVE ITALICS FOR SINGLE CHAR -->
    </xsl:if>

    <xsl:variable name="elem">
      <xsl:value-of select="."/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="substring(@mml:mathvariant,1,4)='bold'">
        <xsl:element name="b">
          <!-- bold alone or bold-script etc.-->
          <xsl:choose>
            <xsl:when test="@mml:mathvariant='bold-script'">
              <xsl:call-template name="script">
                <xsl:with-param name="scriptparam" select="$elem"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:when>
      <xsl:when test="@mml:mathvariant='double-struck'">
        <!-- convert to double struck characters-->
        <xsl:choose>
          <xsl:when test="$elem='R'">
            <xsl:text disable-output-escaping="yes">&#x211d;</xsl:text>
          </xsl:when>
          <xsl:when test="$elem='N'">
            <xsl:text disable-output-escaping="yes">&#x2115;</xsl:text>
          </xsl:when>
          <xsl:when test="$elem='O'">
            <xsl:text disable-output-escaping="yes">&#x1D546;</xsl:text>
          </xsl:when>
          <xsl:when test="$elem='C'">
            <xsl:text disable-output-escaping="yes">&#x2102;</xsl:text>
          </xsl:when>
          <xsl:when test="$elem='Q'">
            <xsl:text disable-output-escaping="yes">&#x211a;</xsl:text>
          </xsl:when>
          <xsl:when test="$elem='Z'">
            <xsl:text disable-output-escaping="yes">&#x2124;</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="b">
              <!-- other double-struck characters are in bold -->
              <xsl:apply-templates/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="@mml:mathvariant='script'">
        <xsl:call-template  name="script">
          <xsl:with-param name="scriptparam" select="$elem"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- no attributes to process-->
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>


    <!--
	<xsl:if test="@mml:mathvariant='bold'">
		<xsl:text disable-output-escaping="yes">&lt;e2&gt;</xsl:text>
	</xsl:if>

	<xsl:variable name="cnt">
		<xsl:value-of select="count(*)"/>
	</xsl:variable>

	<xsl:variable name="len">
		<xsl:value-of select="string-length(.)"/>
	</xsl:variable>

	<xsl:variable name="totlen" select="number($cnt + $len)"/>

	<xsl:choose>
		<xsl:when test="$totlen=1">
			 Gary Turner rule - italic if single character
			
			<e1><xsl:apply-templates/></e1>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates/>
		</xsl:otherwise>
		
	</xsl:choose>

	<xsl:if test="@mml:mathvariant='bold'">
		<xsl:text disable-output-escaping="yes">&lt;/e2&gt;</xsl:text>
	</xsl:if>
		-->
    <xsl:if test="$totlen=1">
      <!--<xsl:text disable-output-escaping="yes">&lt;/e1&gt;</xsl:text> REMOVE ITALICS FOR SINGLE CHAR -->
    </xsl:if>

  </xsl:template>

  <!-- Converts uppercase alphabetics to scripted characters -->
  <!-- Called for the mml:mi tag mml:mathvariant attribute -->
  <xsl:template name="script">
    <xsl:param name="scriptparam"/>
    <xsl:choose>
      <xsl:when test="$scriptparam='A'">
        <xsl:text disable-output-escaping="yes">&#x1D49C;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='B'">
        <xsl:text disable-output-escaping="yes">&#x1D49D;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='C'">
        <xsl:text disable-output-escaping="yes">&#x1D49E;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='D'">
        <xsl:text disable-output-escaping="yes">&#x1D49F;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='E'">
        <xsl:text disable-output-escaping="yes">&#x1D4A0;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='F'">
        <xsl:text disable-output-escaping="yes">&#x1D4A1;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='G'">
        <xsl:text disable-output-escaping="yes">&#x1D4A2;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='H'">
        <xsl:text disable-output-escaping="yes">&#x1D4A3;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='I'">
        <xsl:text disable-output-escaping="yes">&#x1D4A4;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='J'">
        <xsl:text disable-output-escaping="yes">&#x1D4A5;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='K'">
        <xsl:text disable-output-escaping="yes">&#x1D4A6;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='L'">
        <xsl:text disable-output-escaping="yes">&#x1D4A7;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='M'">
        <xsl:text disable-output-escaping="yes">&#x1D4A8;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='N'">
        <xsl:text disable-output-escaping="yes">&#x1D4A9;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='O'">
        <xsl:text disable-output-escaping="yes">&#x1D4AA;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='P'">
        <xsl:text disable-output-escaping="yes">&#x1D4AB;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='Q'">
        <xsl:text disable-output-escaping="yes">&#x1D4AC;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='R'">
        <xsl:text disable-output-escaping="yes">&#x1D4AD;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='S'">
        <xsl:text disable-output-escaping="yes">&#x1D4AE;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='T'">
        <xsl:text disable-output-escaping="yes">&#x1D4AF;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='U'">
        <xsl:text disable-output-escaping="yes">&#x1D4B0;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='V'">
        <xsl:text disable-output-escaping="yes">&#x1D4B1;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='W'">
        <xsl:text disable-output-escaping="yes">&#x1D4B2;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='X'">
        <xsl:text disable-output-escaping="yes">&#x1D4B3;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='Y'">
        <xsl:text disable-output-escaping="yes">&#x1D4B4;</xsl:text>
      </xsl:when>
      <xsl:when test="$scriptparam='Z'">
        <xsl:text disable-output-escaping="yes">&#x1D4B5;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- <munder>XYZ</munder> ==> X<sub>YZ</sub>-->
  <!-- <munder>XY</munder> ==> X<sub>Y</sub>-->
  <!-- <munder>X<mml:mrow>YZ</mml:mrow></munder> ==> X<sub>Y</sub>-->
  <xsl:template match="mml:munder">
    <xsl:choose>
      <xsl:when test="count(mml:mrow)=0">
        <xsl:value-of select="substring(., 1, 1)"/>
        <xsl:element name="sub">
          <xsl:value-of select="substring-after(.,substring(., 1, 1))"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Amendment 08/2006 - handle variations of <mover> -->
  <!-- <mover>XYZ</mover> or <mover><mml:mi>a</mml:mi><mo>b</mo></mover>-->
  <xsl:template match="mml:mover">
    <xsl:choose>
      <xsl:when test="count(mml:mrow)=0">
        <!-- no mml:mrow within mover -->

        <xsl:choose>
          <xsl:when test="count(mml:mi)=0 and count(mn)=0">
            <!-- <mover>XYZ</mover> ==> X<sup>YZ</sup>-->
            <xsl:value-of select="substring(., 1, 1)"/>
            <xsl:element name="sup">
              <xsl:value-of select="substring-after(.,substring(., 1, 1))"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <!-- <mover><mml:mi>a</mml:mi><mo>b<mo></mover> ==> ab-->
            <!-- <mover><mn>a</mn><mo>b<mo></mover> ==> ab-->
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- <munderover>foo bar baz</munderover> ==> foo<sub>bar</sub><sup>baz</sup>-->
  <xsl:template match="mml:munderover">
    <xsl:for-each select="*">
      <xsl:choose>
        <xsl:when test="position()=1">
          <xsl:if test="name()='mml:mi'">
            <xsl:call-template name="mml:mi"/>
          </xsl:if>
          <xsl:if test="name()!='mml:mi'">
            <xsl:apply-templates/>
          </xsl:if>
        </xsl:when>
        <xsl:when test="position()=2">
          <xsl:element name="sub">
            <xsl:if test="name()='mml:mi'">
              <xsl:call-template name="mml:mi"/>
            </xsl:if>
            <xsl:if test="name()!='mml:mi'">

              <!-- need special processing here if mml:msup or mml:msub children
						     - skip the e tags and use &darr; -->


              <xsl:apply-templates/>
            </xsl:if>
          </xsl:element>
        </xsl:when>
        <xsl:when test="position()=3">
          <xsl:element name="sup">
            <xsl:if test="name()='mml:mi'">
              <xsl:call-template name="mml:mi"/>
            </xsl:if>
            <xsl:if test="name()!='mml:mi'">

              <!-- need special processing here if mml:msup or mml:msub children
						     - skip the e tags and use &darr; -->



              <xsl:apply-templates/>
            </xsl:if>
          </xsl:element>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="mml:mroot">
    <xsl:element name="sup">
      <xsl:value-of select="substring(., string-length(.), 1)"/>
    </xsl:element>
    <xsl:text disable-output-escaping="yes">&#x221a;</xsl:text>
    <xsl:value-of select="substring(.,2,string-length(.))"/>
  </xsl:template>

  <xsl:template match="mml:mspace">
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="mml:msqrt">
    <xsl:text disable-output-escaping="yes">&#x221a;</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>




  <!-- ==================================================== -->
  <!-- Start special templates for stuff inside <mml:msubsup>   -->
  <!-- ==================================================== -->

  <!-- if any single <mml:mi> character, contain within bold <b> -->
  <xsl:template match="mml:mi"  mode="Insubsup">
    <xsl:if test="@mml:mathvariant='bold'">
      <xsl:text disable-output-escaping="yes">&lt;b&gt;</xsl:text>
    </xsl:if>

    <xsl:variable name="cnt">
      <xsl:value-of select="count(*)"/>
    </xsl:variable>

    <xsl:variable name="len">
      <xsl:value-of select="string-length(.)"/>
    </xsl:variable>

    <xsl:variable name="totlen" select="number($cnt + $len)"/>

    <xsl:choose>
      <xsl:when test="$totlen=1">
        <xsl:element name="i">
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>

      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="@mml:mathvariant='bold'">
      <xsl:text disable-output-escaping="yes">&lt;/b&gt;</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- Amendment 30/08/2006 handle <mo> within mml:msubsup -->
  <!-- if any single <mo> character, contain within bold -->
  <xsl:template match="mml:mo"  mode="Insubsup">
    <xsl:if test="@mml:mathvariant='bold'">
      <xsl:text disable-output-escaping="yes">&lt;b&gt;</xsl:text>
    </xsl:if>

    <xsl:variable name="cnt">
      <xsl:value-of select="count(*)"/>
    </xsl:variable>

    <xsl:variable name="len">
      <xsl:value-of select="string-length(.)"/>
    </xsl:variable>

    <xsl:variable name="totlen" select="number($cnt + $len)"/>

    <xsl:choose>
      <xsl:when test="$totlen=1">
        <i>
          <xsl:apply-templates/>
        </i>
      </xsl:when>

      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="@mml:mathvariant='bold'">
      <xsl:text disable-output-escaping="yes">&lt;/b&gt;</xsl:text>
    </xsl:if>
  </xsl:template>





  <xsl:template match="mml:msub" mode="Insubsup">
    <xsl:param name="flag" select="'0'"/>

    <xsl:choose>
      <xsl:when test="count(mml:mrow)=0">
        <xsl:for-each select="*">
          <xsl:variable name="elem">
            <xsl:value-of select="name()"/>
          </xsl:variable>

          <xsl:choose>
            <xsl:when test="position()=1">
              <xsl:apply-templates select="."/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="name()='mml:msub'">
                  <xsl:text disable-output-escaping="yes">&#8659;</xsl:text>
                  <xsl:apply-templates select=".">
                    <xsl:with-param name="flag" select="'1'"/>
                  </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="name()='mml:msup'">
                  <xsl:text disable-output-escaping="yes">&#8659;</xsl:text>
                  <xsl:apply-templates select=".">
                    <xsl:with-param name="flag" select="'2'"/>
                  </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="$flag='0'">
                      <xsl:text disable-output-escaping="yes">&#8659;</xsl:text>
                      <xsl:apply-templates select="."/>
                    </xsl:when>

                    <xsl:when test="$flag='1'">
                      <xsl:text>%</xsl:text>
                      <xsl:apply-templates select="."/>
                    </xsl:when>

                    <xsl:when test="$flag='2'">
                      <xsl:text disable-output-escaping="yes">&#8659;</xsl:text>
                      <xsl:apply-templates select="."/>

                    </xsl:when>

                    <xsl:otherwise>
                    </xsl:otherwise>
                  </xsl:choose>

                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="count(mml:mrow)=1">
        <xsl:for-each select="*">
          <xsl:variable name="elem">
            <xsl:value-of select="name()"/>
            <xsl:value-of select="position()"/>
          </xsl:variable>

          <xsl:choose>
            <xsl:when test="$elem='mml:mrow1'">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="substring($elem, 1, 4)='mml:mrow'">
              <xsl:text disable-output-escaping="yes">&#8659;</xsl:text>
              <xsl:apply-templates/>

            </xsl:when>
            <xsl:when test="substring($elem, 1, 2)='mml:mi'">
              <!-- if no following siblings, then use &darr;-->
              <xsl:if test="name(following-sibling::*)=''">
                <xsl:text disable-output-escaping="yes">&#8659;</xsl:text>
              </xsl:if>
              <xsl:call-template name="mml:mi"/>
              <!-- must call "mml:mi" by name else default template is called -->
              <xsl:if test="name(following-sibling::*)=''">
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="count(mml:mrow)=2">
        <xsl:for-each select="mml:mrow">
          <xsl:choose>
            <xsl:when test="position()=1">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="position()=2">
              <xsl:text disable-output-escaping="yes">&#8659;</xsl:text>
              <xsl:apply-templates/>

            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ==================================================== -->
  <!-- End special templates for stuff inside <mml:msubsup>     -->
  <!-- ==================================================== -->

</xsl:stylesheet>
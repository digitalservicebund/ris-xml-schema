<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="1.0"
>
  <xsl:output
    method="xml"
    encoding="UTF-8"
    indent="yes"
    omit-xml-declaration="no"
  />

  <xsl:strip-space elements="*" />

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:include href="license.xsl" />

  <!-- Remove the values "vertragsgesetz" and "vertragsverordnung" from the "typen" simpleType -->
  <xsl:template
    match="xs:simpleType[@name='typen']/xs:restriction/xs:enumeration[@value='vertragsgesetz' or @value='vertragsverordnung']"
    priority="2"
  />
</xsl:stylesheet>

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ldmlde="http://MetadatenRechtsetzungsdokument.LegalDocML.de/1.9/"
  version="1.0"
>
  <xsl:output
    method="xml"
    encoding="UTF-8"
    indent="yes"
    omit-xml-declaration="yes"
  />

  <xsl:strip-space elements="*" />

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:include href="license.xsl" />

  <!--  Remove comments  -->
  <xsl:template match="comment()" />

  <xsl:template match="/xs:schema">
    <xs:schema
      xmlns="http://rechtsinformationen.bund.de/schema/norm/metadata/rechtsetzungsdokument/0.1"
      targetNamespace="http://rechtsinformationen.bund.de/schema/norm/metadata/rechtsetzungsdokument/0.1"
      version="1.0"
    >
      <xsl:apply-templates
        select="node()|@*[not(name()='targetNamespace' or name()='version')]"
      />
    </xs:schema>
  </xsl:template>
</xsl:stylesheet>

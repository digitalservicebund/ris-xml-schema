<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  version="1.0"
>
  <xsl:output
    method="xml"
    encoding="UTF-8"
    indent="yes"
    omit-xml-declaration="yes"
  />

  <xsl:param name="merge" />

  <xsl:strip-space elements="*" />

  <xsl:include href="license.xsl" />

  <!--  Remove comments  -->
  <xsl:template match="comment()" />

  <!-- Copy over all elements and attributes that are not explicitly matched by other templates -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <!-- Remove only the selected FRBR facet block include lines -->
  <xsl:template
    match="sch:include[@href='legalDocML.de-frbr-metadaten-facetten-entwurfsfassung.sch']"
  />
  <xsl:template
    match="sch:include[@href='legalDocML.de-frbr-metadaten-facetten-konsolidierte-fassung.sch']"
  />
  <xsl:template
    match="sch:include[@href='legalDocML.de-frbr-metadaten-facetten-verkündungsfassung.sch']"
  />

  <!-- Remove the selected FRBR facet section title line -->
  <xsl:template
    match="sch:title[.='Zulässigkeit von Literalen / Mustern je Attribut an FRBR-Typen, abhängig von der Fassung (Entwurf vs. Verkündung)']"
  />

  <!-- Merge additional Schematron rules into the main schema -->
  <xsl:template match="/sch:schema">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
      <xsl:apply-templates select="document($merge)/sch:pattern" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>

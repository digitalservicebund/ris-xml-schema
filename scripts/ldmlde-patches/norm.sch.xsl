<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  exclude-result-prefixes="xs"
  version="1.0"
>
  <xsl:output
    method="xml"
    encoding="UTF-8"
    indent="yes"
    omit-xml-declaration="yes"
  />

  <xsl:strip-space elements="*" />

  <xsl:include href="license.xsl" />

  <!--  Remove comments  -->
  <xsl:template match="comment()" priority="1" />

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
    match="sch:include[@href='legalDocML.de-frbr-metadaten-facetten-verkündungsfassung.sch']"
  />

  <!-- Rewrite the include to match the renamed output file -->
  <xsl:template
    match="sch:include[@href='legalDocML.de-frbr-metadaten-facetten-konsolidierte-fassung.sch']"
  >
    <sch:include
      href="norm-frbr-metadaten-facetten-konsolidierte-fassung.sch"
    />
  </xsl:template>

  <!-- Remove the selected FRBR facet section title line -->
  <xsl:template
    match="sch:title[.='Zulässigkeit von Literalen / Mustern je Attribut an FRBR-Typen, abhängig von der Fassung (Entwurf vs. Verkündung)']"
  />

  <!-- Rewrite the akn namespace to match the RIS content namespace -->
  <xsl:template match="sch:ns[@prefix='akn']">
    <sch:ns
      uri="http://rechtsinformationen.bund.de/schema/norm/0.1"
      prefix="akn"
    />
  </xsl:template>

  <!-- Declare the xs prefix used by XPath expressions but missing from the source schema -->
  <xsl:template match="sch:ns[@prefix='fkt']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
    <sch:ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs" />
  </xsl:template>

  <!-- Remove Schematron rules -->
  <xsl:template match="sch:assert[@id='SCH-00660-015']" />
</xsl:stylesheet>

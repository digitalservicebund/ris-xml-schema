<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ldmlde="http://Inhaltsdaten.LegalDocML.de/1.9/"
  version="1.0"
>
  <!-- Keep the original license information and append the fork notice -->
  <xsl:template match="comment()[contains(., 'Lizensierung')]" priority="2">
    <xsl:comment>
      <xsl:value-of
        select="concat(., '&#10;&#10;Dieses Dokument ist eine Bearbeitung (Fork) des Originalwerks und die Änderungen stehen unter derselben Lizenz (CC-BY-3.0), sofern nicht anders angegeben.&#10;&#10;')"
      />
    </xsl:comment>
  </xsl:template>
  <xsl:template match="comment()" priority="1" />

  <!-- Update the xs:appinfo while retaining the original schema and adding a fork notice -->
  <xsl:template match="/xs:schema/xs:annotation/xs:appinfo">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" />
      <xsl:element name="hinweis">
        <xsl:text
        >Dieses Dokument ist eine Bearbeitung (Fork) des Originalwerks und die Änderungen stehen unter derselben Lizenz (CC-BY-3.0), sofern nicht anders angegeben.</xsl:text>
      </xsl:element>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>

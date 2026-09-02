<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ldmlde="http://Inhaltsdaten.LegalDocML.de/1.9/"
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

  <!-- Ensure the root xs:schema element has the correct targetNamespace and version -->
  <xsl:template match="/xs:schema">
    <xs:schema
      xmlns="http://rechtsinformationen.bund.de/schema/norm/0.1"
      targetNamespace="http://rechtsinformationen.bund.de/schema/norm/0.1"
      version="1.0"
    >
      <xsl:apply-templates
        select="node()|@*[not(name()='targetNamespace' or name()='version')]"
      />
    </xs:schema>
  </xsl:template>

  <!-- Remove xs:simpleType elements that are not used in the Rechtsinformationsportal -->
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.aenderungenAktiv']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.aenderungenPassiv']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.aenderungNeu']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.aenderungsantragDokumentenkopf']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.aenderungsantragDokumentenkopfTitel']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.aenderungsantragEingangsformel']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.aenderungsantragHauptteil']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.aenderungsantragSchluss']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.aenderungsbefehl']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.aenderungUrsprung']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.aenderungZielelement']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.aenderungZitatStruktur']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.aenderungZitatText']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.anschreibenDokumentenkopf']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.anschreibenHauptteil']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.antragEingangsformel']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.antragHauptteil']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.antragSchluss']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.begruendungAntragAbschnitt']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.begruendungAntragHauptteil']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.begruendungHauptteil']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.begruendungsteil']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.begruendungsteilAbschnitt']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.begruendungVertRASchlussbemerkung']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.bereichsreferenz']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.berichtAbschnitt']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.berichtHauptteil']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.berichtSchluss']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.beschlussempfehlungEingangsformel']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.beschlussempfehlungHauptteil']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.beschlussempfehlungSchlussteil']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.betroffenesDokument']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.bezugsdokument']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.denkschriftAbschnitt']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.denkschriftHauptteil']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.denkschriftTeil']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.dokumentenkopfAnschreibenAdresse']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.dokumentenStatus']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.dokumentenTyp']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.drucksachennummer']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.endeSeite']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.endeZeile']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.entschließungsantragEingangsformel']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.entschließungsantragHauptteil']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.entschließungsantragSchluss']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.ermaechtigungsnorm']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.ermaechtigungsnormEingangssatz']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.ermaechtigungsnormen']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.ermaechtigungsnormSchlusssatz']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.externesMarkup']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.funktionsbezeichnung']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.initiant']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.kombinierterAenderungsbefehl']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.mehrfachreferenz']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.organisation']"
  />
  <xsl:template match="/xs:schema/xs:simpleType[@name='eIdLiterals.ort']" />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.personenname']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.referenz']"
  />
  <xsl:template match="/xs:schema/xs:simpleType[@name='eIdLiterals.sitzung']" />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.sprachfassungPraeambelInhaltsuebersicht']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.textaenderung']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.unterrichtungDokumentenkopf']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.unterrichtungDokumentenkopfTitel']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.unterrichtungHauptteil']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.unterrichtungsbestandteilVerweis']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.unterrichtungSchluss']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.vereinbarungVertRADokumentenkopf']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.vereinbarungVertRAHauptteil']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.vereinbarungVertRASprachfassung']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.verweisFunktionsbezeichnung']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.verweisOrganisation']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.verweisPerson']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.vorblattBeschlussempfehlungAbschnitt']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.vorblattBeschlussempfehlungDokumentenkopf']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.vorblattBeschlussempfehlungDokumentenkopfTitel']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.vorblattBeschlussempfehlungHauptteil']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.vorblattRegelungstextAbschnitt']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.vorblattRegelungstextDokumentenkopf']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='eIdLiterals.vorblattRegelungstextHauptteil']"
  />
  <xsl:template match="/xs:schema/xs:simpleType[@name='endQuoteLiterals']" />
  <xsl:template match="/xs:schema/xs:simpleType[@name='fromLiterals']" />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.aenderungsantrag']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.anschreiben']"
  />
  <xsl:template match="/xs:schema/xs:simpleType[@name='nameLiterals.antrag']" />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.begruendung']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.begruendungAntrag']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.begruendungAntragAbschnitt']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.begruendungsteil']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.begruendungsteilAbschnitt']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.bericht']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.berichtAbschnitt']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.beschlussempfehlung']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.denkschriftAbschnitt']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.denkschriftTeil']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.denkschriftVertRA']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.entschließungsantrag']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.regelungstextEntwurfsfassung']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.sprachfassungPraeambelInhaltsuebersicht']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.unterrichtung']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.vereinbarungVertRA']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.vereinbarungVertRASprachfassung']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.vorblattAbschnitt']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.vorblattBeschlussempfehlung']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='nameLiterals.vorblattRegelungstext']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='periodLiterals.geltungszeitverweis']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='refersToLiterals.aenderungsbefehl']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='refersToLiterals.begruendungAntragAbschnitt']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='refersToLiterals.begruendungsteil']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='refersToLiterals.begruendungsteilAbschnitt']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='refersToLiterals.berichtAbschnitt']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='refersToLiterals.denkschriftAbschnitt']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='refersToLiterals.denkschriftTeil']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='refersToLiterals.drucksachennummer']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='refersToLiterals.organisation']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='refersToLiterals.ort']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='refersToLiterals.personenname']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='refersToLiterals.sitzung']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='refersToLiterals.sprachfassungPraeambelInhaltsuebersicht']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='refersToLiterals.vereinbarungVertRAHauptteil']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='refersToLiterals.vereinbarungVertRASprachfassung']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='refersToLiterals.vorblattBeschlussempfehlungAbschnitt']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='refersToLiterals.vorblattRegelungstextAbschnitt']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='shortFormLiterals.verweisFunktionsbezeichnung']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='shortFormLiterals.verweisOrganisation']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='shortFormLiterals.verweisPerson']"
  />
  <xsl:template match="/xs:schema/xs:simpleType[@name='shortFormLiterals']" />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='showAsLiterals.verweisFunktionsbezeichnung']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='showAsLiterals.verweisOrganisation']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='showAsLiterals.verweisPerson']"
  />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='sourceLiterals.dokumentauswertung']"
  />
  <xsl:template match="/xs:schema/xs:simpleType[@name='startQuoteLiterals']" />
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='statusLiterals.textaenderung']"
  />

  <!-- Remove xs:complexType and xs:group elements that are not used in the Rechtsinformationsportal -->
  <xsl:template match="/xs:schema/xs:complexType[@name='aenderungenAktiv']" />
  <xsl:template match="/xs:schema/xs:complexType[@name='aenderungenPassiv']" />
  <xsl:template match="/xs:schema/xs:complexType[@name='aenderungNeu']" />
  <xsl:template match="/xs:schema/xs:complexType[@name='aenderungsbefehl']" />
  <xsl:template
    match="/xs:schema/xs:complexType[@name='aenderungsbefehlInline']"
  />
  <xsl:template match="/xs:schema/xs:complexType[@name='aenderungUrsprung']" />
  <xsl:template
    match="/xs:schema/xs:complexType[@name='aenderungZielelement']"
  />
  <xsl:template
    match="/xs:schema/xs:complexType[@name='aenderungZitatStruktur']"
  />
  <xsl:template match="/xs:schema/xs:complexType[@name='aenderungZitatText']" />
  <xsl:template match="/xs:schema/xs:complexType[@name='bereichsreferenz']" />
  <xsl:template
    match="/xs:schema/xs:complexType[@name='betroffenesDokument']"
  />
  <xsl:template match="/xs:schema/xs:complexType[@name='bezugsdokument']" />
  <xsl:template match="/xs:schema/xs:complexType[@name='dokumentauswertung']" />
  <xsl:template match="/xs:schema/xs:complexType[@name='dokumentenStatus']" />
  <xsl:template match="/xs:schema/xs:complexType[@name='dokumentenTyp']" />
  <xsl:template match="/xs:schema/xs:complexType[@name='drucksachennummer']" />
  <xsl:template match="/xs:schema/xs:complexType[@name='endeSeite']" />
  <xsl:template match="/xs:schema/xs:complexType[@name='endeZeile']" />
  <xsl:template match="/xs:schema/xs:complexType[@name='ermaechtigungsnorm']" />
  <xsl:template
    match="/xs:schema/xs:complexType[@name='ermaechtigungsnormEingangssatz']"
  />
  <xsl:template
    match="/xs:schema/xs:complexType[@name='ermaechtigungsnormen']"
  />
  <xsl:template
    match="/xs:schema/xs:complexType[@name='ermaechtigungsnormSchlusssatz']"
  />
  <xsl:template match="/xs:schema/xs:complexType[@name='externesMarkup']" />
  <xsl:template
    match="/xs:schema/xs:complexType[@name='funktionsbezeichnung']"
  />
  <xsl:template
    match="/xs:schema/xs:complexType[@name='geltungszeitaenderung']"
  />
  <xsl:template
    match="/xs:schema/xs:complexType[@name='geltungszeitverweis']"
  />
  <xsl:template match="/xs:schema/xs:complexType[@name='initiant']" />
  <xsl:template
    match="/xs:schema/xs:complexType[@name='kombinierterAenderungsbefehl']"
  />
  <xsl:template match="/xs:schema/xs:complexType[@name='mehrfachreferenz']" />
  <xsl:template match="/xs:schema/xs:complexType[@name='organisation']" />
  <xsl:template match="/xs:schema/xs:complexType[@name='ort']" />
  <xsl:template match="/xs:schema/xs:complexType[@name='personenname']" />
  <xsl:template match="/xs:schema/xs:complexType[@name='referenz']" />
  <xsl:template match="/xs:schema/xs:complexType[@name='referenzen']" />
  <xsl:template match="/xs:schema/xs:complexType[@name='sitzung']" />
  <xsl:template match="/xs:schema/xs:complexType[@name='textaenderung']" />
  <xsl:template
    match="/xs:schema/xs:complexType[@name='verweisFunktionsbezeichnung']"
  />
  <xsl:template
    match="/xs:schema/xs:complexType[@name='verweisOrganisation']"
  />
  <xsl:template match="/xs:schema/xs:complexType[@name='verweisPerson']" />
  <xsl:template match="/xs:schema/xs:group[@name='aenderungsbefehle']" />
  <xsl:template match="/xs:schema/xs:group[@name='aenderungsbefehlInline']" />
  <xsl:template match="/xs:schema/xs:group[@name='aenderungsInhalt']" />
  <xsl:template match="/xs:schema/xs:group[@name='ANmarker']" />
  <xsl:template match="/xs:schema/xs:group[@name='endeSeite']" />
  <xsl:template match="/xs:schema/xs:group[@name='mehrfachreferenzinhalt']" />
  <xsl:template
    match="/xs:schema/xs:group[@name='regelungssprachlicherTeil']"
  />
  <xsl:template
    match="/xs:schema/xs:group[@name='verweiseAufExterneEntitaeten']"
  />

  <!-- Modify xs:simpleType elements to account for exclude types -->
  <xsl:template
    match="/xs:schema/xs:simpleType[@name='showAsLiterals.anlagenverweis']/xs:restriction"
  >
    <xsl:element name="xs:restriction">
      <xsl:attribute name="base">showAsLiterals</xsl:attribute>
      <xsl:element name="xs:enumeration">
        <xsl:attribute
          name="value"
        >/akn/ontology/de/concept/documenttype/bund/anlage-regelungstext</xsl:attribute>
      </xsl:element>
      <xsl:element name="xs:enumeration">
        <xsl:attribute
          name="value"
        >/akn/ontology/de/concept/documenttype/bund/rechtsetzungsdokument</xsl:attribute>
      </xsl:element>
      <xsl:element name="xs:enumeration">
        <xsl:attribute
          name="value"
        >/akn/ontology/de/concept/documenttype/bund/regelungstext</xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template
    match="/xs:schema/xs:simpleType[@name='showAsLiterals.teildokumentVerweis']/xs:restriction"
  >
    <xsl:element name="xs:restriction">
      <xsl:attribute name="base">showAsLiterals</xsl:attribute>
      <xsl:element name="xs:enumeration">
        <xsl:attribute
          name="value"
        >/akn/ontology/de/concept/documenttype/bund/anlage-regelungstext</xsl:attribute>
      </xsl:element>
      <xsl:element name="xs:enumeration">
        <xsl:attribute
          name="value"
        >/akn/ontology/de/concept/documenttype/bund/externe-ressource</xsl:attribute>
      </xsl:element>
      <xsl:element name="xs:enumeration">
        <xsl:attribute
          name="value"
        >/akn/ontology/de/concept/documenttype/bund/rechtsetzungsdokument</xsl:attribute>
      </xsl:element>
      <xsl:element name="xs:enumeration">
        <xsl:attribute
          name="value"
        >/akn/ontology/de/concept/documenttype/bund/regelungstext</xsl:attribute>
      </xsl:element>
      <xsl:element name="xs:enumeration">
        <xsl:attribute
          name="value"
        >/akn/ontology/de/concept/documenttype/bund/sonstiger-veroeffentlichungstext</xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- Modify xs:complexType elements to account for exclude types -->
  <xsl:template
    match="/xs:schema/xs:complexType[@name='eingangsformelUndVerzeichnis']/xs:sequence"
  >
    <xsl:copy>
      <xsl:apply-templates
        select="*[not((self::xs:element and @name='citations'))]"
      />
    </xsl:copy>
  </xsl:template>

  <xsl:template
    match="/xs:schema/xs:complexType[@name='metadatenVollstaendig']/xs:sequence"
  >
    <xsl:copy>
      <xsl:apply-templates
        select="*[not((self::xs:element and @name='analysis') or (self::xs:element and @name='references'))]"
      />
    </xsl:copy>
  </xsl:template>

  <xsl:template
    match="/xs:schema/xs:complexType[@name='metadatenMinimal']/xs:sequence"
  >
    <xsl:copy>
      <xsl:apply-templates
        select="*[not((self::xs:element and @name='analysis') or (self::xs:element and @name='references'))]"
      />
    </xsl:copy>
  </xsl:template>

  <xsl:template
    match="/xs:schema/xs:complexType[@name='metadatenOptionalErweitert']/xs:sequence"
  >
    <xsl:copy>
      <xsl:apply-templates
        select="*[not((self::xs:element and @name='analysis') or (self::xs:element and @name='references'))]"
      />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/xs:schema/xs:group[@name='ANinline']/xs:choice">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates
        select="xs:element[@name='authorialNote' or @name='noteRef']"
      />
    </xsl:copy>
  </xsl:template>

  <xsl:template
    match="/xs:schema/xs:group[@name='formatierteInlineelemente']/xs:choice"
  >
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates
        select="
        xs:element[@name='marker' or @name='inline' or @name='authorialNote']
        | xs:group[@ref='HTMLinline']
      "
      />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/xs:schema/xs:group[@name='inlineelement']/xs:choice">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates
        select="*[not(
        (self::xs:element and @name='affectedDocument')
        or (self::xs:element and @name='relatedDocument')
        or (self::xs:element and @name='session')
        or (self::xs:group and @ref='ANmarker')
      )]"
      />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/xs:schema/xs:group[@name='inhaltselement']/xs:choice">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates
        select="*[not((self::xs:element and @name='foreign'))]"
      />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/xs:schema/xs:group[@name='kontextelement']/xs:choice">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates
        select="xs:element[@name='date' or @name='signature']"
      />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/xs:schema/xs:group[@name='signaturInhalt']/xs:choice">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="xs:element[@name='date']" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/xs:schema/xs:group[@name='titelelement']/xs:choice">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates
        select="xs:element[@name='docTitle' or @name='shortTitle']"
      />
    </xsl:copy>
  </xsl:template>

  <!-- Add akn:blockList to akn:note -->
  <xsl:template
    match="xs:complexType[@name='nichtamtlicheFussnote']/xs:sequence"
  >
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
      <xs:element
        name="blockList"
        type="liste"
        minOccurs="0"
        maxOccurs="unbounded"
      />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>

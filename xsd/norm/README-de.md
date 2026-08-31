# Normen

XML-Schema für die strukturierte Bereitstellung von Normen im Rechtsinformationsportal, das auf [LegalDocML.de 1.9](https://gitlab.opencode.de/bmi/e-gesetzgebung/ldml_de) aufbaut und die Anforderungen des konsolidierten Bestandsrechts berücksichtigt. LegalDocML.de selbst ist ein deutsches Anwendungsprofil des OASIS-Standards Akoma Ntoso (LegalDocML).

## Anpassungen

Im Folgenden werden die Anpassungen von LegalDocML.de aufgelistet. Abseits dieser Anpassungen entspricht das Schema der ursprünglichen [Spezifikation](https://gitlab.opencode.de/bmi/e-gesetzgebung/ldml_de/-/raw/a654f19fa6182ec8dabbb9bcc0d826ab07ac54f9/Spezifikation/LegalDocML.de_1.9-20251103.pdf?inline=true).

### Reduktion auf notwendige Schemata und Typen

Aus LegalDocML.de wurden nur die folgenden XML-Schemata übernommen:

- `.xsd`-Dateien
  - `legalDocML.de-baukasten.xsd`
  - `legalDocML.de-metadaten-rechtsetzungsdokument.xsd`
  - `legalDocML.de-metadaten-regelungstext.xsd`
  - `legalDocML.de-metadaten-sonstigerveroeffentlichungstext.xsd`
  - `legalDocML.de-offenestruktur.xsd`
  - `legalDocML.de-rechtsetzungsdokument.xsd`
  - `legalDocML.de-regelungstext.xsd`
  - `legalDocML.de-sonstigerveroeffentlichungstext.xsd`
- `.sch`-Dateien
  - `legalDocML.de-frbr-metadaten-facetten-konsolidierte-fassung.sch`
  - `legalDocML.de.sch`

Durch Anwendung der `.xsl`-Dateien in [`scripts/ldmlde-patches`](../../scripts/ldmlde-patches) auf die entsprechenden `.xsd`- und `.sch`-Dateien
wurden die entsprechenden `.xsd`- und `.sch`-Dateien für das Rechtsinformationsportal erzeugt (mittels [`patch-ldmlde.sh`](../../scripts/patch-ldmlde.sh)).
Diese Dateien sind in [`xsd/norm/`](../../xsd/norm) abgelegt.

Das XML-Schemata von LegalDocML.de ist umfangreich und für das Rechtsinformationsportal wurden nur die relevanten Typen übernommen.

### Anpassungen der Namespace-URIs

Als Konvention werden die folgenden URIs für Namespaces verwendet:

| Alter URI                                                  | Neuer URI                                                                                 |
| ---------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| `http://Inhaltsdaten.LegalDocML.de/1.9/`                   | `http://rechtsinformationen.bund.de/schema/norm/0.1`                                      |
| `http://MetadatenRegelungstext.LegalDocML.de/1.9/`         | `http://rechtsinformationen.bund.de/schema/norm/norm-metadaten-regelungstext/0.1`         |
| `http://MetadatenRechtsetzungsdokument.LegalDocML.de/1.9/` | `http://rechtsinformationen.bund.de/schema/norm/norm-metadaten-rechtsetzungsdokument/0.1` |

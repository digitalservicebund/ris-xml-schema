# XSD

## Normen

XML-Schema für die strukturierte Bereitstellung von Normen im Rechtsinformationsportal, das auf [LegalDocML.de 1.9](https://gitlab.opencode.de/bmi/e-gesetzgebung/ldml_de) aufbaut und die Anforderungen des konsolidierten Bestandsrechts berücksichtigt. LegalDocML.de selbst ist ein deutsches Anwendungsprofil des OASIS-Standards Akoma Ntoso (LegalDocML).

## Anpassungen

Im Folgenden werden die Anpassungen von LegalDocML.de aufgelistet. Abseits dieser Anpassungen entspricht das Schema der ursprünglichen [Spezifikation](https://gitlab.opencode.de/bmi/e-gesetzgebung/ldml_de/-/raw/a654f19fa6182ec8dabbb9bcc0d826ab07ac54f9/Spezifikation/LegalDocML.de_1.9-20251103.pdf?inline=true).

### Reduktion auf notwendige Schemata und Typen

Aus LegalDocML.de wurden nur die folgenden XML-Schemata übernommen:

- `.xsd`-Dateien
  - `legalDocML.de-baukasten.xsd`
  - `legalDocML.de-offenestruktur.xsd`
  - `legalDocML.de-rechtsetzungsdokument.xsd`
  - `legalDocML.de-regelungstext.xsd`
  - `legalDocML.de-sonstigerveroeffentlichungstext.xsd`
- `.sch`-Dateien
  - `legalDocML.de-frbr-metadaten-facetten-konsolidierte-fassung.sch`
  - `legalDocML.de.sch`

Durch Anwendung der `.xsl`-Dateien in [`scripts/ldmlde-patches`](../../scripts/ldmlde-patches) auf die entsprechenden `.xsd`- und `.sch`-Dateien wurden die entsprechenden `.xsd`- und `.sch`-Dateien für das Rechtsinformationsportal erzeugt (mittels [`norms-ldml-tool.sh`](../scripts/norms-ldml-tool.sh)). Diese Dateien sind in [`xsd/norm-*`](../../xsd) abgelegt.

Das XML-Schemata von LegalDocML.de ist umfangreich und für das Rechtsinformationsportal wurden nur die relevanten Typen übernommen.

### Anpassungen der Namespace-URIs

Als Konvention werden die folgenden URIs für Namespaces verwendet:

| Alter URI                                       | Neuer URI                                                     |
| ----------------------------------------------- | ------------------------------------------------------------- |
| `http://Inhaltsdaten.LegalDocML.de/1.9/`        | `http://rechtsinformationen.bund.de/schema/norm/0.1`          |
| `http://www.ris.bund.de/grammatiken/metadaten/` | `http://rechtsinformationen.bund.de/schema/norm-metadata/0.1` |

### Anpassungen der Schematron Regeln

- Schematron Regel SCH-00660-015 wurde entfernt

### Erlauben von `akn:hcontainer` mit `akn:paragraph` in Gliederungsebenen

Innerhalb der Gruppe `regelungstextGliederung` wurde ein optionales `hcontainer`-Element (neuer Typ `gliederungContainer`, maximal einmal) hinzugefügt, das beliebig viele (auch keine) `paragraph`-Elemente (Typ `juristischerAbsatz`) enthält. Dadurch dürfen Gliederungsebenen wie `book`, `part`, `chapter`, `subchapter`, `section`, `subsection`, etc. freien Text in Form von Absätzen enthalten, bevor Artikel oder weitere Untergliederungen folgen. Der `hcontainer` ist unabhängig vom `hcontainer` der Begründung (`begruendungsteilAbschnitt`) und besitzt außer den Pflichtattributen `eId` und `GUID` (sowie optional `xml:id`) keine weiteren Attribute und keine weiteren Kindelemente. Für `eId` gilt das neue Literal `eIdLiterals.gliederungContainer` (AKN-Typ `hcontainer`, eId-Kurzbezeichnung `container`).

```xml
<chapter>
  <hcontainer>
    <paragraph />
  </hcontainer>
  <article>
    <paragraph />
  </article>
</chapter>
```

Hintergrund: In den Bestandsdaten enthalten Gliederungselemente teils freien Text (z. B. einleitende Absätze, Tabellen oder Formulartexte), der ansonsten nicht abgebildet werden könnte.

### Erlauben von `akn:blockList` in `akn:note`

Innerhalb von `akn:note` wurden `akn:blockList` erlaubt. Hintergrund: Innerhalb der Bestandsdaten existieren verschalchtelte Aufzählungen, die eine entsprechende Key-Value Struktur erfordern.

### Schemata aktualisieren und prüfen

Voraussetzung: `make` und `docker`/`podman` Compose.
Änderungen an den Patches in [`scripts/ldmlde-patches`](../scripts/ldmlde-patches)
vornehmen und vom Repository-Stammverzeichnis aus ausführen:

```bash
make -C scripts patch-ldml
make -C scripts verify-ldml
```

`patch` erzeugt die Schemata neu. `verify` prüft sie ohne Änderungen und liefert
bei fehlenden oder abweichenden Dateien Exit-Code 1. Anschließend den Diff prüfen
und die Patch- und Schemaänderungen gemeinsam committen.
Der Pre-Commit-Hook führt `verify` bei Änderungen an betroffenen Dateien automatisch aus.

## Von LDML.de unabhängige Schemata

### norm-work-metadata.xsd

Beinhaltet Metadaten auf Werkebene des FRBR-Modells.

### norm-metadata.xsd

Beinhaltet die RIS-spezifischen Metadaten für Normen (Namespace `http://rechtsinformationen.bund.de/schema/norm-metadata/0.1`).

#### `dokumenttypen`

Enthält die Dokumenttypen einer Norm. Das Element wird bei der Migration aus den Bestandsdaten befüllt und steht im jeweiligen Dokument (Rechtsetzungsdokument, Regelungstext, Anlage etc.).

```xml
<ris:dokumenttypen domainTerm="Dokumenttypen">
  <ris:dokumenttyp
    domainTerm="Dokumenttyp"
  >Gesetz im formellen Sinne</ris:dokumenttyp>
</ris:dokumenttypen>
```

- `dokumenttypen`: optional, höchstens einmal; steht nach `textnachweis-geltung-ab` und vor `gegenstandslos`. Mindestens ein `dokumenttyp` ist erforderlich.
- `dokumenttyp`: nicht-leerer Text mit der Bezeichnung des Dokumenttyps mit `domainTerm` als erforderliches Attribut.
- Die Bezeichnungen stammen aus der Wertetabelle „Dokumenttyp“ (`ris-lookup-tables.document_type`).
- Das Attribut `manuell` der Eingangsdaten wird aktuell nicht berücksichtigt.

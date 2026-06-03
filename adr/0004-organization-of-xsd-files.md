# 4. Organization of XSD files

Date: 2026-06-03

## Status

Accepted

## Context

A single XSD file covering all document types and namespaces would become very large and hard to maintain.
[LegalDocML.de](https://gitlab.opencode.de/bmi/e-gesetzgebung/ldml_de) uses a multi-file approach, splitting base schemas from document-type-specific restrictions.

## Decision

The XSD files are split into multiple files and organized in the following layers:

### 1. Entry point schemas (`xsd/{document-type}.xsd`)

One entry point schema per document type (e.g. `caselaw-decision.xsd`, `adm.xsd`, `literature-sli.xsd`). These are the files that should be used for validation. Each entry point schema:

- targets the LDML namespace (`http://docs.oasis-open.org/legaldocml/ns/akn/3.0`),
- uses `xs:redefine` on `akn/akomantoso30.xsd` to restrict the AKN types to exactly the elements required for that document type (e.g. allowing only `akn:judgment` for caselaw decisions), and
- imports the corresponding metadata schema for the RIS namespace.

### 2. Document-type metadata schemas (`xsd/{document-type}-metadata.xsd`)

One metadata schema per document type (e.g. `caselaw-decision-metadata.xsd`). Each metadata schema:

- targets the RIS namespace (`http://rechtsinformationen.bund.de/schema/ris/0.1`),
- uses `xs:redefine` on `ris/ris.xsd` to restrict the generic `ris:meta` and other shared types to the exact metadata elements required for that document type (mandatory vs. optional fields, allowed values, etc.).

### 3. RIS namespace base schema (`xsd/ris/`)

- `ris.xsd` — the central base schema for the RIS namespace. Defines the open `ris:meta` and all shared types (courts, file numbers, references, short texts, ...). It uses `xs:include` to pull in all document-type–specific additions:
  - `adm.xsd` — types specific to administrative directives (_Verwaltungsvorschriften_)
  - `caselaw-decision.xsd` — types specific to caselaw decisions (_Entscheidungen_)
  - `caselaw-pending-proceeding.xsd` — types specific to pending proceedings (_Anhängige Verfahren_)
  - `sli.xsd` — types specific to independent literature (_selbstständige Literatur_)
  - `uli.xsd` — types specific to dependent literature (_unselbstständige Literatur_)
- `domain-term.xsd` — the `ris:domainTerm` simple type, included by `ris.xsd`.

### 4. LDML schema (`xsd/akn/`)

The Unmodified LDML schema.

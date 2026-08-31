#!/bin/bash

set -ex

SCRIPTS_DIR=$(dirname "$(realpath "$0")")
ROOT_DIR=$(realpath "$SCRIPTS_DIR/..")
TEMP_DIR="$ROOT_DIR/temp"
TEMP_LDMLDE_DIR="$TEMP_DIR/ldml_de"
TEMP_OUTPUT_DIR="$TEMP_DIR/out"

trap 'rm -rf "$TEMP_DIR"' EXIT
mkdir -p "$TEMP_DIR"

echo  "Clone LDML.de specification (Grammatiken folder only) …"
git clone --filter=blob:none --no-checkout https://gitlab.opencode.de/bmi/e-gesetzgebung/ldml_de.git "$TEMP_LDMLDE_DIR"
cd "$TEMP_LDMLDE_DIR"
git sparse-checkout set Grammatiken
git fetch --depth=1 origin a654f19fa6182ec8dabbb9bcc0d826ab07ac54f9 # 1.9.0
git checkout a654f19fa6182ec8dabbb9bcc0d826ab07ac54f9

cd "$SCRIPTS_DIR"

echo "Transform files"
mkdir -p "$TEMP_OUTPUT_DIR"
xsltproc "ldmlde/norm-baukasten.xsl" "$TEMP_LDMLDE_DIR/Grammatiken/legalDocML.de-baukasten.xsd" > "$TEMP_OUTPUT_DIR/norm-baukasten.xsd"
xsltproc "ldmlde/norm-rechtsetzungsdokument.xsl" "$TEMP_LDMLDE_DIR/Grammatiken/legalDocML.de-rechtsetzungsdokument.xsd" > "$TEMP_OUTPUT_DIR/norm-rechtsetzungsdokument.xsd"
xsltproc "ldmlde/norm-regelungstext.xsl" "$TEMP_LDMLDE_DIR/Grammatiken/legalDocML.de-regelungstext.xsd" > "$TEMP_OUTPUT_DIR/norm-regelungstext.xsd"
xsltproc "ldmlde/norm-offenestruktur.xsl" "$TEMP_LDMLDE_DIR/Grammatiken/legalDocML.de-offenestruktur.xsd" > "$TEMP_OUTPUT_DIR/norm-offenestruktur.xsd"
xsltproc "ldmlde/norm-sonstigerveroeffentlichungstext.xsl" "$TEMP_LDMLDE_DIR/Grammatiken/legalDocML.de-sonstigerveroeffentlichungstext.xsd" > "$TEMP_OUTPUT_DIR/norm-sonstigerveroeffentlichungstext.xsd"
xsltproc "ldmlde/norm-metadaten-rechtsetzungsdokument.xsl" "$TEMP_LDMLDE_DIR/Grammatiken/legalDocML.de-metadaten-rechtsetzungsdokument.xsd" > "$TEMP_OUTPUT_DIR/norm-metadaten-rechtsetzungsdokument.xsd"
xsltproc "ldmlde/norm-metadaten-regelungstext.xsl" "$TEMP_LDMLDE_DIR/Grammatiken/legalDocML.de-metadaten-regelungstext.xsd" > "$TEMP_OUTPUT_DIR/norm-metadaten-regelungstext.xsd"
xsltproc "ldmlde/norm-metadaten-sonstiger-veroeffentlichungstext.xsl" "$TEMP_LDMLDE_DIR/Grammatiken/legalDocML.de-metadaten-sonstiger-veroeffentlichungstext.xsd" > "$TEMP_OUTPUT_DIR/norm-metadaten-sonstiger-veroeffentlichungstext.xsd"

xsltproc --stringparam merge "$TEMP_LDMLDE_DIR/Grammatiken/legalDocML.de-frbr-metadaten-facetten-konsolidierte-fassung.sch" \
  "ldmlde/norm.sch.xsl"  \
  "$TEMP_LDMLDE_DIR/Grammatiken/legalDocML.de.sch" > "$TEMP_OUTPUT_DIR/norm-shared.sch"

echo "Copy transformed files to the schema directory…"
mkdir -p "$ROOT_DIR/xsd/norm"
rm -Rf "$ROOT_DIR/xsd/norm"/*.xsd
rm -Rf "$ROOT_DIR/xsd/norm"/*.sch
cp -R "$TEMP_OUTPUT_DIR"/* "$ROOT_DIR/xsd/norm/"

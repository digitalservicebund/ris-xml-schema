#!/bin/bash

set -ex

SCRIPTS_DIR=$(dirname "$(realpath "$0")")
ROOT_DIR=$(realpath "$SCRIPTS_DIR/..")
PATCHES_DIR="$SCRIPTS_DIR/ldmlde-patches"
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

XSD_TYPES=(
    "baukasten"
    "rechtsetzungsdokument"
    "regelungstext"
    "offenestruktur"
    "sonstigerveroeffentlichungstext"
    "metadaten-rechtsetzungsdokument"
    "metadaten-regelungstext"
    "metadaten-sonstiger-veroeffentlichungstext"
)

for type in "${XSD_TYPES[@]}"; do
    xsltproc \
        "$PATCHES_DIR/norm-${type}.xsl" \
        "$TEMP_LDMLDE_DIR/Grammatiken/legalDocML.de-${type}.xsd" \
        > "$TEMP_OUTPUT_DIR/norm-${type}.xsd"
done

SCH_TYPES=(
    ".sch"
    "-frbr-metadaten-facetten-konsolidierte-fassung.sch"
)

for sch in "${SCH_TYPES[@]}"; do
    xsltproc "$PATCHES_DIR/norm.sch.xsl" \
             "$TEMP_LDMLDE_DIR/Grammatiken/legalDocML.de${sch}" \
             > "$TEMP_OUTPUT_DIR/norm${sch}"
done

echo "Copy transformed files to the schema directory…"
mkdir -p "$ROOT_DIR/xsd/norm"
rm -rf "$ROOT_DIR/xsd/norm"/norm-*.xsd
rm -rf "$ROOT_DIR/xsd/norm"/norm-*.sch
cp -r "$TEMP_OUTPUT_DIR"/* "$ROOT_DIR/xsd/norm/"

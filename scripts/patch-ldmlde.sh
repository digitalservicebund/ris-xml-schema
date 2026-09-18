#!/bin/bash

set -eo pipefail

SCRIPTS_DIR=$(dirname "$(realpath "$0")")
ROOT_DIR=$(realpath "$SCRIPTS_DIR/..")
PATCHES_DIR="$SCRIPTS_DIR/ldmlde-patches"
TEMP_DIR="$PATCHES_DIR/temp"
TEMP_LDMLDE_DIR="$TEMP_DIR/ldml_de"
TEMP_OUTPUT_DIR="$TEMP_DIR/out"

rm -rf "$TEMP_DIR"
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
rm -rf "$ROOT_DIR/xsd/norm-*.xsd"
rm -rf "$ROOT_DIR/xsd/norm*.sch"
rm -rf "$ROOT_DIR/xsd/legalDocML.de"
cp -r "$TEMP_OUTPUT_DIR"/* "$ROOT_DIR/xsd/"

echo "Copy original files to the schema directory…"
mkdir -p "$ROOT_DIR/xsd/legalDocML.de"

ORIGINAL_XSD_TYPES=(
    "legalDocML.de-metadaten-rechtsetzungsdokument"
    "legalDocML.de-metadaten-regelungstext"
    "legalDocML.de-metadaten-sonstiger-veroeffentlichungstext"
)

for type in "${ORIGINAL_XSD_TYPES[@]}"; do
    cp "$TEMP_LDMLDE_DIR/Grammatiken/${type}.xsd" "$ROOT_DIR/xsd/legalDocML.de/"
done

echo "Apply formatting to the copied files…"
npm run format:fix

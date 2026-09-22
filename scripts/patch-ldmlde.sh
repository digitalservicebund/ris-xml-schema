#!/bin/bash

set -eo pipefail

SCRIPTS_DIR=$(dirname "$(realpath "$0")")
ROOT_DIR=$(realpath "$SCRIPTS_DIR/..")
PATCHES_DIR="$SCRIPTS_DIR/ldmlde-patches"
TEMP_DIR="$PATCHES_DIR/temp"
TEMP_LDMLDE_DIR="$TEMP_DIR/ldml_de"
TEMP_OUTPUT_DIR="$TEMP_DIR/out"

PERSISTENT_TEMP_DIR="$ROOT_DIR/temp"
if [ ! -d "$PERSISTENT_TEMP_DIR" ]; then
    mkdir -p "$PERSISTENT_TEMP_DIR"
fi

SAXON_DIR="$PERSISTENT_TEMP_DIR/SaxonHE13-0J"
if [ ! -d "$SAXON_DIR" ]; then
    echo "Downloading SaxonHE13-0J..."
    curl -L -o "$PERSISTENT_TEMP_DIR/SaxonHE13-0J.zip" "https://downloads.saxonica.com/SaxonJ/HE/13/SaxonHE13-0J.zip"
    unzip "$PERSISTENT_TEMP_DIR/SaxonHE13-0J.zip" -d "$SAXON_DIR"
    rm "$PERSISTENT_TEMP_DIR/SaxonHE13-0J.zip"
fi

SCHXSLT2_DIR="$PERSISTENT_TEMP_DIR/schxslt2-1.11.2"
if [ ! -d "$SCHXSLT2_DIR" ]; then
    echo "Downloading schxslt2-1.11.2..."
    curl -L -o "$PERSISTENT_TEMP_DIR/schxslt2-1.11.2.zip" "https://codeberg.org/SchXslt/schxslt2/releases/download/v1.11.2/schxslt2-1.11.2.zip"
    unzip "$PERSISTENT_TEMP_DIR/schxslt2-1.11.2.zip" -d "$SCHXSLT2_DIR"
    rm "$PERSISTENT_TEMP_DIR/schxslt2-1.11.2.zip"
fi
# --------------------------------------------------------------------------------------------

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

echo "Compiling Schematron…"
TRANSPILE_XSL="$SCHXSLT2_DIR/schxslt2-1.11.2/transpile.xsl"

# Ausschließlich die Hauptdatei norm.sch in xsl umwandeln
java -jar "$SAXON_DIR/saxon-he-13.0.jar" \
  -s:"$TEMP_OUTPUT_DIR/norm.sch" \
  -xsl:"$TRANSPILE_XSL" \
  -o:"$TEMP_OUTPUT_DIR/norm.sch.xsl"
# ---------------------------------------------------------------------------------

echo "Copy transformed files to the schema directory…"
# exclude norm-metadata from removal
find "$ROOT_DIR/xsd" -maxdepth 1 -type f -name "norm-*.xsd" ! -name "norm-metadata.xsd" -delete
rm -rf "$ROOT_DIR"/xsd/norm*.sch
rm -rf "$ROOT_DIR"/xsd/norm*.sch.xsl
rm -rf "$ROOT_DIR"/xsd/legalDocML.de

cp -r "$TEMP_OUTPUT_DIR"/* "$ROOT_DIR"/xsd/

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

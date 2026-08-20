#!/bin/bash

set -ex

SCRIPTS_DIR=$(dirname "$(realpath $0)")
ROOT_DIR=$(realpath "$SCRIPTS_DIR/..")
TEMP_DIR="$ROOT_DIR/temp"
TEMP_LDMLDE_DIR="$TEMP_DIR/ldml_de"

mkdir -p $TEMP_DIR

echo "\nClone LDML.de specification…"
if [[ ! -d "$TEMP_LDMLDE_DIR" ]]; then
  git clone --depth=1 https://gitlab.opencode.de/bmi/e-gesetzgebung/ldml_de.git $TEMP_LDMLDE_DIR
fi

cd $TEMP_LDMLDE_DIR
git fetch --depth=1 origin a654f19fa6182ec8dabbb9bcc0d826ab07ac54f9 # 1.9.0
git checkout a654f19fa6182ec8dabbb9bcc0d826ab07ac54f9

cd $SCRIPTS_DIR

echo "\nTransform files"
xsltproc ldmlde/baukasten.xsl $TEMP_LDMLDE_DIR/Grammatiken/legalDocML.de-baukasten.xsd > "$TEMP_DIR/shared.xsd"
xsltproc ldmlde/rechtsetzungsdokument.xsl $TEMP_LDMLDE_DIR/Grammatiken/legalDocML.de-rechtsetzungsdokument.xsd > "$TEMP_DIR/rechtsetzungsdokument.xsd"
xsltproc ldmlde/regelungstext.xsl $TEMP_LDMLDE_DIR/Grammatiken/legalDocML.de-regelungstext.xsd > "$TEMP_DIR/regelungstext.xsd"
xsltproc ldmlde/offenestruktur.xsl $TEMP_LDMLDE_DIR/Grammatiken/legalDocML.de-offenestruktur.xsd > "$TEMP_DIR/offenestruktur.xsd"
xsltproc ldmlde/sonstigerveroeffentlichungstext.xsl $TEMP_LDMLDE_DIR/Grammatiken/legalDocML.de-sonstigerveroeffentlichungstext.xsd > "$TEMP_DIR/sonstigerveroeffentlichungstext.xsd"

mkdir -p "$TEMP_DIR/metadata"
xsltproc ldmlde/legalDocML.de-metadaten-rechtsetzungsdokument.xsl $TEMP_LDMLDE_DIR/Grammatiken/legalDocML.de-metadaten-rechtsetzungsdokument.xsd > "$TEMP_DIR/metadata/rechtsetzungsdokument.xsd"
xsltproc ldmlde/legalDocML.de-metadaten-regelungstext.xsl $TEMP_LDMLDE_DIR/Grammatiken/legalDocML.de-metadaten-regelungstext.xsd > "$TEMP_DIR/metadata/regelungstext.xsd"
xsltproc ldmlde/legalDocML.de-metadaten-sonstiger-veroeffentlichungstext.xsl $TEMP_LDMLDE_DIR/Grammatiken/legalDocML.de-metadaten-sonstiger-veroeffentlichungstext.xsd > "$TEMP_DIR/metadata/sonstiger-veroeffentlichungstext.xsd"

xsltproc --stringparam merge "$TEMP_DIR/ldml_de/Grammatiken/legalDocML.de-frbr-metadaten-facetten-konsolidierte-fassung.sch" \
  ldmlde/legalDocML.de.sch.xsl  \
  $TEMP_LDMLDE_DIR/Grammatiken/legalDocML.de.sch > "$TEMP_DIR/shared.sch"

echo "\nCopy transformed files to the schema directory…"
mkdir -p $ROOT_DIR/xsd/norm
mkdir -p $ROOT_DIR/xsd/norm/metadata
rm -Rf $ROOT_DIR/xsd/norm/*.xsd
rm -Rf $ROOT_DIR/xsd/norm/*.sch
rm -Rf $ROOT_DIR/xsd/norm/metadata/*.xsd
cp $TEMP_DIR/*.xsd $ROOT_DIR/xsd/norm/
cp $TEMP_DIR/*.sch $ROOT_DIR/xsd/norm/
cp $TEMP_DIR/metadata/*.xsd $ROOT_DIR/xsd/norm/metadata/

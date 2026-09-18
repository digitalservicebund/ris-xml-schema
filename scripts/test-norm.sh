#!/bin/bash

set -eo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>" >&2
    exit 1
fi

TARGET_DIR="$1"
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: '$TARGET_DIR' is not a directory" >&2
    exit 1
fi

SCRIPTS_DIR=$(dirname "$(realpath "$0")")
ROOT_DIR=$(realpath "$SCRIPTS_DIR/..")
XSD_DIR=$(realpath "$ROOT_DIR/xsd")

TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

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

echo "Compiling Schematron…"
TRANSPILE_XSL="$SCHXSLT2_DIR/schxslt2-1.11.2/transpile.xsl"
SCHEMATRON_XSL="$TEMP_DIR/norm.sch.xsl"
java -jar "$SAXON_DIR/saxon-he-13.0.jar" \
  -s:"$XSD_DIR/norm.sch" \
  -xsl:"$TRANSPILE_XSL" \
  -o:"$SCHEMATRON_XSL"

# Since xmllint can only validate against a single schema, we'll need to create temporary
# schemas that combine all other schemas.
REGELUNGSTEXT_COMBINED_XSD="$TEMP_DIR/regelungstext.xsd"
cat > "$REGELUNGSTEXT_COMBINED_XSD" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:import
    namespace="http://rechtsinformationen.bund.de/schema/norm/0.1"
    schemaLocation="$XSD_DIR/norm-regelungstext.xsd"
  />
  <xs:import
    namespace="http://MetadatenRegelungstext.LegalDocML.de/1.9/"
    schemaLocation="$XSD_DIR/legalDocML.de/legalDocML.de-metadaten-regelungstext.xsd"
  />
  <xs:import
    namespace="http://rechtsinformationen.bund.de/schema/norm-metadata/0.1"
    schemaLocation="$XSD_DIR/norm-metadata.xsd"
  />
</xs:schema>
EOF

ANLAGE_REGELUNGSTEXT_COMBINED_XSD="$TEMP_DIR/anlage-regelungstext.xsd"
cat > "$ANLAGE_REGELUNGSTEXT_COMBINED_XSD" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:import
    namespace="http://rechtsinformationen.bund.de/schema/norm/0.1"
    schemaLocation="$XSD_DIR/norm-offenestruktur.xsd"
  />
  <xs:import
    namespace="http://rechtsinformationen.bund.de/schema/norm-metadata/0.1"
    schemaLocation="$XSD_DIR/norm-metadata.xsd"
  />
</xs:schema>
EOF

RECHTSETZUNGSDOKUMENT_COMBINED_XSD="$TEMP_DIR/rechtsetzungsdokument.xsd"
cat > "$RECHTSETZUNGSDOKUMENT_COMBINED_XSD" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:import
    namespace="http://rechtsinformationen.bund.de/schema/norm/0.1"
    schemaLocation="$XSD_DIR/norm-rechtsetzungsdokument.xsd"
  />
  <xs:import
    namespace="http://MetadatenRechtsetzungsdokument.LegalDocML.de/1.9/"
    schemaLocation="$XSD_DIR/legalDocML.de/legalDocML.de-metadaten-rechtsetzungsdokument.xsd"
  />
  <xs:import
    namespace="http://rechtsinformationen.bund.de/schema/norm-metadata/0.1"
    schemaLocation="$XSD_DIR/norm-metadata.xsd"
  />
</xs:schema>
EOF

# In order to test the schema against XML files that still use the original LDML.de namespaces,
# we remap them to the RIS namespaces using sed.
NAMESPACE_MAP=(
  "http://Inhaltsdaten.LegalDocML.de/1.9/"
  "http://rechtsinformationen.bund.de/schema/norm/0.1"

  "http://MetadatenRIS.LegalDocML.de/1.9/"
  "http://rechtsinformationen.bund.de/schema/norm-metadata/0.1"
)

SED_SCRIPT=""
for ((index = 0; index < ${#NAMESPACE_MAP[@]}; index += 2)); do
  old_ns="${NAMESPACE_MAP[index]}"
  new_ns="${NAMESPACE_MAP[index + 1]}"

  SED_SCRIPT+="s#${old_ns}#${new_ns}#g;"
done

while IFS= read -r -d '' file; do
    echo "Validating '$file'"

    filename=$(basename "$file")
    case "$filename" in
        rechtsetzungsdokument*)
            schema="$RECHTSETZUNGSDOKUMENT_COMBINED_XSD"
            ;;
        regelungstext*)
            schema="$REGELUNGSTEXT_COMBINED_XSD"
            ;;
        anlage-regelungstext*)
            schema="$ANLAGE_REGELUNGSTEXT_COMBINED_XSD"
            ;;
        *)
            echo "No matching schema for '$filename'" >&2
            exit 1
            ;;
    esac

    PROCESSED_FILE="$TEMP_DIR/$filename"
    sed "$SED_SCRIPT" "$file" > "$PROCESSED_FILE"

    echo "Validating XML Schema"
    xmllint --noout --schema "$schema" "$PROCESSED_FILE"

    echo "Validating Schematron"
    REPORT_SVRL="$TEMP_DIR/$filename.svrl"
    java -jar "$SAXON_DIR/saxon-he-13.0.jar" \
      -s:"$PROCESSED_FILE" \
      -xsl:"$SCHEMATRON_XSL" \
      -o:"$REPORT_SVRL"

    FAILED_COUNT=$(xmllint --xpath "count(//*[local-name()='failed-assert'])" "$REPORT_SVRL" 2>/dev/null || echo 0)
    if [ "$FAILED_COUNT" -gt 0 ]; then
        echo "Schematron validation failed for '$file':" >&2
        xmllint --xpath "//*[local-name()='failed-assert']" "$REPORT_SVRL" >&2
        echo >&2
        exit 1
    fi

    echo -e "\n\n"
done < <(find "$TARGET_DIR" -type f -name "*.xml" -print0)

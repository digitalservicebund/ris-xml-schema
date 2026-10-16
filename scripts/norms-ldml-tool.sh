#!/bin/bash

# CLI tool for patching and verifying LDML.de' schemas
# Needs to be run through the `Makefile` using the `patch-ldml` or `verify-ldml` targets

set -euo pipefail

log() {
    printf '\033[1;30m[*] %s\n\033[0;37m' "$*"
}

success() {
    printf '\033[1;32m[✓] %s\n\033[0;37m' "$*"
}

error() {
    printf '\033[1;31m[✗] %s\n\033[0;37m' "$*" >&2
}

apply_xsd_patches() {
    local patch filename
    log "Apply XSD patches"
    for patch in "$PATCHES_DIR"/norm-*.xsl; do
        filename=$(basename "$patch" .xsl)
        printf '%s -> %s (patch: %s)\n' \
            "${filename/#norm-/legalDocML.de-}.xsd" "$filename.xsd" "$(basename "$patch")"
        xsltproc "$patch" \
            "$SOURCE_DIR/${filename/#norm-/legalDocML.de-}.xsd" \
            > "$OUTPUT_DIR/$filename.xsd"
    done
}

apply_schematron_patches() {
    local filename
    local -a schematron_files=(
        "legalDocML.de.sch"
        "legalDocML.de-frbr-metadaten-facetten-konsolidierte-fassung.sch"
    )

    log "Apply Schematron patches"
    for filename in "${schematron_files[@]}"; do
        printf '%s -> %s (patch: norm.sch.xsl)\n' "$filename" "${filename/#legalDocML.de/norm}"
        xsltproc "$PATCHES_DIR/norm.sch.xsl" \
            "$SOURCE_DIR/$filename" \
            > "$OUTPUT_DIR/${filename/#legalDocML.de/norm}"
    done
}

compile_schematron() {
    log "Compile Schematron"
    java -jar /opt/saxon/saxon-he-13.0.jar \
        -t \
        -s:"$OUTPUT_DIR/norm.sch" \
        -xsl:/opt/schxslt2/schxslt2-1.11.2/transpile.xsl \
        -o:"$OUTPUT_DIR/norm.sch.xsl"
}

copy_metadata_schemas() {
    local type
    local -a metadata_types=(
        "rechtsetzungsdokument"
        "regelungstext"
        "sonstiger-veroeffentlichungstext"
    )

    log "Copy unchanged metadata schemas"
    for type in "${metadata_types[@]}"; do
        cp -v "$SOURCE_DIR/legalDocML.de-metadaten-${type}.xsd" \
            "$OUTPUT_DIR/legalDocML.de/"
    done
}

format_generated_files() (
    log "Format generated files"
    cp "$ROOT_DIR/package.json" "$ROOT_DIR/prettier.config.ts" "$ROOT_DIR/.prettierignore" "$TEMP_DIR/"
    ln -s "$SCRIPT_ROOT/node_modules" "$TEMP_DIR/node_modules"
    cd "$TEMP_DIR"
    NO_COLOR=1 npm run format:fix
)

patch_schemas() {
    log "Copy generated schemas to $ROOT_DIR/xsd"
    mkdir -p "$ROOT_DIR/xsd"
    rm -rf "$ROOT_DIR/xsd/legalDocML.de"
    cp -rv "$OUTPUT_DIR/." "$ROOT_DIR/xsd/"
    success "Patch completed successfully"
}

verify_schemas() (
    log "Verify schemas in $ROOT_DIR/xsd"
    cd "$OUTPUT_DIR"
    # Verifies that the generated schemas are equivalent to the ones in the output directory
    find . -type f -exec sha256sum {} + > "$TEMP_DIR/checksums"
    if (cd "$ROOT_DIR/xsd" && sha256sum --check "$TEMP_DIR/checksums"); then
        success "Verification completed successfully"
        exit 0
    fi

    {
        echo
        error "VERIFICATION FAILED: Generated schemas are out of date."
        error "Regenerate them with \"make -C scripts patch-ldml\""
    } >&2
    exit 1
)

MODE=${1:-}
if [[ $# -ne 1 ]] || [[ "$MODE" != patch && "$MODE" != verify ]]; then
    error "Usage: $0 <patch|verify>"
    exit 2
fi

SCRIPT_ROOT=$(realpath "$(dirname "$0")/..")
ROOT_DIR=${GITHUB_WORKSPACE:-$SCRIPT_ROOT}
PATCHES_DIR="$ROOT_DIR/scripts/ldmlde-patches"
SOURCE_DIR=/opt/ldml-de/Grammatiken
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT
OUTPUT_DIR="$TEMP_DIR/xsd"

mkdir -p "$OUTPUT_DIR/legalDocML.de"

apply_xsd_patches
apply_schematron_patches
compile_schematron
copy_metadata_schemas
format_generated_files

case "$MODE" in
    patch) patch_schemas ;;
    verify) verify_schemas ;;
esac

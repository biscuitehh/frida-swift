#!/usr/bin/env bash
#
# gh-dl-release! It works!
# 
# This script downloads an asset from latest or specific Github release of a
# private repo. Feel free to extract more of the variables into command line
# parameters.
#
# PREREQUISITES
#
# curl, jq
#
# USAGE
#
# Set all the variables inside the script & make sure you chmod +x it
#
# NOTE: This script is designed to just handle Frida Downloads
#

FRIDA_VERSION="12.8.12"
REPO="frida/frida"
FILE="frida-core-devkit-${FRIDA_VERSION}-macos-x86_64.tar.xz"      # the name of your release asset file, e.g. build.tar.gz
VERSION="latest"                       # tag name or the word "latest"
GITHUB="https://api.github.com"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"

# Ensure that the GITHUB_TOKEN secret is included
if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Set the GITHUB_TOKEN env variable."
  exit 1
fi

# Ensure that the OUTPUT_DIR is included
if [[ -z "$OUTPUT_DIR" ]]; then
  echo "Set the OUTPUT_DIR env variable."
  exit 1
fi

alias errcho='>&2 echo'

function gh_curl() {
  curl -H "${AUTH_HEADER}" \
  	   -H "Accept: application/vnd.github.v3.raw" \
       $@
}

if [ "$VERSION" = "latest" ]; then
  # Github should return the latest release first.
  parser=".[0].assets | map(select(.name == \"$FILE\"))[0].id"
else
  parser=". | map(select(.tag_name == \"$VERSION\"))[0].assets | map(select(.name == \"$FILE\"))[0].id"
fi;

asset_id=`gh_curl -s $GITHUB/repos/$REPO/releases | jq "$parser"`
if [ "$asset_id" = "null" ]; then
  errcho "ERROR: version not found $VERSION"
  exit 1
fi;

ASSET_URL="https://api.github.com/repos/${REPO}/releases/assets/${asset_id}"

curl \
  -L \
  -H "${AUTH_HEADER}" \
  -H "Accept:application/octet-stream" \
  -o "${OUTPUT_DIR}/frida.tar.xz" \
  "${ASSET_URL}"

# Extract our Frida Payload
tar xf "${OUTPUT_DIR}/frida.tar.xz" -C "${OUTPUT_DIR}"
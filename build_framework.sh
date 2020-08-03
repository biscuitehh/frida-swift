#!/bin/bash

## New Frida Download Tool

FRIDA_VERSION=12.11.4

# Don't change these
FRIDA_MACOS_INTEL_URL="https://github.com/frida/frida/releases/download/${FRIDA_VERSION}/frida-core-devkit-${FRIDA_VERSION}-macos-x86_64.tar.xz"
FRIDA_MACOS_ARM64E_URL="https://github.com/frida/frida/releases/download/${FRIDA_VERSION}/frida-core-devkit-${FRIDA_VERSION}-macos-arm64e.tar.xz"
FRIDA_IOS_ARM64E_URL="https://github.com/frida/frida/releases/download/${FRIDA_VERSION}/frida-core-devkit-${FRIDA_VERSION}-ios-arm64e.tar.xz"
FRIDA_IOS_SIMULATOR_URL="https://github.com/frida/frida/releases/download/${FRIDA_VERSION}/frida-core-devkit-${FRIDA_VERSION}-ios-x86_64.tar.xz"

ARTIFACTS_DIR="./artifacts"
OUTPUT_DIR="./tmp"
RESOURCES_DIR="./Resources"

# Prep CFrida
mkdir -p "${OUTPUT_DIR}"
mkdir -p "${ARTIFACTS_DIR}"
mkdir -p "${OUTPUT_DIR}/macos-x86_64"
mkdir -p "${OUTPUT_DIR}/macos-arm64e"
mkdir -p "${OUTPUT_DIR}/ios-arm64e"
mkdir -p "${OUTPUT_DIR}/ios-x86_64"

# Download macOS (Intel, x86_64)
curl -L ${FRIDA_MACOS_INTEL_URL} \
	-H "Accept:application/octet-stream" \
  	-o "${OUTPUT_DIR}/frida-temp-macos-x86_64.xz"

# Download macOS (arm64e)
curl -L ${FRIDA_MACOS_ARM64E_URL} \
	-H "Accept:application/octet-stream" \
  	-o "${OUTPUT_DIR}/frida-temp-macos-arm64e.xz"

# Download iOS (arm64e)
curl -L ${FRIDA_IOS_ARM64E_URL} \
	-H "Accept:application/octet-stream" \
  	-o "${OUTPUT_DIR}/frida-temp-ios-arm64e.xz"

# Download iOS (Simulator, x86_64)
curl -L ${FRIDA_IOS_SIMULATOR_URL} \
	-H "Accept:application/octet-stream" \
  	-o "${OUTPUT_DIR}/frida-temp-ios-x86_64.xz"

# Crack our libraries open
tar -xf "${OUTPUT_DIR}/frida-temp-macos-x86_64.xz" -C "${OUTPUT_DIR}/macos-x86_64/"
mkdir -p "${OUTPUT_DIR}/macos-x86_64/Headers"
cp "${OUTPUT_DIR}/macos-x86_64/frida-core.h" "${OUTPUT_DIR}/macos-x86_64/Headers"
cp "${RESOURCES_DIR}/module.modulemap" "${OUTPUT_DIR}/macos-x86_64/Headers"

tar -xf "${OUTPUT_DIR}/frida-temp-macos-arm64e.xz" -C "${OUTPUT_DIR}/macos-arm64e/"
mkdir -p "${OUTPUT_DIR}/macos-arm64e/Headers"
cp "${OUTPUT_DIR}/macos-arm64e/frida-core.h" "${OUTPUT_DIR}/macos-arm64e/Headers"
cp "${RESOURCES_DIR}/module.modulemap" "${OUTPUT_DIR}/macos-arm64e/Headers"

tar -xf "${OUTPUT_DIR}/frida-temp-ios-arm64e.xz" -C "${OUTPUT_DIR}/ios-arm64e/"
mkdir -p "${OUTPUT_DIR}/ios-arm64e/Headers"
cp "${OUTPUT_DIR}/ios-arm64e/frida-core.h" "${OUTPUT_DIR}/ios-arm64e/Headers"
cp "${RESOURCES_DIR}/module.modulemap" "${OUTPUT_DIR}/ios-arm64e/Headers"

tar -xf "${OUTPUT_DIR}/frida-temp-ios-x86_64.xz" -C "${OUTPUT_DIR}/ios-x86_64/"
mkdir -p "${OUTPUT_DIR}/ios-x86_64/Headers"
cp "${OUTPUT_DIR}/ios-x86_64/frida-core.h" "${OUTPUT_DIR}/ios-x86_64/Headers"
cp "${RESOURCES_DIR}/module.modulemap" "${OUTPUT_DIR}/ios-x86_64/Headers"

# Test xcframework command
xcodebuild -create-xcframework \
	-library "${OUTPUT_DIR}/macos-x86_64/libfrida-core.a" \
	-headers "${OUTPUT_DIR}/macos-x86_64/Headers" \
	-library "${OUTPUT_DIR}/ios-arm64e/libfrida-core.a" \
	-headers "${OUTPUT_DIR}/ios-arm64e/Headers" \
	-library "${OUTPUT_DIR}/ios-x86_64/libfrida-core.a" \
	-headers "${OUTPUT_DIR}/ios-x86_64/Headers" \
 	-output "${ARTIFACTS_DIR}/CFrida.xcframework"
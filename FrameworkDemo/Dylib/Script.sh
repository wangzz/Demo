#!/bin/sh

#  Script.sh
#  Dylib
#
#  Created by wangzz on 14-6-11.
#  Copyright (c) 2014年 FOOGRY. All rights reserved.

#动态库
# Sets the target folders and the final framework product.
FMK_NAME=Dylib

# Install dir will be the final output to the framework.
# The following line create it in the root folder of the current project.
INSTALL_DIR=${SRCROOT}/Products/${FMK_NAME}.framework

# Working dir will be deleted after the framework creation.
WRK_DIR=build
DEVICE_DIR=${WRK_DIR}/Release-iphoneos/${FMK_NAME}.framework
SIMULATOR_DIR=${WRK_DIR}/Release-iphonesimulator/${FMK_NAME}.framework

# Building both architectures.
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphoneos
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphonesimulator

# Cleaning the oldest.
if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi

mkdir -p "${INSTALL_DIR}"

cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/"

# Uses the Lipo Tool to merge both binary files (i386 + armv6/armv7) into one Universal final product.
lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/${FMK_NAME}"

rm -r "${WRK_DIR}"





# Sets the target folders and the final framework product.
FMK_NAME=Test
FMK_VERSION=A
# Install dir will be the final output to the framework.
# The following line create it in the root folder of the current project.
INSTALL_DIR=${SRCROOT}/Products/${FMK_NAME}.framework

# Working dir will be deleted after the framework creation.
WRK_DIR=build
DEVICE_DIR=${WRK_DIR}/Release-iphoneos/${FMK_NAME}.framework
SIMULATOR_DIR=${WRK_DIR}/Release-iphonesimulator/${FMK_NAME}.framework

# Building both architectures.
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphoneos
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphonesimulator
# Cleaning the oldest.
if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi
# Creates and renews the final product folder.
mkdir -p "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}/Versions"
mkdir -p "${INSTALL_DIR}/Versions/${FMK_VERSION}"
mkdir -p "${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources"
mkdir -p "${INSTALL_DIR}/Versions/${FMK_VERSION}/Headers"

# Creates the internal links.
# It MUST uses relative path, otherwise will not work when the folder is copied/moved.
ln -s "${FMK_VERSION}" "${INSTALL_DIR}/Versions/Current"
ln -s "Versions/Current/Headers" "${INSTALL_DIR}/Headers"
ln -s "Versions/Current/Resources" "${INSTALL_DIR}/Resources"
ln -s "Versions/Current/${FMK_NAME}" "${INSTALL_DIR}/${FMK_NAME}"

# Copies the headers and resources files to the final product folder.
cp -R "${DEVICE_DIR}/Headers/" "${INSTALL_DIR}/Versions/${FMK_VERSION}/Headers/"
cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources/"

# Removes the binary and header from the resources folder.
rm -r "${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources/Headers""${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources/${FMK_NAME}"

# Uses the Lipo Tool to merge both binary files (i386 + armv6/armv7) into one Universal final product.
lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/Versions/${FMK_VERSION}/${FMK_NAME}"

rm -r "${WRK_DIR}"



#静态库

# Sets the target folders and the final framework product.
FMK_NAME=busnavi

# Install dir will be the final output to the framework.
# The following line create it in the root folder of the current project.
INSTALL_DIR=${SRCROOT}/Products

# Working dir will be deleted after the framework creation.
WRK_DIR=build
DEVICE_DIR=${WRK_DIR}/Release-iphoneos
SIMULATOR_DIR=${WRK_DIR}/Release-iphonesimulator

# Building both architectures.
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphoneos
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphonesimulator

# Cleaning the oldest.
if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi

mkdir -p "${INSTALL_DIR}"

# Uses the Lipo Tool to merge both binary files (i386 + armv6/armv7) into one Universal final product.
lipo -create "${DEVICE_DIR}/lib${FMK_NAME}.a" "${SIMULATOR_DIR}/lib${FMK_NAME}.a" -output "${INSTALL_DIR}/lib${FMK_NAME}.a"

rm -r "${WRK_DIR}"
























# Sets the target folders and the final framework product.
FMK_NAME=${PROJECT_NAME}

# Install dir will be the final output to the framework.
# The following line create it in the root folder of the current project.
INSTALL_DIR=${SRCROOT}/Products/${FMK_NAME}.framework

# Working dir will be deleted after the framework creation.
WRK_DIR=build
DEVICE_DIR=${WRK_DIR}/Release-iphoneos/${FMK_NAME}.framework
SIMULATOR_DIR=${WRK_DIR}/Release-iphonesimulator/${FMK_NAME}.framework

# -configuration ${CONFIGURATION}
# Clean and Building both architectures.
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphoneos clean build
xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphonesimulator clean build

# Cleaning the oldest.
if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi

mkdir -p "${INSTALL_DIR}"

cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/"

# Uses the Lipo Tool to merge both binary files (i386 + armv6/armv7) into one Universal final product.
lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/${FMK_NAME}"

rm -r "${WRK_DIR}"








#!/bin/bash -x

echo "$(tput setaf 2)"
echo Building Google Protobuf for Mac OS X / iOS.
echo Use 'tail -f build.log' to monitor progress.
echo "$(tput sgr0)"

# Set this to the minimum iOS SDK version you wish to support.
MIN_SDK_VERSION=11.0

(

PREFIX=`pwd`/out
mkdir -p ${PREFIX}/platform

EXTRA_MAKE_FLAGS="-j8"

XCODEDIR=`xcode-select --print-path`

IOS_SDK=$(xcodebuild -showsdks | grep iphoneos | sort | head -n 1 | awk '{print $NF}')
SIM_SDK=$(xcodebuild -showsdks | grep iphonesimulator | sort | head -n 1 | awk '{print $NF}')

IPHONEOS_PLATFORM=$(xcrun --sdk iphoneos --show-sdk-platform-path)
IPHONEOS_SYSROOT=$(xcrun --sdk iphoneos --show-sdk-path)

IPHONESIMULATOR_PLATFORM=$(xcrun --sdk iphonesimulator --show-sdk-platform-path)
IPHONESIMULATOR_SYSROOT=$(xcrun --sdk iphonesimulator --show-sdk-path)

CC=clang
CFLAGS="-DNDEBUG -DGOOGLE_PROTOBUF_RUNTIME_INCLUDE_BASE=\\\"libprotobuf-lite/\\\" -Os -pipe -fPIC -fno-exceptions"
CXX=clang
CXXFLAGS="${CFLAGS} -std=c++11 -stdlib=libc++"
LDFLAGS="-stdlib=libc++"
LIBS="-lc++ -lc++abi"

LIBDIR="${PREFIX}/platform"

echo "$(tput setaf 2)"
echo "####################################"
echo " Cleanup any earlier build attempts"
echo "####################################"
echo "$(tput sgr0)"

(
    if [ -d ${PREFIX} ]
    then
        rm -rf ${PREFIX}
    fi
    mkdir ${PREFIX}
    mkdir ${LIBDIR}
)

echo "$(tput setaf 2)"
echo "######################"
echo " Generate Build files"
echo "######################"
echo "$(tput sgr0)"

./autogen.sh
if [ $? -ne 0 ]
then
  echo "./autogen.sh command failed."
  exit 1
fi

echo "$(tput setaf 2)"
echo "#####################"
echo " x86_64 for Mac OS X"
echo "#####################"
echo "$(tput sgr0)"

ARCH_PREFIX=x86_64

(
    make distclean
    ./configure \
    --host=x86_64-apple-${OSX_VERSION} \
    --disable-shared \
    --enable-cross-compile \
    --prefix=${LIBDIR}/${ARCH_PREFIX} \
    --exec-prefix=${LIBDIR}/${ARCH_PREFIX} \
    "CC=${CC}" \
    "CFLAGS=${CFLAGS} \
    -arch x86_64" \
    "CXX=${CXX}" \
    "CXXFLAGS=${CXXFLAGS} \
    -arch x86_64" \
    "LDFLAGS=-arch x86_64 \
    ${LDFLAGS}" \
    "LIBS=${LIBS}"
    make ${EXTRA_MAKE_FLAGS}
    make ${EXTRA_MAKE_FLAGS} install
)

X86_64_MAC_PROTOC=${ARCH_PREFIX}/bin/protoc

echo "$(tput setaf 2)"
echo "#############################"
echo " x86_64 for iPhone Simulator"
echo "#############################"
echo "$(tput sgr0)"

ARCH_PREFIX=iossim_x86_64

(
    make distclean
    ./configure \
    --host=x86_64-apple-${OSX_VERSION} \
    --disable-shared \
    --enable-cross-compile \
    --prefix=${LIBDIR}/${ARCH_PREFIX} \
    --exec-prefix=${LIBDIR}/${ARCH_PREFIX} \
    "CFLAGS=${CFLAGS} \
    -mios-simulator-version-min=${MIN_SDK_VERSION} \
    -arch x86_64 \
    -isysroot ${IPHONESIMULATOR_SYSROOT}" \
    "CXX=${CXX}" \
    "CXXFLAGS=${CXXFLAGS} \
    -mios-simulator-version-min=${MIN_SDK_VERSION} \
    -arch x86_64 \
    -isysroot \
    ${IPHONESIMULATOR_SYSROOT}" \
    LDFLAGS="-arch x86_64 \
    -mios-simulator-version-min=${MIN_SDK_VERSION} \
    ${LDFLAGS} \
    -L${IPHONESIMULATOR_SYSROOT}/usr/lib/ \
    -L${IPHONESIMULATOR_SYSROOT}/usr/lib/system" \
    "LIBS=${LIBS}"
    make ${EXTRA_MAKE_FLAGS}
    make ${EXTRA_MAKE_FLAGS} install
)

X86_64_IOS_SIM_PROTOBUF=${ARCH_PREFIX}/lib/libprotobuf-lite.a

echo "$(tput setaf 2)"
echo "############################"
echo " arm64 for iPhone Simulator"
echo "############################"
echo "$(tput sgr0)"

ARCH_PREFIX=iossim_arm64

(
    make distclean
    ./configure \
    --host=arm \
    --disable-shared \
    --enable-cross-compile \
    --prefix=${LIBDIR}/${ARCH_PREFIX} \
    --exec-prefix=${LIBDIR}/${ARCH_PREFIX} \
    "CFLAGS=${CFLAGS} \
    -mios-simulator-version-min=${MIN_SDK_VERSION} \
    -arch arm64 \
    -isysroot ${IPHONESIMULATOR_SYSROOT}" \
    "CXX=${CXX}" \
    "CXXFLAGS=${CXXFLAGS} \
    -mios-simulator-version-min=${MIN_SDK_VERSION} \
    -arch arm64 \
    -isysroot \
    ${IPHONESIMULATOR_SYSROOT}" \
    LDFLAGS="-arch arm64 \
    -mios-simulator-version-min=${MIN_SDK_VERSION} \
    ${LDFLAGS} \
    -L${IPHONESIMULATOR_SYSROOT}/usr/lib/ \
    -L${IPHONESIMULATOR_SYSROOT}/usr/lib/system" \
    "LIBS=${LIBS}"
    make ${EXTRA_MAKE_FLAGS}
    make ${EXTRA_MAKE_FLAGS} install
)

ARM64_IOS_SIM_PROTOBUF=${ARCH_PREFIX}/lib/libprotobuf-lite.a

echo "$(tput setaf 2)"
echo "##################"
echo " arm64 for iPhone"
echo "##################"
echo "$(tput sgr0)"

ARCH_PREFIX=ios_arm64

(
    make distclean
    ./configure \
    --host=arm \
    --disable-shared \
    --prefix=${LIBDIR}/${ARCH_PREFIX} \
    --exec-prefix=${LIBDIR}/${ARCH_PREFIX} \
    "CFLAGS=${CFLAGS} \
    -miphoneos-version-min=${MIN_SDK_VERSION} \
    -arch arm64 \
    -isysroot ${IPHONEOS_SYSROOT}" \
    "CXXFLAGS=${CXXFLAGS} \
    -miphoneos-version-min=${MIN_SDK_VERSION} \
    -arch arm64 \
    -isysroot ${IPHONEOS_SYSROOT}" \
    LDFLAGS="-arch arm64 \
    -miphoneos-version-min=${MIN_SDK_VERSION} \
    ${LDFLAGS}" \
    "LIBS=${LIBS}"
    make ${EXTRA_MAKE_FLAGS}
    make ${EXTRA_MAKE_FLAGS} install
)
(
    cd ${LIBDIR}

    mkdir -p ${ARCH_PREFIX}/libprotobuf-lite.framework/Headers
    cp ${ARCH_PREFIX}/lib/libprotobuf-lite.a ${ARCH_PREFIX}/libprotobuf-lite.framework/libprotobuf-lite
    find ${ARCH_PREFIX}/include/ -type f -print0 | xargs -0 sed -i '' 's/include <google/include <libprotobuf-lite\/google/g'
    cp -R ${ARCH_PREFIX}/include/ ${ARCH_PREFIX}/libprotobuf-lite.framework/Headers
)

ARM64_IPHONE_LIBPROTOBUF_FLAGS="-framework ${ARCH_PREFIX}/libprotobuf-lite.framework"

echo "$(tput setaf 2)"
echo "#####################"
echo " Objective C for iOS"
echo "#####################"
echo "$(tput sgr0)"

ARCH_PREFIX=ios_arm64

xcodebuild archive \
  -destination "generic/platform=iOS" \
  -project "objectivec/ProtocolBuffers_iOS.xcodeproj" \
  -configuration Release \
  -scheme "ProtocolBuffers" \
  -archivePath ${LIBDIR}/${ARCH_PREFIX}/ProtocolBuffers.xcarchive \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  SKIP_INSTALL=NO \
  ARCHS="arm64" \
  MACH_O_TYPE=staticlib \
  CLANG_WARN_STRICT_PROTOTYPES=NO \
  IPHONEOS_DEPLOYMENT_TARGET=15.0

mkdir -p ${LIBDIR}/${ARCH_PREFIX}/Protobuf.framework/Headers
cp ${LIBDIR}/${ARCH_PREFIX}/ProtocolBuffers.xcarchive/Products/usr/local/lib/libProtocolBuffers.a ${LIBDIR}/${ARCH_PREFIX}/Protobuf.framework/Protobuf
cp objectivec/*.h ${LIBDIR}/${ARCH_PREFIX}/Protobuf.framework/Headers

ARM64_IPHONE_PROTOBUF_FLAGS="-framework ${ARCH_PREFIX}/Protobuf.framework"

echo "$(tput setaf 2)"
echo "###############################"
echo " Objective C for iOS Simulator"
echo "###############################"
echo "$(tput sgr0)"

ARCH_PREFIX=simulator

xcodebuild archive \
  -destination "generic/platform=iOS Simulator" \
  -project "objectivec/ProtocolBuffers_iOS.xcodeproj" \
  -configuration Release \
  -scheme "ProtocolBuffers" \
  -archivePath ${LIBDIR}/${ARCH_PREFIX}/ProtocolBuffers.xcarchive \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  SKIP_INSTALL=NO \
  ARCHS="arm64 x86_64" \
  MACH_O_TYPE=staticlib \
  CLANG_WARN_STRICT_PROTOTYPES=NO \
  IPHONEOS_DEPLOYMENT_TARGET=15.0

mkdir -p ${LIBDIR}/${ARCH_PREFIX}/Protobuf.framework/Headers
cp ${LIBDIR}/${ARCH_PREFIX}/ProtocolBuffers.xcarchive/Products/usr/local/lib/libProtocolBuffers.a ${LIBDIR}/${ARCH_PREFIX}/Protobuf.framework/Protobuf
cp objectivec/*.h ${LIBDIR}/${ARCH_PREFIX}/Protobuf.framework/Headers

UNIVERSAL_IOS_SIM_PROTOBUF_FLAGS="-framework ${ARCH_PREFIX}/Protobuf.framework"

echo "$(tput setaf 2)"
echo "######################################"
echo " Create Universal Simulator Framework"
echo "######################################"
echo "$(tput sgr0)"

(
    cd ${PREFIX}/platform
    mkdir -p simulator/libprotobuf-lite.framework/Headers

    lipo ${ARM64_IOS_SIM_PROTOBUF} ${X86_64_IOS_SIM_PROTOBUF} -create -output simulator/libprotobuf-lite.framework/libprotobuf-lite
    find iossim_x86_64/include/ -type f -print0 | xargs -0 sed -i '' 's/include <google/include <libprotobuf-lite\/google/g'
    cp -R iossim_x86_64/include/ simulator/libprotobuf-lite.framework/Headers
)

UNIVERSAL_IOS_SIM_LIBPROTOBUF_FLAGS="-framework simulator/libprotobuf-lite.framework"

echo "$(tput setaf 2)"
echo "####################"
echo " Create XCFrameworks"
echo "####################"
echo "$(tput sgr0)"

(
    cd ${PREFIX}/platform
    mkdir -p ${PREFIX}/binaries/bin

    xcodebuild -create-xcframework ${ARM64_IPHONE_LIBPROTOBUF_FLAGS} ${UNIVERSAL_IOS_SIM_LIBPROTOBUF_FLAGS} -output ${PREFIX}/binaries/libprotobuf-lite.xcframework
    xcodebuild -create-xcframework ${ARM64_IPHONE_PROTOBUF_FLAGS} ${UNIVERSAL_IOS_SIM_PROTOBUF_FLAGS} -output ${PREFIX}/binaries/Protobuf.xcframework
    cp ${X86_64_MAC_PROTOC} ${PREFIX}/binaries/bin
)

) 2>&1 | tee build.log

echo "$(tput setaf 2)"
echo Done!
echo "$(tput sgr0)"

#!/bin/bash -x

echo "$(tput setaf 2)"
echo Building Google Protobuf for Mac OS X / iOS.
echo Use 'tail -f build.log' to monitor progress.
echo "$(tput sgr0)"

# Controls which architectures are build/included in the
# universal binaries and libraries this script produces.
# Set each to '1' to include, '0' to exclude.
BUILD_X86_64_IOS_SIM=1
BUILD_ARM64_IOS_SIM=1
BUILD_ARM64_IPHONE=1

# Set this to the minimum iOS SDK version you wish to support.
MIN_SDK_VERSION=11.0

(

PREFIX=`pwd`/out
mkdir -p ${PREFIX}/platform

EXTRA_MAKE_FLAGS="protobuf-lite -j8"

XCODEDIR=`xcode-select --print-path`

IOS_SDK=$(xcodebuild -showsdks | grep iphoneos | sort | head -n 1 | awk '{print $NF}')
SIM_SDK=$(xcodebuild -showsdks | grep iphonesimulator | sort | head -n 1 | awk '{print $NF}')

IPHONEOS_PLATFORM=$(xcrun --sdk iphoneos --show-sdk-platform-path)
IPHONEOS_SYSROOT=$(xcrun --sdk iphoneos --show-sdk-path)

IPHONESIMULATOR_PLATFORM=$(xcrun --sdk iphonesimulator --show-sdk-platform-path)
IPHONESIMULATOR_SYSROOT=$(xcrun --sdk iphonesimulator --show-sdk-path)

CC=clang
CFLAGS="-DNDEBUG -Os -pipe -fPIC -fno-exceptions"
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
    mkdir ${PREFIX}/platform
)

echo "$(tput setaf 2)"
echo "##########################################"
echo " Fetch Google Protobuf $PB_VERSION from source."
echo "##########################################"
echo "$(tput sgr0)"

./autogen.sh
if [ $? -ne 0 ]
then
  echo "./autogen.sh command failed."
  exit 1
fi

if [ $BUILD_X86_64_IOS_SIM -eq 1 ]
then

echo "$(tput setaf 2)"
echo "###########################"
echo " x86_64 for iPhone Simulator"
echo "###########################"
echo "$(tput sgr0)"

(
    make distclean
    ./configure \
    --host=x86_64-apple-${OSX_VERSION} \
    --disable-shared \
    --enable-cross-compile \
    --with-protoc="${PROTOC_PATH}" \
    --prefix=${LIBDIR}/iossim_x86_64 \
    --exec-prefix=${LIBDIR}/iossim_x86_64 \
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

X86_64_IOS_SIM_PROTOBUF=iossim_x86_64/lib/libprotobuf.a
X86_64_IOS_SIM_PROTOBUF_LITE=iossim_x86_64/lib/libprotobuf-lite.a

else

X86_64_IOS_SIM_PROTOBUF=
X86_64_IOS_SIM_PROTOBUF_LITE=

fi

if [ $BUILD_ARM64_IOS_SIM -eq 1 ]
then

echo "$(tput setaf 2)"
echo "###########################"
echo " x86_64 for iPhone Simulator"
echo "###########################"
echo "$(tput sgr0)"

(
    make distclean
    ./configure \
    --host=arm \
    --disable-shared \
    --enable-cross-compile \
    --with-protoc="${PROTOC_PATH}" \
    --prefix=${LIBDIR}/iossim_arm64 \
    --exec-prefix=${LIBDIR}/iossim_arm64 \
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

ARM64_IOS_SIM_PROTOBUF=iossim_arm64/lib/libprotobuf.a
ARM64_IOS_SIM_PROTOBUF_LITE=iossim_arm64/lib/libprotobuf-lite.a

else

ARM64_IOS_SIM_PROTOBUF=
ARM64_IOS_SIM_PROTOBUF_LITE=

fi

if [ $BUILD_ARM64_IPHONE -eq 1 ]
then

echo "$(tput setaf 2)"
echo "##################"
echo " arm64 for iPhone"
echo "##################"
echo "$(tput sgr0)"

(
    make distclean
    ./configure \
    --host=arm \
    --with-protoc="${PROTOC_PATH}" \
    --disable-shared \
    --prefix=${LIBDIR}/ios_arm64 \
    --exec-prefix=${LIBDIR}/ios_arm64 \
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

ARM64_IPHONE_PROTOBUF=ios_arm64/lib/libprotobuf.a
ARM64_IPHONE_PROTOBUF_LITE=ios_arm64/lib/libprotobuf-lite.a

else

ARM64_IPHONE_PROTOBUF=
ARM64_IPHONE_PROTOBUF_LITE=

fi

echo "$(tput setaf 2)"
echo "############################"
echo " Create Universal Libraries"
echo "############################"
echo "$(tput sgr0)"

(
    cd ${PREFIX}/platform
    mkdir universal

    # lipo ${ARM64_IPHONE_PROTOBUF} ${X86_64_IOS_SIM_PROTOBUF} -create -output universal/libprotobuf.a

    # lipo ${ARM64_IPHONE_PROTOBUF_LITE} ${X86_64_IOS_SIM_PROTOBUF_LITE} -create -output universal/libprotobuf-lite.a
)

echo "$(tput setaf 2)"
echo "########################"
echo " Finalize the packaging"
echo "########################"
echo "$(tput sgr0)"

(
    cd ${PREFIX}
    mkdir bin
    mkdir lib
    cp -r platform/x86_64/bin/protoc bin
    cp -r platform/universal/* lib

    file lib/libprotobuf.a
    file lib/libprotobuf-lite.a
)

) 2>&1 | tee build.log

echo "$(tput setaf 2)"
echo Done!
echo "$(tput sgr0)"

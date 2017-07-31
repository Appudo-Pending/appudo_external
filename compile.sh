#!/bin/bash
###########################################################################################
#    compile.sh is part of Appudo
#
#    Copyright (C) 2015
#        89a46e2bb720c7ec116d9e3c4c4f722938c13856d1277fd8c551db4c0c8f087e source@appudo.com
#
#    Licensed under the Apache License, Version 2.0
#
#    See http://www.apache.org/licenses/LICENSE-2.0 for more information
###########################################################################################
set -v # verbose
set -e
if [ "$1" -eq 0  ]
then
echo RELEASE
T="Release"
LINK_OPT='-O3'
SWIFT_OPT='-O -gnone'
else
echo DEBUG
T="Debug"
LINK_OPT='-O0'
SWIFT_OPT='-Onone -g'
fi

SRC=$(realpath src)
MACHINE=$(uname -m)
P=$T.$MACHINE

if [ -d "$P" ]; then
    exit 0
fi

mkdir -p $P
cd $P

mkdir -p Packages
mkdir -p Packages/SwiftyJSON

echo "compile modules..."
export TMPDIR=SwiftyJSON/build
mkdir -p SwiftyJSON/build
files=$(find $SRC/SwiftyJSON -name "*.swift" | xargs)
swiftc $SWIFT_OPT -parse-as-library -save-temps -emit-bc -module-name=SwiftyJSON -emit-module-path=Packages/SwiftyJSON.swiftmodule $files

echo "link modules..."
files=$(find SwiftyJSON -name "*.bc" | xargs)
llvm-link $files -o SwiftyJSON.bc

echo "compile modules..."
llc -relocation-model=pic $LINK_OPT -filetype=obj SwiftyJSON.bc -o SwiftyJSON.o
ar r libSwiftyJSON.a SwiftyJSON.o


cp Packages/SwiftyJSON.* $SRC/../../appudo_master/userData2/Packages/$MACHINE/

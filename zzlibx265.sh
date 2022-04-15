#!/bin/bash
# install libx265
set -e

ROOTDIR=${ZZROOT:-$HOME/app}
NAME="libx265"
TYPE=".tar.gz"
VERSION="3.5"
FILE="$NAME-$VERSION$TYPE"
DOWNLOADURL="https://bitbucket.org/multicoreware/x265_git/downloads/x265_3.5.tar.gz"
echo $NAME will be installed in "$ROOTDIR"

mkdir -p "$ROOTDIR/downloads"
cd "$ROOTDIR"

if [ -f "downloads/$FILE" ]; then
    echo "downloads/$FILE exist"
else
    echo "$FILE does not exist, downloading from $DOWNLOADURL"
    wget $DOWNLOADURL --no-check-certificate -O $FILE
    mv $FILE downloads/
fi

mkdir -p src/$NAME
tar xf downloads/$FILE -C src/$NAME --strip-components 1

cd src/$NAME/build/linux

cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$ROOTDIR" -DENABLE_SHARED:bool=on ../../source
make -j"$(nproc)" && make install

echo $NAME installed on "$ROOTDIR"

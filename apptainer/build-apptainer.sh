#!/bin/bash
# Default to installing apptainer version 1.1.7
# the latest version as of 2023-04-12
if [ -z "$1" ]; then
	VERS=1.3.2
else
	VERS="$1"
fi

# set Apptainer version
export VERSION=$VERS

# set Go version
export GO_VERSION=1.22.4

# set Apptainer directory
APPTAINER_DIR=/apps/apptainer/
APPTAINER_BUILD_DIR=$APPTAINER_DIR/build

# set Module paths
MODULE_TEMPLATE=$(readlink -f module-template.txt)
MODULE_PATH=/opt/modulefiles/apptainer/${VERSION}-go-${GO_VERSION}

# Change to apptainer build directory
cd $APPTAINER_BUILD_DIR

# add go to PATH
export PATH=$PWD/golang/go/bin:$PATH

# Check if already exists
if [ -d "apptainer-$VERSION" ]; then
    while true; do
	echo "Version $VERSION seems already built."
        read -r -p "Remove installed files and source; then rebuild and reinstall? (y/n)" yn
        case $yn in
            [Yy]* ) rm -rf "$APPTAINER_BUILD_DIR/apptainer-$VERSION" "$APPTAINER_BUILD_DIR/apptainer-$VERSION.tar.gz" "$APPTAINER_DIR/$VERSION"; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer y (yes) or n (no).";;
        esac
    done
fi

# Continue Build
wget https://github.com/apptainer/apptainer/releases/download/v${VERSION}/apptainer-${VERSION}.tar.gz && \
tar -xzf apptainer-${VERSION}.tar.gz && \
cd apptainer-$VERSION && \
./mconfig --without-suid --prefix=/apps/apptainer/"$VERSION" --localstatedir=/scratch && \
cd builddir && \
make && \
make install

# Finalize
echo "Apptainer version $VERSION installed to $APPTAINER_DIR/$VERSION"
echo
sed "s/__SED_REPLACE_ME_WITH_VERSION__/\"${VERSION}\"/" "${MODULE_TEMPLATE}" > ${MODULE_PATH}
echo "Modulefile installed at: ${MODULE_PATH}"


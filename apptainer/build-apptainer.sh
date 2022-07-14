#!/bin/bash
# Default to installing apptainer version 1.0.2
# the latest version as of 2022-05-16
if [ -z "$1" ]; then
	VERS=1.0.2    
else
	VERS="$1"
fi

# set Apptainer directory
APPTAINER_DIR=/apps/apptainer/
APPTAINER_BUILD_DIR=$APPTAINER_DIR/build
# Change to apptainer build directory
cd $APPTAINER_BUILD_DIR

# We've already got golang 1.18.2 binary
export PATH=$PWD/golang/go/bin:$PATH

export VERSION=$VERS

# Check if already exists
if [ -d "apptainer-$VERSION" ]; then
    while true; do
	echo "Version $VERSION seems already built."
        read -r -p "Remove installed files and source; then rebuild and reinstall? (y/n)" yn
        case $yn in
            [Yy]* ) rm -rf "$APPTAINER_BUILD_DIR/apptainer-$VERSION" "$APPTAINER_BUILD_DIR/apptainer-$VERSION.tar.gz" "$APPTAINER_DIR/$VERSION"; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi

# Continue Build
wget https://github.com/apptainer/apptainer/releases/download/v${VERSION}/apptainer-${VERSION}.tar.gz && \
tar -xzf apptainer-${VERSION}.tar.gz && \
cd apptainer-$VERSION && \
./mconfig --prefix=/apps/apptainer/"$VERSION" --localstatedir=/scratch && \
cd builddir && \
make && \
make install

# Finalize
echo "Apptainer version $VERSION installed to $APPTAINER_DIR/$VERSION"
echo
echo "WARNING! INSTALLATION NOT FINISHED, MODULEFILE NEEDED!"
echo "Please generate/update/create a module for Apptainer $VERSION in /act/modulefiles/apptainer/"

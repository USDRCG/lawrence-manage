#!/bin/bash

# Spack Install wrapper
spinstall () {
    echo
    echo "Installing $1"
}
# Physics
spinstall root%gcc@6.3.0
spinstall geant4%gcc@6.3.0
spinstall "geant4%gcc@6.3.0 -qt"

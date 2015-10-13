#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $THIS_DIR/set-env.sh
####################################################################################################

cd foreign-jni
GHC=$HOME/.ghc/android-host/bin/ghc

arm-linux-androideabi-cabal install

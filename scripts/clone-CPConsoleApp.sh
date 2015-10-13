#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $THIS_DIR/set-env.sh
####################################################################################################


git clone https://github.com/EDeijl/CPCConsoleApp.git CPConsoleApp
cd CPConsoleApp/platforms/android
~/android-sdk-linux/tools/android update project -p .
echo "ndk.dir=/home/androidbuilder/android-ndk-r9b" >> local.properties
cd ../..
#git checkout ae30300f93fa559d0f677247edbe1745a74d99b8 2>&1

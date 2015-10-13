FROM sseefried/debian-wheezy-ghc-android
MAINTAINER erik.deijl@gmail.com

USER androidbuilder
ENV BASE /home/androidbuilder/build
RUN mkdir -p $BASE
WORKDIR $BASE

#
# Install ant
#

USER root
run echo "deb http://ftp.nl.debian.org/debian wheezy main" > /etc/apt/sources.list
run echo "deb-src http://ftp.nl.debian.org/debian wheezy main" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install ant openjdk-6-jdk -y
RUN wget http://dl.google.com/android/android-sdk_r24.2-linux.tgz
RUN cd .. && tar xzf build/android-sdk_r24.2-linux.tgz
RUN chown -R androidbuilder:androidbuilder /home/androidbuilder/android-sdk-linux

# Switch back to androidbuilder user
USER androidbuilder

#
# Add environment script
#
ADD scripts/set-env.sh $BASE/

#
# Install Android SDK platform tools, build tools and API
#
ADD scripts/install-android-sdk-platform-tools.sh $BASE/
RUN ./install-android-sdk-platform-tools.sh
ADD scripts/install-android-sdk-build-tools.sh $BASE/
RUN ./install-android-sdk-build-tools.sh
ADD scripts/install-android-api-12.sh $BASE/
RUN ./install-android-api-12.sh

#
# Build cpufeatures library
#
ADD scripts/build-cpufeatures.sh $BASE/
RUN ./build-cpufeatures.sh

#
# Cabal install text-1.2.0.0
#

ADD scripts/cabal-install-text.sh $BASE/
RUN ./cabal-install-text.sh

#
# Add cabal setup wrapper
#

ADD scripts/arm-linux-androideabi-cabal-setup.sh /home/androidbuilder/.ghc/android-14/arm-linux-androideabi-4.8/bin/

#
# Clone and build foreign-jni
#

ADD scripts/clone-foreignjni.sh $BASE/
RUN ./clone-foreignjni.sh
ADD scripts/build-foreign-jni.sh $BASE/
RUN ./build-foreign-jni.sh

#
# Clone CPConsoleApp
#
ADD scripts/clone-CPConsoleApp.sh $BASE/
RUN ./clone-CPConsoleApp.sh


# A `Dockerfile` for provisioning a build environment for Android apps written in Haskell

## Introduction
This repository contains a `Dockerfile` for building a simple HelloWorld written in Haskell for Android.
The dockerfile is built upon sseefried's [docker-epidemic-build-env](https://github.com/sseefried/docker-epidemic-build-env) but without all the dependencies specific to his game [Epidemic](https://github.com/sseefried/open-epidemic-game).
It includes a slightly modified version of CJ van den Berg's [android-haskell-activity](https://github.com/neurocyte/android-haskell-activity), which also runs on iOS devices, it's repository can be found [here](https://github.com/EDeijl/CPCConsoleApp).

## Installation

Please ensure that you are using at least Docker version 1.6. Check with `docker version`.

### (Optional) Build `debian-wheezy-ghc-android`

You probably only want to do this if for some reason you can't download
`sseefried/debian-wheezy-ghc-android` from the
[Docker Hub](https://registry.hub.docker.com/search?q=library) registry. It's rather large
at 1.1G.

Follow the instruction in the `README.md` [here](https://github.com/sseefried/docker-build-ghc-android).

Once you've done that you'll need to tag the resulting image as `sseefried/debian-wheezy-ghc-android`
locally to build the image this `Dockerfile` specifies.

### Build with Docker

At the command line simply type:

    $ docker build .

This will take a while to build. First, unless you performed the previous step, Docker must download
the image `sseefried/debian-wheezy-ghc-android` (about 1.1G). It will then download, clone and build
a bunch of libraries. Go get a coffee, drink it slowly, go for a long walk and then come back.
Once it's finished type:

    $ docker images

You will get something like:

    REPOSITORY                            TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    <none>                                <none>              3b16cf90e485        6 minutes ago       5.923 GB
    ...

You can tag the image with something memorable like:

    docker tag <image id> epidemic-build-env

You now have two options for building and installing Epidemic.

### Option A: Build, copy APK and install

You can simply run an interactive shell and build the APK inside a running container.


    $ docker run -it epidemic-build-env /bin/bash
    androidbuilder@283089ad80b9:~/build$ cd CPConsoleApp
    androidbuilder@283089ad80b9:~/build/CPConsoleApp$ ./build-android.sh

The `adb` tool is not installed in the image so once you have built the APK you will want to
copy the APK to your local machine (which presumably has `adb` installed in it).

Keep the container running. In a fresh shell (in another terminal window) type:

     $ docker ps

You'll get something like:

    CONTAINER ID        IMAGE                       COMMAND             CREATED              STATUS                  PORTS               NAMES
    d4a82703a3a9        epidemic-build-env:latest   "/bin/bash"         About a minute ago   Up 57     seconds                           dreamy_ptolemy

This will give you a container ID (`d4a82703a3a9` or `dreamy_ptolemy` here).

     $ docker cp dreamy_ptolemy:/home/androidbuilder/build/CPConsoleApp/bin/CPConsoleApp-debug.apk .

You can now install this APK with

     $ adb install -r CPConsoleApp-debug.apk

#! /bin/sh
 
# comment out the package you don't want to install (note that kdiff3 is a QT-based tool)
#OPT_KDIFF3=kdiff3
#OPT_MELD=meld
 
# still be used in our build system
OPT_MERCURIAL=mercurial
 
# one of or both compilers can be installed depending on your plans
#GCC_TOOLCHAIN="gcc-10 g++-10 gdb"
CLANG_TOOLCHAIN="clang lldb"
 
DEBIAN_FRONTEND=noninteractive
 
apt update
apt install -y --no-install-recommends \
        tzdata \
        build-essential \
        xsltproc \
        execstack \
        libglib2.0-dev \
        mesa-common-dev \
        libglu1-mesa-dev \
        imagemagick \
        bison \
        ccache \
        flex\
        zlib1g-dev \
        libbz2-dev \
        libfontconfig1-dev \
        libcups2-dev \
        fonts-dejavu \
        libxcb-xinerama0 \
        libsecret-1-dev \
        python3-pip \
        python3-pyqt5\
        cmake \
        mono-devel \
        ninja-build \
        openjdk-8-jdk \
        \
        $GCC_TOOLCHAIN \
        $CLANG_TOOLCHAIN \
        \
        git \
        git-gui \
        "$OPT_KDIFF3" \
        "$OPT_MELD" \
        \
        "$OPT_MERCURIAL"
 
ln -s /usr/bin/python3 /usr/bin/python
pip3 install dulwich GitPython || sudo apt install -y python3-dulwich python3-git

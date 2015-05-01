#!/bin/sh
echo 'Cloning Tomato sources into /home/tomato/tomato-arm/'
if [ -d /home/tomato/advancedtomato-arm ]; then
    cd /home/tomato/advancedtomato-arm
    git pull
else
    cd /home/tomato/
    git clone https://bitbucket.org/jackysi/advancedtomato-arm.git advancedtomato-arm
fi

if [! -d /home/tomato/advancedtomato-arm ]; then
    ln -s /home/tomato/advancedtomato-arm/release/src-rt-6.x.4708/toolchains/hndtools-arm-linux-2.6.36-uclibc-4.5.3/ /opt/hndtools-arm-linux-2.6.36-uclibc-4.5.3
fi

hndtools="/home/tomato/advancedtomato-arm/release/src-rt-6.x.4708/toolchains/hndtools-arm-linux-2.6.36-uclibc-4.5.3/bin"
if [ -d "$hndtools" ] && [[ ":$PATH:" != *":$hndtools:"* ]]; then
    echo "export PATH=$PATH:$hndtools:/sbin/" >> /home/tomato/.profile
fi

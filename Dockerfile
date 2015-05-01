FROM debian:7.7
MAINTAINER Tony Arnold <tony@thecocoabots.com>

# Install packages
RUN echo "deb http://httpredir.debian.org/debian sid main" >> /etc/apt/sources.list
RUN dpkg --add-architecture i386
RUN apt-get update && \
    apt-get -y install openssh-server pwgen && \
    mkdir -p /var/run/sshd && \
    sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config

ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
ADD checkout_advancedtomato_source.sh /checkout_advancedtomato_source.sh
RUN chmod +x /*.sh

RUN apt-get install -y wget apt-utils locales
RUN apt-get install -y build-essential autoconf libncurses5 libncurses5-dev m4 bison flex libstdc++6-4.4-dev g++-4.4 g++ libtool sqlite gcc g++ binutils patch bzip2 flex bison make gettext unzip zlib1g-dev libc6 gperf sudo automake automake1.9 git-core lib32stdc++6 libncurses5 libncurses5-dev m4 bison gawk flex libstdc++6-4.4-dev g++-4.4-multilib g++ git gitk zlib1g-dev autopoint libtool shtool autogen mtd-utils gcc-multilib gconf-editor lib32z1-dev pkg-config gperf libssl-dev libxml2-dev libelf1:i386 make intltool libglib2.0-dev libstdc++5 texinfo dos2unix xsltproc libnfnetlink0 libcurl4-openssl-dev libxml2-dev libgtk2.0-dev libnotify-dev libevent-dev mc automake-1.14


WORKDIR /tmp
RUN wget http://tomato.groov.pl/download/K26RT-N/testing/automake_1.13.2-1ubuntu1_all.deb
RUN dpkg -i automake_1.13.2-1ubuntu1_all.deb && apt-get install -y net-tools vim ctags
RUN echo "dash dash/sh boolean false" | debconf-set-selections && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash
RUN dpkg-reconfigure locales && \
  locale-gen C.UTF-8 && \
  /usr/sbin/update-locale LANG=C.UTF-8
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt-get -y install sudo zsh

RUN useradd tomato
RUN echo "tomato:tomato" | chpasswd
RUN adduser tomato sudo
RUN mkdir -p /home/tomato
RUN chown -R tomato:tomato /home/tomato

WORKDIR /home/tomato
USER tomato
CMD ["/checkout_advancedtomato_source.sh"]

USER root
ENV AUTHORIZED_KEYS **None**

EXPOSE 22
CMD ["/run.sh"]

FROM phusion/baseimage:0.9.18
MAINTAINER Damien Garros <dgarros@gmail.com>

RUN     apt-get -y update && \
        apt-get -y upgrade && \
        apt-get clean   &&\
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# dependencies
RUN     apt-get -y update && \
        apt-get -y install \
        git adduser libfontconfig wget make curl  && \
        apt-get clean   &&\
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Latest version
ENV FLUENTD_VERSION 0.12.20
ENV FLUENTD_JUNIPER_VERSION 0.2.11

RUN     apt-get -y update && \
        apt-get -y install \
            build-essential \
            tcpdump \
            ruby \
            ruby-dev \
            python-dev \
            python-pip

########################
### Install Fluentd  ###
########################

# RUN     gem install fluentd fluent-plugin-influxdb --no-ri --no-rdoc
RUN     gem install --no-ri --no-rdoc \
            fluentd -v ${FLUENTD_VERSION} && \
        gem install --no-ri --no-rdoc \
            protobuf && \
        gem install --no-ri --no-rdoc \
            fluent-plugin-juniper-telemetry -v ${FLUENTD_JUNIPER_VERSION} \
        gem install --no-ri --no-rdoc \
            gem install fluent-plugin-splunk-ex &&

RUN     pip install envtpl

RUN     mkdir /root/fluent

RUN     mkdir /etc/fluent && \
        mkdir /etc/fluent/plugin

WORKDIR /root
ENV HOME /root

ADD     fluentd/fluentd.launcher.sh /etc/service/fluentd/run
RUN     chmod +x /etc/service/fluentd/run

ADD     fluentd/fluentd.start.sh /root/fluentd.start.sh
RUN     chmod +x /root/fluentd.start.sh

RUN     chmod -R 777 /var/log/

ENV OUTPUT_STDOUT=false \
    PORT_JTI=50000 \
    PORT_ANALYTICSD=50020

EXPOSE 24220

CMD ["/sbin/my_init"]

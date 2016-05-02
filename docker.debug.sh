#! /bin/bash

docker run --rm -t \
        -e SPLUNK_ADDR="172.17.0.3" \
        -e PORT_JTI='40000' \
        -p 40000:40000/udp \
        --volume $(pwd):/root/fluent \
        -i juniper/junos-telemetry-splunk /sbin/my_init -- bash -l

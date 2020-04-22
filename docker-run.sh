#!/bin/sh

if [ ! -f /data/config.yml ]; then
    echo "Config file in /data/config.yml is missing"
    echo "Attempting to create it from environment variables"

    if [ -z "$CONNECTBOX_IP_ADDRESS" ]
    then
        echo "ConnectBox ip address (CONNECTBOX_IP_ADDRESS environment variable) is required"
        exit
    fi

    if [ -z "$CONNECTBOX_PASSWORD" ]
    then
        echo "ConnectBox password (CONNECTBOX_PASSWORD environment variable) is required"
        exit
    fi

    mkdir -p /data
    cat > /data/config.yml <<END
ip_address: "$CONNECTBOX_IP_ADDRESS"
password: "$CONNECTBOX_PASSWORD"
exporter:
  port: ${CONNECTBOX_EXPORTER_PORT:-9705}
  timeout_seconds: ${CONNECTBOX_EXPORTER_TIMEOUT:-9}
END

    echo "Config file has been created from environment variables"
fi

chown -R nobody /data
exec su-exec nobody connectbox_exporter /data/config.yml

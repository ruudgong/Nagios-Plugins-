#!/bin/bash

conresult=$(curl -s --user admin:admin http://localhost:8161/api/jolokia/read/org.apache.activemq:type=Broker,brokerName=localhost/CurrentConnectionsCount | jq '.value')

#echo $conresult

if [ "$conresult" -lt 800 ] 2> /dev/null; then
        echo "OK - there are $conresult connections"
        exit 0
elif [ "$conresult" -gt 800 ] 2> /dev/null && [ "$conresult" -lt 1000 ] 2> /dev/null; then
        echo "Warning - there are $conresult connections"
        exit 1
elif [ "$conresult" -gt 1000 ] 2> /dev/null; then
        echo "CRITICAL - there are $conresult connections"
        exit 2
else
        if grep -q "slave" /var/log/activemq/activemq.log; then
                echo "OK - this node is in Slave Mode, there are no connections"
                exit 0
        else
                echo "Unknown Output"
                exit 3
        fi
fi


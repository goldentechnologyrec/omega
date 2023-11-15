#!/bin/bash

#Monitoring Nginx

result=$(ps aux | grep nginx | grep -v grep | wc -l)

if [ $result -ge 1 ]
then
	echo "nginx_status 1" | curl --data-binary @- http://localhost:9091/metrics/job/my_custom_metrics/instance/10.20.0.1:9000/provider/hetzner
else
	echo "nginx_status 0" | curl --data-binary @- http://localhost:9091/metrics/job/my_custom_metrics/instance/10.20.0.1:9000/provider/hetzner
fi

#Monitoring consulterSolde

result=$(ps aux | grep consulterSolde | grep -v grep | wc -l)

if [ $result -eq 1 ]
then
        echo "consulterSolde_status 1" | curl --data-binary @- http://localhost:9091/metrics/job/my_custom_metrics/instance/10.20.0.1:9000/provider/hetzner
else
        echo "consulterSolde_status 0" | curl --data-binary @- http://localhost:9091/metrics/job/my_custom_metrics/instance/10.20.0.1:9000/provider/hetzner
fi


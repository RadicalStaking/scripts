#!/bin/bash

while true
do
   curl -s -u metrics:$NGINX_METRICS_PASSWORD -k 'https://localhost/metrics' | grep info_counters_radix_engine_cur_epoch_completed_proposals
   date
   echo ----
   sleep 1
done

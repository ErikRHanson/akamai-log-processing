#!/usr/bin/env bash

[ "$(ls -b /data/akamai-logs | wc -l)" -gt 0 ] && {

        echo "clearing out the unzipped directory"
        sudo rm -f /data/akamai-logs-unzipped/*

        echo "Archiving gzipped logs"
        sudo cp /data/akamai-logs/* /data/akamai-logs-archive/.

        echo "gunzipping and processing"
        sudo mv /data/akamai-logs/* /data/akamai-logs-unzipped/.
        sudo gunzip /data/akamai-logs-unzipped/*.gz

        echo "using aws s3 mv"
        echo "to archive Akamai logs in S3"
        sudo aws s3 mv /data/akamai-logs-archive/ s3://tap-akamai-logs/ --recursive

        echo "Process complete, it's up to logstash now."
        exit 0
}

echo "no logs to process at this time"
exit 1

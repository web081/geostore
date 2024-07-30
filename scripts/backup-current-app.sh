#!/bin/bash
echo "Backing up the current application..."
TIMESTAMP=$(date +%F_%T)
cp /opt/jetty-base/webapps/app.war /opt/jetty-base/backups/app-backup-$TIMESTAMP.war

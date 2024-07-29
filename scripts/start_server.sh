#!/bin/bash
echo "Starting GeoStore application..."

# Stop any running instance of GeoStore
sudo pkill -f 'java -jar /var/www/html/geostore.war'

# Start the GeoStore application
nohup java -jar /var/www/html/geostore.war &> /var/www/html/nohup.out &

# Ensure the application is running
if pgrep -f 'java -jar /var/www/html/geostore.war'; then
    echo "GeoStore application started successfully."
else
    echo "Failed to start GeoStore application. Check logs for details."
    exit 1
fi

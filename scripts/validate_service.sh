#!/bin/bash
echo "Validating the service..."
if curl -s --head http://34.229.41.145/geostore/rest | grep "200 OK" > /dev/null; then
  echo "GeoStore is up and running."
  exit 0
else
  echo "GeoStore is not responding. Check the logs for issues."
  exit 1
fi

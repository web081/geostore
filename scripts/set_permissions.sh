#!/bin/bash
echo "Setting file permissions..."
chown jetty:jetty /opt/jetty-base/webapps/app.war
chmod 644 /opt/jetty-base/webapps/app.war

### GeoStore Application API Deployment into EC2 AWS Services
* This project provides a deployment configuration for the GeoStore application on an AWS EC2 instance using GitHub, AWS CodeBuild, and AWS CodeDeploy. The deployment also involves configuring Apache as a reverse proxy for the GeoStore application.

##### Prerequisites
* Before starting, ensure you have the following prerequisites:

- An AWS account with permissions to use EC2, CodeBuild, and CodeDeploy.
- An EC2 instance running Ubuntu.
- Apache and PostgreSQL installed and running on the EC2 instance.
Git installed locally.

Setup
1. Clone the Repository
- Clone the GeoStore repository from GitHub:
```
git clone git@github.com:geosolutions-it/geostore.git geostore
cd geostore
```
1. Configure CodeBuild and CodeDeploy
- Ensure you have AWS CodeBuild and CodeDeploy set up with the necessary IAM roles and policies.

1. ##### Deployment Configuration
   `buildspec.yml`
- This file defines the build steps and specifies the artifact to be used by CodeDeploy.

``` yaml
version: 0.2

phases:
  install:
    runtime-versions:
      java: corretto8
    commands:
      - echo Installing dependencies...
      - sudo apt-get update
      - sudo apt-get install -y maven git
  build:
    commands:
      - echo Building the GeoStore application...
      - mvn clean install
      - echo Listing files in target directory...
      - ls -l target/
artifacts:
  files:
    - target/geostore.war
```
`appspec.yml`
* This file specifies the deployment steps for CodeDeploy.

```yaml
version: 0.0
os: linux
files:
  - source: target/geostore.war
    destination: /var/www/html/geostore.war
hooks:
  BeforeInstall:
    - location: scripts/install_dependencies.sh
      timeout: 300
  AfterInstall:
    - location: scripts/configure_apache.sh
      timeout: 300
  ApplicationStart:
    - location: scripts/start_server.sh
      timeout: 300
```
##### Deployment Scripts
- Create the following scripts in the scripts directory:
 `scripts/install_dependencies.sh`
```
#!/bin/bash
echo "Installing dependencies..."
sudo apt-get update
sudo apt-get install -y maven git
``` 
`scripts/configure_apache.sh`

```
#!/bin/bash
echo "Configuring Apache..."

# Enable necessary Apache modules
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo systemctl restart apache2

# Create a new Apache site configuration for GeoStore
cat <<EOL | sudo tee /etc/apache2/sites-available/geostore.conf
<VirtualHost *:80>
    ServerName geostore.example.com

    ProxyPreserveHost On
    ProxyPass / http://localhost:8080/
    ProxyPassReverse / http://localhost:8080/

    ErrorLog \${APACHE_LOG_DIR}/geostore_error.log
    CustomLog \${APACHE_LOG_DIR}/geostore_access.log combined
</VirtualHost>
EOL

sudo a2ensite geostore.conf
sudo systemctl reload apache2
```
4. ##### Make Scripts Executable
- Ensure the deployment scripts are executable:
```
chmod +x scripts/install_dependencies.sh scripts/configure_apache.sh scripts/start_server.sh
```
5. ##### Commit and Push Changes
- Commit your changes and push to the repository:
```
git add .
git commit -m "Update deployment scripts and appspec.yml"
git push origin main
```
6. ##### Deploy
- Use AWS CodeDeploy to deploy the application to your EC2 instance. - Ensure that the security group of your EC2 instance allows traffic on the necessary ports.

##### Accessing the Application
- Once deployed, the GeoStore application will be accessible at http://your-ec2-instance-ip-or-domain/geostore/rest.

#### Acknowledgments
- GeoStore - The GeoStore application repository.
- AWS CodeBuild - For building the application.
- AWS CodeDeploy - For deploying the application.
#!/bin/bash

# Update apt
sudo apt-get update

# Install packages to allow apt to use a repository over HTTPS:
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg

# Add Docker’s official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the docker's respository to the system
echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the system after adding the repository
sudo apt-get update

# Install Docker Engine
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add user to the docker group, this avoid write every time "sudo" in cli 
sudo usermod -aG docker $USER

# downlaod octopus image
sudo docker pull octopusdeploy/octopusdeploy

# Set variables
sql_server_domain_name="${sql_server_domain_name}"
sql_db_name="${sql_db_name}"
admin_username="${admin_username}"
admin_password="${admin_password}"

# Run octopus container
sudo docker run --name OctopusDeployTool --publish 80:8080 --env ACCEPT_EULA="Y" --env DB_CONNECTION_STRING="Server=$sql_server_domain_name,1433; Database=$sql_db_name; User Id=$admin_username; Password=$admin_password" -d octopusdeploy/octopusdeploy

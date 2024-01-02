#!/bin/bash
sudo apt-get update
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER

# Install Azure CLI 
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# ServicePlan ACR
ACR_REGISTRY="*********.azurecr.io"
ACR_SP_ID="*********************"
ACR_SP_SECRET="*********************"

# Log in to ACR using service principal credentials
sudo docker login $ACR_REGISTRY -u $ACR_SP_ID -p $ACR_SP_SECRET

# Pull the container image
sudo docker pull $ACR_REGISTRY/notes-ui:1.0
sudo docker run -d -p 80:80 --name my_notes_ui $ACR_REGISTRY/notes-ui:1.0

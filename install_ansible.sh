# For Ubuntu 18.04 LTS
# Install Ansible & Dependencies
sudo apt-add-repository --yes ppa:ansible/ansible
sudo apt update
sudo apt install -y software-properties-common ansible docker.io docker-compose python3-pip
pip3 install boto boto3 netaddr passlib f5-sdk f5-cli bigsuds deepdiff 'ansible[azure]' 

# Install Azure CLI 
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az version

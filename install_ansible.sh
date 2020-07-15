# For Ubuntu 18.04 LTS
# Install Ansible & Dependencies
sudo apt-add-repository --yes ppa:ansible/ansible
sudo apt update
sudo apt install -y software-properties-common ansible docker.io docker-compose python3-pip
# Ubuntu 20.04 > sudo apt install -y software-properties-common ansible python3-pip azure-cli
pip3 install boto boto3 netaddr passlib bigsuds deepdiff 'ansible[azure]' 
ansible-galaxy install f5devcentral.f5app_services_package

# Install Azure CLI 
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az version

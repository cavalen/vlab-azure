# For Ubuntu 18.04 LTS - Install Ansible & Dependencies
sudo apt-add-repository --yes ppa:ansible/ansible
sudo apt update
sudo apt install -y software-properties-common ansible python3-pip rpm
sudo pip3 install boto boto3 netaddr passlib bigsuds deepdiff 'ansible[azure]' 
ansible-galaxy install f5devcentral.f5app_services_package && ansible-galaxy collection install azure.azcollection --force

# Install Azure CLI 
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
# Install Terraform
TER_VER=`curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'` && sudo wget https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip && sudo unzip -o -q terraform_${TER_VER}_linux_amd64.zip && sudo mv terraform /usr/local/bin/ && sudo rm -f terraform_${TER_VER}_linux_amd64.zip

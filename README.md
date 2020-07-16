# vlab-azure

## F5 vLab in Azure

**Description**\
F5 vLab environment in Azure, using a 2-NIC or 3-NIC deployment
- Mgmt VLAN, default = 10.1.10.0/24
- External VLAN, default = 10.1.10.0/24
- Internal VLAN, default = 10.1.20.0/24
- Ubuntu server with several containers (pool members), default = 10.1.10.80
- F5 BIG-IP Best 200 Mbps, with LTM and ASM provisioned. 

**Requeriments**\
To run this playbooks you need:
- A Linux Server with Internet access (Ubuntu Server 18.04 Virtual Machine recommended) 
- Azure Account Information
  - [Subscription ID](https://portal.azure.com/?quickstart=true#blade/Microsoft_Azure_Billing/SubscriptionsBlade)
  - [Client ID (Application ID)](https://portal.azure.com/?quickstart=true#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade)
  - [Secret (Client Secret)](https://portal.azure.com/?quickstart=true#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade)
  - [Tenant ID (Directory ID)](https://portal.azure.com/?quickstart=true#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Overview)


### Part 1: Ubuntu Server > Install Ansible and tools
In your Linux Server install Ansible and additional requeriments needed to deploy the infrastructure in Azure.\
Note: This instructions are for Ubuntu v18.04 LTS, *you could use MacOS but you need to install ansible and python-pip using a package manger like `brew`.*

SSH into your Linux server, clone this repo, then go to `vlab-azure/` and check/run `install_ansible.sh`:

```
# install_ansible.sh

# Install Ansible & Dependencies (For Ubuntu 18.04 LTS)
sudo apt update
sudo apt-add-repository --yes ppa:ansible/ansible
sudo apt -y upgrade
sudo apt install -y software-properties-common ansible docker.io docker-compose python3-pip git rpm
pip3 install boto boto3 netaddr passlib f5-sdk bigsuds deepdiff 'ansible[azure]' 
ansible-galaxy install f5devcentral.f5app_services_package

# Install Azure CLI 
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

```

:warning: ***Please reboot you linux server after installing all packages !!!*** :warning:
<br />

### Part 2: Configure your Azure Credentials. 
You need your Subscription ID, Client ID, Secret and Tenant ID.

Create or edit the file `$HOME/.azure/credentials` with the following syntax and using your account info:
```
[default]
subscription_id=xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
client_id=xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
secret=xxxxxxxxxxxxxxxxx
tenant=xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

:heavy_check_mark: Note: You can use `azure-cli` to setup your Azure credentials instead.

### Part 3: Deploy Azure infrastructure using Ansible:

Go to folder `vlab-azure`\
Edit `config.yml` and change the `STUDENT_ID` parameter. ***Use lowercase letters and numbers only.***

Run the playbooks in order: (Use the correct playbook if you want to deploy a 3-NIC BIG-IP)
```
ansible-playbook 01_deploy_rg_vnet_azure.yml
ansible-playbook 02_deploy_ubuntu_docker_azure.yml
ansible-playbook 03_deploy_bigip_2nic_azure.yml
ansible-playbook 04_install_as3.yml
ansible-playbook 05_deployservices_as3.yml
ansible-playbook 06_get_information.yml
```
<br />

If you already have an Azure Account and get a 403 error like this, You need to add a **Contributor Role** to your Registered Application in Azure.
```
fatal: [localhost]: FAILED! => {"changed": false, "msg": "Error checking for existence of name vLAB-student - 403 Client Error:
Forbidden for url: https://management.azure.com/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourcegroups/vLAB-student?api-version=2017-05-10"}

```

### Playbooks Description: 

**Playbook 01: Azure Resources**\
The first playbook creates a Resource Group, a Security Group and a VNET (10.1.0.0/16) with 3 Subnets: Management (10.1.1.0/24), External (10.1.10.0/24) and Internal (10.1.20.0/24)

**Playbook 02: Ubuntu Docker Server**\
The second playbook deploys an Ubuntu Server with Docker and the following services, used as Pool members: 
- Port 8080   (Hackazon)
- Port 8443  (Hackazon HTTPS)
- Port 8081 (DVWA)
- Port 8082 (OWASP bwAPP)
- Port 8083 (OWASP Juice Shop)
- Port 8084 (Hello World, simple HTTP page)
- Port 8085 (NGINX default homepage)

**Playbook 03: BIG-IP**\
The third playbook deploys a 2-NIC or 3-NIC BIG-IP instance (PAYG) using a supported ARM template:\
https://github.com/F5Networks/f5-azure-arm-templates/tree/master/supported/standalone/2nic/existing-stack/payg \
https://github.com/F5Networks/f5-azure-arm-templates/tree/master/supported/standalone/3nic/existing-stack/payg

**Playbook 04: Install/Update AS3**\
We need AS3 version 3.20 to be able to configure all of the services. This version includes a feature to allow the same Virtual IP with different Virtual Servers (shareAddresses)

**Playbook 05: Deploy Services using AS3**\
Deploy all the services from Playbook #2 as Virtual Servers.\
Hackazon (8443) Virtual Server includes a WAF policy.

**Playbook 06: Get Infrastructure Information**\
The last playbook displays information relevant for the lab, and saves that information in a local file: **info.txt**
- Lamp Server Public IP and DNS Record
- BIG-IP Management IP & URL
- Virtual Server Public IP and DNS Record

<br />

  
## :heavy_exclamation_mark: DELETING THE LAB :heavy_exclamation_mark:
Do not forget to delete the resources created to avoid unwanted charges.

You can delete the Lab using the provided Ansible Playbook or manually deleting the Resource Group in Azure Portal
 
Go to `./vlab-azure` and run:

```
ansible_playbook 99_delete_lab_azure.yml
```
<br />
<br />
<br />
  
:poop:

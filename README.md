# aolab-azure

## F5 Automation & Orchestration Lab in Azure

**Requeriments**\
To run this lab you will need:
- A Linux Server with Internet access (Ubuntu 18.04 Virtual Machine recommended) 
- Azure Account Information
  - [Subscription ID](https://portal.azure.com/?quickstart=true#blade/Microsoft_Azure_Billing/SubscriptionsBlade)
  - [Client ID (Application ID)](https://portal.azure.com/?quickstart=true#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade)
  - [Secret (Client Secret)](https://portal.azure.com/?quickstart=true#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade)
  - [Tenant ID (Directory ID)](https://portal.azure.com/?quickstart=true#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/Overview)

This lab contains 3 parts:
1.  Ansible & Dependecies installation in a Linux server 
2.  Lab/Infrasctructure deployment in Azure
3.  A&O Lab (Provided PDF Guide)

### Part 1: 
In your Linux Server install Ansible and additional requeriments needed to deploy the infrastructure in Azure.\
Note: This instructions are for Ubuntu, *you could use MacOS but you need to install ansible and python-pip using a package manger like `brew`.*

SSH into your Linux server, clone this repo, then go to `aolab-azure/deploy-lab` and check/run `install_ansible.sh`:

```
# install_ansible.sh

# Install Ansible & Dependencies (For Ubuntu 18.04 LTS)
sudo apt update
sudo apt-add-repository --yes ppa:ansible/ansible
sudo apt -y upgrade
sudo apt install -y docker.io python3-pip docker-compose git ansible
pip3 install boto boto3 netaddr passlib f5-sdk bigsuds deepdiff 'ansible[azure]' 

# Install Azure CLI 
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

```

:warning: ***Please reboot you linux server after installing all packages !!!*** :warning:
<br />

### Part 2:
2a) Azure Credentials. 
You need your Subscription ID, Client ID, Secret and Tenant ID.

Create or edit the file `$HOME/.azure/credentials` with the following syntax and using your account info:
```
[default]
subscription_id=xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
client_id=xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
secret=xxxxxxxxxxxxxxxxx
tenant=xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

2b) Deploy Azure infrastructure using Ansible:

Go to folder `aolab-azure/deploy-lab`\
Edit `config.yml` and change the `STUDENT_ID` parameter. ***Use lowercase letters and numbers only.***

In the `deploy-lab` folder run the playbooks in order:
```
ansible-playbook 01_deploy_rg_vnet_azure.yml
ansible-playbook 02_deploy_ubuntu_docker_azure.yml
ansible-playbook 03_deploy_bigip_2nic_azure.yml
```
<br />

If you already have an Azure Account and get a 403 error like this:
```
fatal: [localhost]: FAILED! => {"changed": false, "msg": "Error checking for existence of name AO-LAB-student - 403 Client Error:
Forbidden for url: https://management.azure.com/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourcegroups/AO-LAB-student?api-version=2017-05-10"}

```
You need to add a **Contributor Role** to your Registered Application in Azure.

**01 Azure resources**\
The first playbook creates a Resource Group, a Security Group and a VNET (10.1.0.0/16) with 3 Subnets: Management (10.1.1.0/24), External (10.1.10.0/24) and Internal (10.1.20.0/24)

**02 Ubuntu Docker Server**\
The second playbook deploys an Ubuntu Server with Docker and the following services, used as Pool members: 
- Port 80   (Hackazon)
- Port 443  (Hackazon)
- Port 8081 (DVWA)
- Port 8082 (Hello World, simple HTTP page)
- Port 8083 (OWASP Juice Shop)
- Port 8084 (NGINX default homepage)
- Port 8085 (NGINX default homepage)

**03 BIG-IP**\
The third playbook deploys a 2-NIC BIG-IP instance (PAYG) using a supported ARM template:\
https://github.com/F5Networks/f5-azure-arm-templates/tree/master/supported/standalone/2nic/existing-stack/payg
<br />


### Part 3:
Refer to the provided guide to run through the A&O lab.\
:book: RTFM :book:
<br />
<br />
<br />
  
## :heavy_exclamation_mark: DELETING THE LAB :heavy_exclamation_mark:
At the end of the Lab do not forget to delete the resources created to avoid unwanted charges.

You can delete the Lab using the provided Ansible Playbook or manually deleting the Resource Group in Azure Portal
 
Go to `./aolab-azure/deploy-lab` and run:

```
ansible_playbook 99_delete_lab_azure.yml
```
<br />
<br />
<br />
  
:poop:

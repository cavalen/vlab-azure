# vlab-azure

## F5 vLab in Azure

**Description**\
Deploy F5 vLab environment in Azure, using a 2-NIC or 3-NIC deployment, using Ansible (2.9)

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

### Part 1: Download Ubuntu Container with all the necessary tools

You need a machine with Docker. Get Docker for Windows/Mac at [this link](https://www.docker.com/products/docker-desktop)\
Use a pre-configured Docker Container running Ubuntu and Ansible to deploy the infrastructure:\

From your command line, open an interactive console to the container:

```
docker run -it --name ubuntu-vlab cavalen/ubuntu18-vlab
```

### Part 2: Configure your Azure Credentials.

You need your Azure Subscription ID, Client ID, Secret and Tenant ID.

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
Edit `config.yml` and change the `STUDENT_ID` parameter. **_Use lowercase letters and numbers only._**

Run the playbooks in order:

```
ansible-playbook 01_deploy_rg_vnet_azure.yml
ansible-playbook 02_deploy_ubuntu_docker_azure.yml
ansible-playbook 03_deploy_bigip_2nic_azure.yml
ansible-playbook 04_install_as3_ts_do.yml
ansible-playbook 05_deployservices_as3.yml
ansible-playbook 06_get_information.yml
```

<br />

Note: If you need to deploy using your own license, use the corresponding playbook (ansible-playbook 03_deploy_bigip_2nic_byol_azure.yml) and update the parameter `BIGIP_LICENSE` in `config.yml` with a valid license.

Note: If you already have an Azure Account and get a 403 error like this, You need to add a **Contributor Role** to your Registered Application in Azure.

```
fatal: [localhost]: FAILED! => {"changed": false, "msg": "Error checking for existence of name vLAB-student - 403 Client Error:
Forbidden for url: https://management.azure.com/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourcegroups/vLAB-student?api-version=2017-05-10"}

```

### Playbooks Description:

**Playbook 01: Azure Resources**\
The first playbook creates a Resource Group, a Security Group and a VNET (10.1.0.0/16) with 3 Subnets: Management (10.1.1.0/24), External (10.1.10.0/24) and Internal (10.1.20.0/24)

**Playbook 02: Ubuntu Docker Server**\
The second playbook deploys an Ubuntu Server with Docker and the following services, used as Pool members:

- Port 8080 (Hackazon)
- Port 8443 (Hackazon HTTPS)
- Port 8081 (DVWA)
- Port 8082 (F5 DemoApp)
- Port 8083 (OWASP Juice Shop)
- Port 8084 (NGINX default homepage)
- Port 8085 (OWASP bwAPP, run /install.php to start)
- Port 3000 (Book Catalog API)

**Playbook 03: BIG-IP**\
The third playbook deploys a BIG-IP instance using a supported ARM template:\
https://github.com/F5Networks/f5-azure-arm-templates

**Playbook 04: Install/Update F5 Automation Toolchain (AS3, DO, TS)**\
This one installs the latest version of AS3, TS and DO \

**Playbook 05: Deploy Services using AS3**\
Deploy all the services from Playbook #2 as Virtual Servers.\
Hackazon (8443) Virtual Server includes a Declarative WAF policy.\
Local `as3.json` file is referenced by this playbook, and is the input for our declarative Rest API\

**Playbook 06: Get Infrastructure Information**\
The last playbook displays information relevant for the lab, and saves that information in a local file: **info.txt**

- Lamp Server Public IP and DNS Record
- BIG-IP Management IP & URL
- Virtual Server Public IP and DNS Record

**Playbook 07: Deploy Azure AKS**\
This optional playbook will deploy an AKS cluster with 2 Nodes, useful to test the F5 Container Ingress Service (CIS)
<br />

## :heavy_exclamation_mark: DELETING THE LAB :heavy_exclamation_mark:

Do not forget to delete the resources created to avoid unwanted charges $$$.

You can delete the Lab using the provided Ansible Playbook or manually deleting the Resource Group in Azure Portal

Go to `./vlab-azure` and run:

```
ansible_playbook 99_delete_lab_azure.yml
```

<br />

ToDo:

- Option to create BIG-IP VM from scratch, without using ARM template (?)
- Use the same NSG for BIG-IP and Ubuntu Server
- Pool member autodiscover
- Not working with Ansible 2.10 --> Migrate to MS Azure Collection (?)
  - https://github.com/ansible-collections/azure
  - https://cloudblogs.microsoft.com/opensource/2020/04/28/announcing-azcollection-the-ansible-collection-for-azure/
- Migrate to F5 Templates v2.0
- Shell Script to run all of the playbooks in order

<br />
<br />
<br />
  
:poop:

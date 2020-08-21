FROM ubuntu:18.04
#ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update && apt install -y software-properties-common sudo openssl git python3-pip unzip rpm curl wget nano &&  apt-add-repository --yes ppa:ansible/ansible && apt install -y ansible && apt-get clean
RUN pip3 install boto3 netaddr 'ansible[azure]' && rm -rf ~/.cache/pip/*
RUN curl -sL https://aka.ms/InstallAzureCLIDeb -o InstallAzureCLIDeb && bash InstallAzureCLIDeb
RUN useradd -rm -d /home/ubuntu -s /bin/bash -U -G sudo -u 1001 ubuntu -p "$(openssl passwd -1 ubuntu)"
USER ubuntu
# Collection azure.azcollection solves an issue deploying AKS
RUN ansible-galaxy install f5devcentral.f5app_services_package && ansible-galaxy collection install azure.azcollection --force
RUN TER_VER=`curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'` && wget https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip && unzip terraform_${TER_VER}_linux_amd64.zip && sudo mv terraform /usr/local/bin/
WORKDIR /home/ubuntu
RUN git clone https://github.com/cavalen/vlab-azure
RUN mkdir /home/ubuntu/.azure
COPY --chown=ubuntu credentials /home/ubuntu/.azure/
COPY --chown=ubuntu update-repo.sh /home/ubuntu/
COPY --chown=ubuntu bashrc /home/ubuntu/.bashrc

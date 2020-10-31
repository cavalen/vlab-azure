FROM ubuntu:18.04
ENV TZ=America/Bogota
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update && apt install -y --no-install-recommends tzdata software-properties-common sudo openssl openssh-client git python3-pip python3-setuptools python3-wheel unzip rpm curl wget nano gnupg2 jq\
 && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list\
 && apt update && apt install -y kubectl\
 && pip3 install 'ansible==2.9.14' \
 && pip3 install boto3 netaddr 'ansible[azure]' \
 && curl -sL https://aka.ms/InstallAzureCLIDeb -o InstallAzureCLIDeb && bash InstallAzureCLIDeb \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache/pip/*
RUN useradd -rm -d /home/ubuntu -s /bin/bash -U -G sudo -u 1001 ubuntu -p "$(openssl passwd -1 ubuntu)"
RUN TER_VER=`curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'` && wget https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip && unzip -o -q terraform_${TER_VER}_linux_amd64.zip && mv terraform /usr/local/bin/ && rm -f terraform_${TER_VER}_linux_amd64.zip
USER ubuntu
# Collection azure.azcollection solves an issue deploying AKS
RUN ansible-galaxy install f5devcentral.f5app_services_package && ansible-galaxy install f5devcentral.atc_deploy && ansible-galaxy collection install azure.azcollection --force
WORKDIR /home/ubuntu
RUN git clone https://github.com/cavalen/vlab-azure \
        && mkdir /home/ubuntu/.azure
COPY --chown=ubuntu credentials /home/ubuntu/.azure/
COPY --chown=ubuntu update-repo.sh /home/ubuntu/
COPY --chown=ubuntu bashrc /home/ubuntu/.bashrc

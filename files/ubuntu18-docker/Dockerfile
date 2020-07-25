FROM ubuntu:18.04
#ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update && apt install -y software-properties-common sudo openssl git python3-pip rpm curl wget nano &&  apt-add-repository --yes ppa:ansible/ansible && apt install -y ansible && apt-get clean
RUN pip3 install boto3 netaddr 'ansible[azure]' && rm -rf ~/.cache/pip/*
RUN curl -sL https://aka.ms/InstallAzureCLIDeb -o InstallAzureCLIDeb && bash InstallAzureCLIDeb
RUN useradd -rm -d /home/ubuntu -s /bin/bash -U -G sudo -u 1001 ubuntu -p "$(openssl passwd -1 ubuntu)"
USER ubuntu
RUN ansible-galaxy install f5devcentral.f5app_services_package
WORKDIR /home/ubuntu
RUN git clone https://github.com/cavalen/vlab-azure
RUN mkdir /home/ubuntu/.azure
COPY --chown=ubuntu credentials /home/ubuntu/.azure/
COPY --chown=ubuntu update-repo.sh /home/ubuntu/
COPY --chown=ubuntu bashrc /home/ubuntu/.bashrc

#!/bin/bash
RED="$(tput setaf 1)"
NC="$(tput sgr0)"

echo "===================================================="
echo "Cual es su Prefix ? (ej, su nombre, o sus iniciales): "
echo "${RED}Usar maximo 10, solo letras ${NC}"
echo ""
read -p "Prefix: " prefix
# remover lo que no sea letras, pasar a minuscula y tomar primeros 10 caracteres
prefix=$(echo "$prefix" | tr -dc '[:alpha:]' | tr '[:upper:]' '[:lower:]' | head -c 10)

if [ -z "$prefix" ] || [ ${#prefix} -lt 2 ]
then
   echo "Usando Prefix por defecto =student="
   prefix="student"
   sed -i 's/.*STUDENT_ID:.*/STUDENT_ID: student/' config.yml
   echo ""
else
   echo "Usando Prefix $prefix"
   sed -i 's/.*STUDENT_ID:.*/STUDENT_ID: '$prefix'/' config.yml
   echo ""
fi
echo ""
read -p "Desplegar AKS ? [y/n]: " -n 1 -r aks
echo ""
echo "Desplegando .... "
echo "$(date)"
echo ""
  ansible-playbook 01_deploy_rg_vnet_azure.yml\
  && ansible-playbook 02_deploy_ubuntu_docker_azure.yml\
  && ansible-playbook 03_deploy_bigip_2nic_azure.yml\
  && ansible-playbook 04_install_atc.yml\
  && ansible-playbook 05_deployservices_as3.yml

if [ $aks == 'Y' ] || [ $aks == 'y' ]
then
  ansible-playbook 07_aks_deploy.yml
fi
ansible-playbook 06_get_information.yml
echo "========================================"
echo "Finalizado"
echo "$(date)"
echo ""

#! /bin/bash

# usage list_vm_info <number of clusters> <dns_prefix> <resource group name>
# OS-count-nic-letter
# OS-count-public-ip-letter

cluster_count=$1
rg=$2
printf "\n--------------------------------------------------------------------------------------------------\n\n"
for count in $(seq -f "%02g" 1 $cluster_count)
do
  printf "Linux VMs\n"
  for letter in {a..c}
  do
    case $letter in
      "a") role="Workstation"
        ;;
      "b") role='Worker'
        ;;
      "c") role='Manager'
        ;;
    esac



    nic="lin-"$count"-nic-"$letter
    publicip="lin-"$count"-publicip-"$letter
    publicIP_info=$(az network public-ip show -g $rg -n $publicip --query "{DNS:dnsSettings.fqdn, IP:ipAddress}"  -o tsv)
    privateIP=$(az network nic show -g $rg -n $nic --query "ipConfigurations[0].privateIpAddress" -o tsv)
    set -- $publicIP_info
    printf '%s\t(%s)\t\t%s\t\t%s\n' $1 $role $2 $privateIP
  done

  printf "\nWindows VMs\n"
  for letter in {a..b}
  do
    case $letter in
      "a") role="Workstation"
        ;;
      "b") role="Worker"
        ;;
    esac

    nic="win-"$count"-nic-"$letter
    publicip="win-"$count"-publicip-"$letter
    publicIP_info=$(az network public-ip show -g $rg -n $publicip --query "{DNS:dnsSettings.fqdn, IP:ipAddress}"  -o tsv)
    privateIP=$(az network nic show -g $rg -n $nic --query "ipConfigurations[0].privateIpAddress" -o tsv)
    set -- $publicIP_info
    printf '%s\t(%s)\t\t%s\t\t%s\n' $1 $role $2 $privateIP
  done
  printf "\nWorkshop Materials: https://github.com/mikegcoleman/hybrid-workshop\n"
  printf "Username / Password: docker / Docker2017\n\n"
  printf "\n--------------------------------------------------------------------------------------------------\n\n"
done

# infra-teamcity terraform GKE

## Create VM Instance with scope of either all Google API's or specific Coz this code will play around with multiple API's

## And Do the required Setup


# tfenv - 

     - git clone https://github.com/tfutils/tfenv.git ~/.tfenv

     - sudo ln -s ~/.tfenv/bin/* /usr/local/bin

     - tfenv install 0.14.0

     - tfenv use 0.14.0

     - terraform --version
          Output - Terraform v0.14.0
<br>

# Docker - 
     - curl https://get.docker.com/ > getdocker.sh
     - chmod +x getdocker.sh
     - ./getdocker.sh
     - sudo usermod -aG docker ubuntu
<br>

# Docker-Composer -
     - sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
     - sudo chmod +x /usr/local/bin/docker-compose
     - docker-compose version
<br>

# Kubelete, kubectl, kubeadm - 
     - curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

     - cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
     - deb https://apt.kubernetes.io/ kubernetes-xenial main
     - EOF

     - sudo apt update
     - sudo apt install kubelet kubeadm kubectl
<br>

# GCP CLI Install -

     - https://cloud.google.com/sdk/docs/install#deb

# In Code Directory

## To initialize specific plugins for terraform
     - terraform init 
<br>

## To see what sort of things will be deployed with this code
     - terraform plan
<br>

## To deploy Things 
     - terraform apply
<br>

## Backend storage is bucket - state-storage-bucket-addoptify-terraform

## Terraform Code Explanation
     - Custom VPC
     - Custom Subnetwork
     - Firewall rules for Allowing Internal Communication
     - Firewall rules for Allowing ICMP
     - Firewall rules for Allowing SSH,RDP,HTTP,HTTPS
     - GKE private Cluster in this VPC
     - Custom two Node Pool (One for Teamcity-Master & One for Teamcity-Agent)
     - Teamcity-Master Node is with one worker node and size of node will be e2-standard-2
     - Teamcity-Agent-1 Node is with one worker node and size of node will be e2-medium & Node-Pool is Tainted "teamcity-agent-1" as well with Terraform Code
     - Teamcity-Agent-2 Node is with one worker node and size of node will be e2-medium & Node-Pool is Tainted "teamcity-agent-2" as well with Terraform Code
     - Teamcity-Agent-3 Node is with one worker node and size of node will be e2-medium & Node-Pool is Tainted "teamcity-agent-3" as well with Terraform Code
     - For Private Cluster communication with Internet Cloud-Nat is will be created
     - In custom VPC New Instance will be provision with the image of current instance for managing kubectl client, as communication is only possible for the one which is in the network.
     - Once the instance is provision add ssh key and run commands.sh for getting cred of cluster or manually run the command to get cred
     - Manually Add Port 80 and 8443 in firewall rule which is auto-generated for private cluster link - https://kubernetes.github.io/ingress-nginx/deploy/#gce-gke
     - CloudSQL Database with private IP only
     - No Root user configure Via Terraform, user can be configured through GUI For security purposes
     - Backend Storage For storing tfstate


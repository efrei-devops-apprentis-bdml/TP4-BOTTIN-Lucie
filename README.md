# TP4-BOTTIN-Lucie

## Contexte du TP :

Dans ce TP, le but était de se familiariser avec Azure et créer une machine virtuelle dans le cloud grâce à Terraform.

## Première étape :

Tout d'abord nous devons créer les fichiers de configuration Terraform :
- data.tf

```terraform
data "azurerm_resource_group" "tp4" {}

data "azurerm_virtual_network" "net_tp4" {} 

data "azurerm_subnet" "sub_tp4" {}
```
Ce fichier contient les configurations du groupe de ressources, du réseau et sous réseau préalablement créés dans le cloud Azure.

- network.tf

````terraform
resource   "azurerm_public_ip"   "myvmpublicip"   {} 

 resource   "azurerm_network_interface"   "myvm"   {} 

resource "azurerm_network_security_group" "security" {}

resource "azurerm_network_interface_security_group_association" "example" {}

resource "tls_private_key" "example_ssh" {}


 resource   "azurerm_linux_virtual_machine"   "vm"   { 

   source_image_reference   {} 


   os_disk   {} 

   admin_ssh_key {}
 } 
 ````
Ce fichier permet de définir l'adresse IP publique de notre réseau, générer une interface et la sécuriser grâce à une clé privée SSH. 

- provider.tf

```terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "765266c6-9a23-4638-af32-dd1e32613047"
}
``` 

Le fichier provider permet de configurer l'accès à Azure avec notre souscription.

- output.tf

```terraform

output "resource_group_name" {
  value = data.azurerm_resource_group.tp4.name
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.vm.public_ip_address
}

output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}
```
Ici, nous mettons des outputs pour que les informations nécessaires soient visibles sur la console. Par exempl,e nous avons configurer un clé privé mais elle ne peut pas être accessible par n'importe qui. Nous devons alors créer une clé publique à partir de cette dernière. La clé privée est *sensitve* donc ne sera pas afficher

## Commandes pour créer le nécessaire :

Initialiser les fichiers Terraform à partir des fichiers de configuration 

```shell
terraform init
```
Appliquer les changements
```shell
terraform plan
```
Créer les ressources
```shell
terraform apply
```
Ensuite, pour créer la clé privée et la stocker dans un fichier texte id_rsa
```shell
terraform output -raw tls_private_key > id_rsa
```
On peut récupérer l'adresse IP cotenu dans le fichier output 
```shell
terraform output public_ip_address

> Outputs:

public_ip_address = "20.111.20.40"
resource_group_name = "devops-TP2"
tls_private_key = <sensitive>
```
Commande finale à exécuter :
```shell
sudo ssh -i id_rsa devops@IP_ADRESS cat /etc/os-release
``` 
```shell
NAME="Ubuntu"
VERSION="16.04.7 LTS (Xenial Xerus)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 16.04.7 LTS"
VERSION_ID="16.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
VERSION_CODENAME=xenial
UBUNTU_CODENAME=xenial
```
## Avantages de Terraform

Utiliser Terraform permet de créer, modifier notre infrastructure très facilement et rapidement, directement dans le code source ce qui évite de la faire dans azure. 
La vitesse et la sécurité sont aussi des avantages majeurs, avec ces plans d’exécution, Terraform permet de connaître exactement les changements qui vont être mis en place, avant qu’ils ne soient exécutés.


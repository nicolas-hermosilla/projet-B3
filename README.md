# Readme.md
![](https://fredericfaure.files.wordpress.com/2014/02/logo_docker.png?w=676)  
![ubuntu](https://img.shields.io/badge/ubuntu-20.04-orange.svg)
![docker](https://img.shields.io/badge/docker-up-blue.svg)
![dockerhub](https://img.shields.io/badge/docker-hub-white.svg)
![docker-compose](https://img.shields.io/badge/docker-compose-green.svg)
![registry](https://img.shields.io/badge/docker-registry-white.svg)
![github](https://img.shields.io/badge/github-repository-blue.svg)  
![portainer](https://img.shields.io/badge/portainer-admin-blue.svg)
![grafana](https://img.shields.io/badge/grafana-monitor-orange.svg)
![cadvisor](https://img.shields.io/badge/cAdvisor-metrics-white.svg)
![prometheus](https://img.shields.io/badge/prometheus-datasource-orange.svg)
![jenkins](https://img.shields.io/badge/jenkins-deploy-red.svg)    
## Infrastructure as a Code et Conteneurisation
**Table des matières**

# Introduction
Bienvenue sur le projet d'Infrastructure as a Code et Conteneurisation.  
Le but de ce projet est de déployer une infrastructure de services en quelques commandes.  

### Liste des services
- Administration des services de l'infra avec [Portainer](https://www.portainer.io/)
- Monitoring des applications conteneurisées [Grafana](https://grafana.com/), [Prometheus](https://prometheus.io/) et [cAdvisor](https://github.com/google/cadvisor)
- Gestion des images avec [Registry](https://docs.docker.com/registry/)
- Déploiement continu et test du code avec [Jenkins](https://www.jenkins.io/)  

### Les outils utilisées
- [VMWare Workstation Pro 16](https://www.vmware.com/products/workstation-pro/workstation-pro-evaluation.html)
- [Ubuntu](https://ubuntu.com/download/desktop)
- [Docker](https://www.docker.com/)
- [Docker-compose](https://docs.docker.com/compose/)
- [Docker Hub](https://hub.docker.com/)
- [GitHub](https://github.com/)

# Déploiement du projet

## Pré-requis 

#### Outil de virtualisation
Afin de mettre en place l'infrastructure, installez un outil de virtualisation (VMWare/Virtual box).  

#### Image Ubuntu
Préparez une **machine virtuelle [Ubuntu](https://ubuntu.com/download/desktop/thank-you?version=20.04.2.0&architecture=amd64)** de préférence en **Desktop** avec une configuration minimale : 
| RAM | Cœurs | Disk  | Network  | 
| :---|:-----:| ------: | ------:|
| 4GB | 4     | 100GB | NAT (DHCP) |

#### Commandes à lancer en amont sur la machine virtuelle
`sudo -i`  
`apt-get update`  
`apt install -y git`        
`apt install -y net-tools`  
`apt install -y openssh-server`  
`ssh-keygen`  

### Configuration de l'authentification sur GitHub

Après avoir lancé la commande `ssh-keygen`, allez dans le dossier `.ssh` et récupérez la clé **id_rsa.pub**.  
Sur GitHub, accédez à l'onglet de [création d'un nouveau clé ssh](https://github.com/settings/ssh/new) et ajoutez la clé publique.
Ensuite lancez les commandes suivantes en renseignant les informations respectives :

`git config --global user.name "github_pseudo"`  
`git config --global user.email "github_email"`  

Cette étape vous permettra de faire des actions sur votre repository sans avoir à vous authentifier à chaque action.  
Elle vous évitera également de renseigner votre mot de passe en clair, ce qui pourrait constituer un problème de sécurité.

Clonez ensuite votr projet sur votre serveur avec la commande suivante : 

`git clone git@github.com:nicolas-hermosilla/projet-B3.git`

La dernière étape consiste à créer votre repository sur votre GitHub et de le cloner sur votre serveur.  
Déplacer les fichiers du repo vers votre repo et faites votre premier push.

`git add .`  
`git commit -m "my-first-commit"`  
`git push`  


## Adapter la configuration de votre serveur pour le déploiement de l'infrastructure

### Exécution du script d'installation de **docker** et **docker-compose**

Après avoir récupérer les données, allez dans le repository de votre serveur et retrouvez le script **install-docker.sh**.  
Donnez les droits d'exécution à ce fichier et lancer le script pour installer docker et docker-compose.  
`chmod u+x install-docker.sh`  
`./install-docker.sh`

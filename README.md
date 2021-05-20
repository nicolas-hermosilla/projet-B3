<p align="center">  
  <img width="380" height="300" src="https://fredericfaure.files.wordpress.com/2014/02/logo_docker.png?w=676">
</p>
<h1 align="center">
  Infrastructure as Code et Conteneurisation
</h1>
<br>
  
  
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

<br>

# Introduction
Bienvenue sur le projet d'Infrastructure as Code et Conteneurisation.  
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
<br> 
  
# Déploiement du projet

## Pré-requis 
  
#### Outil de virtualisation
Afin de mettre en place l'infrastructure, installer un outil de virtualisation (VMWare/Virtual box).  

#### Image Ubuntu
Préparer une **machine virtuelle [Ubuntu](https://ubuntu.com/download/desktop/thank-you?version=20.04.2.0&architecture=amd64)** de préférence en **Desktop** avec une configuration minimale : 
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

Après avoir lancé la commande `ssh-keygen`, aller dans le dossier `.ssh` et récupérez la clé **id_rsa.pub**.  
Sur GitHub, accéder à l'onglet de [création d'un nouveau clé ssh](https://github.com/settings/ssh/new) et ajouter la clé publique.
Ensuite lancer les commandes suivantes en renseignant les informations respectives :

`git config --global user.name "github_pseudo"`  
`git config --global user.email "github_email"`  

Cette étape vous permettra de faire des actions sur votre repository sans avoir à vous authentifier à chaque action.  
Elle vous évitera également de renseigner votre mot de passe en clair, ce qui pourrait constituer un problème de sécurité.

Cloner ensuite votre projet sur votre serveur avec la commande suivante : 

`git clone git@github.com:nicolas-hermosilla/projet-B3.git`

La dernière étape consiste à créer votre repository sur votre GitHub et de le cloner sur votre serveur.  
Déplacer les fichiers du repo vers votre repo et faites votre premier push.

`git add .`  
`git commit -m "my-first-commit"`  
`git push`  
<br>
  
## Adapter la configuration de votre serveur pour le déploiement de l'infrastructure

### Exécution du script d'installation de **docker** et **docker-compose**

Après avoir récupérer les données, aller dans le repository de votre serveur et retrouver le script **install-docker.sh**.  
Donner les droits d'exécution à ce fichier et lancer le script pour installer docker et docker-compose.  
`chmod u+x install-docker.sh`  
`./install-docker.sh`  
<br>
    
## Création des différents volumes

A la racine de votre repo, donner les droits d'éxecution :  
`chmod u+x create_volume.sh`  
  
Lancer le script `./create_volume.sh`
  
Ce script va créer les différents volumes associés aux services respectifs.  
Il va également déplacer le fichier de configuration de prometheus dans le volume de prometheus et ce fichier sera pris en compte lors du déploiement du service.  
<br>
  
## Mise en place du déploiement continu
  
### Configuration de Jenkins

Lancer le script **run.sh** situé dans le dossier administration.  
`./run.sh`  
  
Depuis la console, récupérer le mot de passe administrateur de Jenkins avec la commande   
`docker logs jenkins`  
  
Accéder à Jenkins depuis l'addresse `0.0.0.0:8082` et y insérer le mot de passe.  
  
#### Installer les plugins Docker et Blue Ocean :  
Administrer Jenkins &#8594; Gestion des plugins &#8594; Disponible  
  
#### Configurer Docker sur Jenkins :  
- Depuis Administrer Jenkins &#8594; Configurer le système, aller tout en bas de la page sur **separate configuration page**  
- Sélectionner Docker et Docker Cloud détails pour y insérer l'URL `unix:///var/run/docker.sock`   
- Séléctionner **Enabled** et tester la connexion.  
- Sauvegarder les modifications.  
  
#### Vérification des services docker :  
Administrer Jenkins &#8594; Docker  
  
### Automatisation des scan du repo ###  
  
- Sur Jenkins, sélectionner **nouvel item**  
- Nommer votre projet et séléctionner **projet free-style**  
- Sélectionner **Gthub project** et insérer l'url de votre repo.  
- **Gestion du code source** : Séléctionner Git et insérer l'URL du repo.  
- **Branch to build** : Ne pas spécifier de branche spécifique.  
- **Ce qui déclenche le build** : Sélectionner **Scrutation de l'outil de gestion de version** et mettre * * * * * pour une vérification du repo chaque minute.  
- **Ajouter une étape au build** : Sélectionner **Exécuter un script shell** et y ajouter :  
`cd services`    
`./run.sh`  
  
Après chaque modification de repo, vous pouvez visualiser sur Jenkins les logs dans **historique des builds** ou directement depuis **Blue ocean**  
  
#### Si vous avez un serveur en ligne :  
  
Sur Jenkins, accéder directement à Blue ocean en connectant à votre Git.  
Créer votre webhook dans les paramètres de votre repo sur GitHub en insérant l'ip publique de votre serveur (exemple: https://192.168.5.128:8082/github-webhook/)  
Cette configuration notifiera directement Jenkins dès lors qu'une modification sera faite par l'intérmédiaire de ce webhook et scannera automatiquement le repos.  
<br>  
 
## Monitoring

- Une fois que l'infrastructure est déployée sur votre serveur, accéder à Grafana depuis l'url https:0.0.0.0:3000.
- Authentifiez-vous (user:admin password:admin)
- Aller dans **Configuration/Data Sources** et ajouter une nouvelle Data Source prometheus.

Renseigner les paramètres suivants :
- URL : http://prometheus:9090
- Skip TLS Verify

Tester ensuite la datasource en sauvegadant les paramètres.

- Accéder à **Dashboard/Manage** et importer le dashboard en renseignant l'ID 193 [source](https://grafana.com/grafana/dashboards/193)
- Sélectionner la datasource **Prometheus**

#!/bin/bash

###############################################################
#  TITRE: 
#
#  AUTEUR:   
#  VERSION: 
#  CREATION:  
#  MODIFIE: 
#
#  DESCRIPTION: 
#   
#         
###############################################################


echo -n " 
taper une option parmis : 
    - start : demarrer les services
    - stop : arreter les services
    - infos : obtenir les IP
    - add-user: ajouter un utilisateur sur un serveur web à preciser
    - lister-container : liste par ID,NAME et STATUS uniquement
    - connexion-VM : ssh avec exec sur les VMs
    - le reste : unknown
    ==> : 
"

read option
# ==> c'est avec read qu'on nous demande de taper un des options citées
case $option in
    start)
    echo -n "demarrage des containers"
    docker-compose start
    ;;

    stop)
    echo -n "arret des containers"
    docker-compose stop
    ;;

    lister-container)
    echo -n "liste des containers qui tournent"
    docker-compose ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"
    ;;
     
    infos-VM)
    echo -n "==> ip des containers :
    "
    docker network inspect -f \
    '{{json .Containers}}' $(docker network ls | grep docker_ansible_default | awk '{print $1}') | \
    jq '.[] | .Name + " : ==> " + .IPv4Address'
    ;;

    add-user)
    echo -n " Entrer le nom de l'utilisateur (devops) : 
    "
    read nom
    docker network inspect -f \
    '{{json .Containers}}' $(docker network ls | grep docker_ansible_default | awk '{print $1}') | \
    jq '.[] | .Name + " : ==> " + .IPv4Address'
    sleep 3
    echo -n " Entrer le nom de la VM : "
    read VM
    echo "    => création de l'utilisateur  ${nom}"
    docker exec $VM /bin/bash -c "useradd -m -p password $nom"
    docker exec -ti $VM /bin/bash -c "echo '${nom}   ALL=(ALL) NOPASSWD: ALL' >>/etc/sudoers"
    ;;
                        # devops  ALL=(ALL) NOPASSWD: ALL
    connexion-VM)
    docker network inspect -f \
    '{{json .Containers}}' $(docker network ls | grep docker_ansible_default | awk '{print $1}') | \
    jq '.[] | .Name + " : ==> " + .IPv4Address'
    sleep 3
    echo -n " ==> connexion sur le serveur
    "
    echo -n " Entrer le nom de la VM : "
    read VM
    docker exec -ti $VM /bin/bash
    ;;

    *)
    echo -n "unknown
    "
    ;;
esac
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
    - add-user : ajouter un utilisateur
    - lister-container : liste par ID,NAME et STATUS uniquement
    - connexion-master : ssh avec exec sur master ansible
    - le reste : unknown
    ==> : 
"

read option

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
     
    infos)
    echo -n "==> ip des containers :
    "

    docker network inspect -f \
    '{{json .Containers}}' $(docker network ls | grep docker_ansible_default | awk '{print $1}') | \
    jq '.[] | .Name + " : ==> " + .IPv4Address'
    ;;

    add-user)
    echo -n "ajout utilisateur sur le master ansible : "
    read nom
    echo "    => création de l'utilisateur  ${nom}"
    docker exec -ti docker_ansible_master_1 /bin/bash -c "useradd -m -p password $nom"
    docker exec -ti docker_ansible_master_1 /bin/bash -c "echo '${nom}   ALL=(ALL) NOPASSWD: ALL'>>/etc/sudoers"
    ;;

    connexion-master)
    echo -n " ==> connexion sur le master"
    docker exec -ti docker_ansible_master_1 /bin/bash
    ;;

    *)
    echo -n "unknown"
    ;;
esac
#!/bin/bash
##################################################################
##	deploy.sh <web.zip> <project_name> <docker_repo>	##
##################################################################
if ! [[ ! -z "$1" && ! -z "$2" && ! -z "$3" ]];
then
	echo "deploy.sh <web.zip> <project_name> <docker_repo> " >&2
	exit 1
fi

if ! [ $(id -u) = 0 ]
then
	echo "The script need to be run as root." >&2
	exit 1
fi

if [ $SUDO_USER ]
then
    real_user=$SUDO_USER
else
    real_user=$(whoami)
fi
docker pull tomsik68/xampp
docker run -it -d --name $2 tomsik86/xampp
docker cp $1 $2:/opt/lampp/htdocs/
docker commit $2 $2
docker tag $2 $3
docker push $2
mkdir ~/src/$2
cd ~/src/$2
devspace init
devspac create $2
devspace use $2
devspace deploy
devspace open

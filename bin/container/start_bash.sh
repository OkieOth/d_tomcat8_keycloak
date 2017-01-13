#!/bin/bash

scriptPos=${0%/*}

source "$scriptPos/conf.sh"
source "$scriptPos/../../../bin/image_conf.sh"

docker ps -f name="$contNameServer" | grep "$contNameServer" > /dev/null && echo -en "\033[1;31m  the container already runs: $contNameServer \033[0m\n" && exit 1

aktImgName=`docker images |  grep -G "$imageBase *$imageTag *" | awk '{print $1}'`
aktImgVers=`docker images |  grep -G "$imageBase *$imageTag *" | awk '{print $2}'`

if [ "$aktImgName" == "$imageBase" ] && [ "$aktImgVers" == "$imageTag" ]
then
        echo "run container from image: $aktImgName:$aktImgVers"
else
	if docker build -t $imageName $scriptPos/../../../image
    then
        echo -en "\033[1;34m  image created: $imageName \033[0m\n"
    else
        echo -en "\033[1;31m  error while build image: $imageName \033[0m\n"
        exit 1
    fi
fi

contNameServer=${contNameServer}_bash

extConfDir=$scriptPos/../extraConf
if ! [ -d $extConfDir ]; then
    mkdir -p $extConfDir
fi
extConfDir=`pushd $extConfDir > /dev/null; pwd ; popd > /dev/null`

extSitesConfDir=$scriptPos/../extraSitesConf
if ! [ -d $extSitesConfDir ]; then
    mkdir -p $extSitesConfDir
fi
extSitesConfDir=`pushd $extSitesConfDir > /dev/null; pwd ; popd > /dev/null`

extDataDir=$scriptPos/../extraData
if ! [ -d $extDataDir ]; then
    mkdir -p $extDataDir
fi
extDataDir=`pushd $extDataDir > /dev/null; pwd ; popd > /dev/null`

echo "$toHostPort"

#ls -l $extConfDir
#ls -l $extSitesConfDir
#ls -l $extDataDir

echo "map container port 80 -> host port $toHostPort"
docker run --rm -it --name "$contNameServer" --cpuset-cpus=0-2 -p $toHostPort:80 -v ${extConfDir}:/opt/extra-conf-enabled -v ${extSitesConfDir}:/opt/extra-sites-enabled -v ${extDataDir}:/opt/extra-data "$imageName" /bin/bash



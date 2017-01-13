#!/bin/bash

scriptPos=${0%/*}

source "$scriptPos/image_conf.sh"

aktImgName=`docker images |  grep -G "$imageBase *$imageTag *" | awk '{print $1}'`
aktImgVers=`docker images |  grep -G "$imageBase *$imageTag *" | awk '{print $2}'`
if [ "$aktImgName" == "$imageBase" ] && [ "$aktImgVers" == "$imageTag" ]
then
    # image already exists
    aktImgId=`docker images |  grep -G "$imageBase *$imageTag *"* | awk '{print $3}'`
fi

pushd "$scriptPos/.." > /dev/null
	if docker build -t $imageName image
    then
        echo -en "\033[1;34m  Image created: $imageName \033[0m\n"
        if ! [ -z "$aktImgId" ]; then
            if ! docker rmi --force $aktImgId; then
                echo -en "\033[1;31m  Error while remove old image: $imageName, ID: $aktImgId \033[0m\n"
            else
                echo -en "\033[1;34m  Old image deleted: $aktImgId \033[0m\n"
            fi
        fi
    else
        echo -en "\033[1;31m  Error while create image: $imageName \033[0m\n"
    fi
popd > /dev/null



#!/bin/bash

scriptPos=${0%/*}

if [ $# -eq 0 ]; then 
        echo -en "\033[1;34m the name of the container directory is as parameter needed \033[0m\n"
        echo "  $0 testHttpd"
        exit 1
fi
destDir=$scriptPos/../container/$1

if [ -d $destDir ]; then
        echo -en "\033[1;31m  destination directory already exists: $destDir \033[0m\n"
        exit 1
fi

echo -en "\033[1;34m  initialize directory: $destDir \033[0m\n"

mkdir -p  $destDir/bin
cp $scriptPos/container/sample_conf.sh $destDir/bin/conf.sh
pushd $destDir/bin > /dev/null
ln -s ../../../bin/container/del_server.sh
ln -s ../../../bin/container/start_bash.sh
ln -s ../../../bin/container/start_server.sh
ln -s ../../../bin/container/stop_server.sh
popd > /dev/null

# directory for the extra configuration. contained *.conf files are linked to /etc/apache2/conf-enabled 
mkdir -p  $destDir/extraConf
echo <<README > $destDir/extraConf/README.txt
*.conf files are here located will be linked to /etc/apache2/conf-enabled
other file types will be ignored
README

# directory for the extra sites configuration. contained *.conf files are linked to /etc/apache2/sites-enabled 
mkdir -p  $destDir/extraSitesConf
echo <<README2 > $destDir/extraSitesConf/README.txt
*.conf files are here located will be linked to /etc/apache2/sites-enabled
other file types will be ignored
README2

# additional directory for instance for static stuff, is mounted to /opt/extra-data
mkdir -p  $destDir/extraData
echo <<README3 > $destDir/extraData/README.txt
here can be extra ordner located that are referenced in extra configurations.
for instance static stuff like Javascript and CSS or certificates for SSL
README3



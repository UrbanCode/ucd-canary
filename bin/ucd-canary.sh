#!/bin/sh
# (C) Copyright IBM Corporation 2016.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#Define a UCD application consisting of a file of random data that can be deployed to verify end to end connectivity
#Script requires udclient be installed on the path.
#Default file size is 10M. Specify and integeger for $1 to create a file of !1 Megabytes.

cd $(dirname "$0")
MB=$1
MB="${MB:-10}"
case $MB in
    ''|*[!0-9]*) MB=10 ;;  #first parameter is not a number
    *) shift;;             #firts parameter is a number so consume it
esac

#Create temp working directory
canaryComponentBase=$(mktemp -d -t canary-XXXX)

#clean up on finish
finish () {
  rm -rf $canaryComponentBase
  cd - >/dev/null 2>&1
}
trap finish EXIT

help () {
    echo "Syntax: $0 [num]  --authtoken <yourauthtoken> --weburl <your ucd> [ud client options] "
    echo "num is an integer, represening the size of canaryfile you want to generate in megabytes."
    echo "yourauthtoken: Authentication token for accessing UCD APIS"
    echo "your ucd: URL of your UCD server. e.g. https://localhost:8443"
    echo "[ud client options]"
    exit 1
}


#Create the canary component files
echo "Creating $MB megabyte canary file in $canaryComponentBase"
canaryComponentRoot="$canaryComponentBase/canary"
mkdir -p $canaryComponentRoot/1.0
canaryFile="$canaryComponentRoot/1.0/canaryfile"
if ! dd if=/dev/urandom of=$canaryFile bs=1048576 count=$MB >/dev/null 2>&1; then
    help
fi


#Ensure udclient is accessible
if ! type "udclient" >/dev/null 2>&1; then
  echo
  echo "You must dwnload and install udclient somwhere on your path before you can import the canary application."
  exit 1
fi


#Define the component in UCD
mkdir -p "$canaryComponentBase/scratch"

cat ./json/createComponent.json |  sed -e 's#newcomponent#'$canaryComponentRoot'/#g' >$canaryComponentBase/scratch/createComponent.json
cat $canaryComponentBase/scratch/createComponent.json

udclient $* createComponent $canaryComponentBase/scratch/createComponent.json
udclient $* importVersions  json/importComponent.json
udclient $* createComponentProcess json/createComponentDeployProcess.json
udclient $* createApplication  json/createApplication.json
udclient $* addComponentToApplication -application "Canary Application" -component "Canary Component"
udclient $* createApplicationProcess json/createApplicationDeployProcess.json
udclient $* createEnvironment -application "Canary Application" -name "Birdcage" -color "#FFCF01"
udclient $* createResource json/createResource.json
udclient $* addEnvironmentBaseResource -application "Canary Application" -environment "Birdcage" -resource "/Aviary"

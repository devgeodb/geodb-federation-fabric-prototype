# !/bin/bash

check_returnCode() {
        if [ $1 -eq 0 ]; then
                echo -e "INFO:.... El proceso se ha ejecutado con éxito"
        else
                >&2 echo -e "ERROR:.... El proceso se ha ejecutado con error: $1"
                echo -e "INFO:Saliendo..."
                exit $1
        fi
}

checkCURL(){
  command -v curl >/dev/null 2>&1 || { installCURL; }
}

installCURL(){
  echo
  echo "========================================================="
  echo "Now installing CURL"
  echo "========================================================="
  echo

  sleep 1s

  apt-get install curl -y
}

checkDocker(){
  command -v docker >/dev/null 2>&1 || { installDocker; }
}

installDocker(){
  echo
  echo "========================================================="
  echo "Now installing docker"
  echo "========================================================="
  echo

  sleep 1s

  apt-get install docker.io -y

  addUser=`logname`
  usermod -a -G docker $addUser
}

checkDockerCompose(){
  command -v docker-compose >/dev/null 2>&1 || { installDockerCompose; }
}

installDockerCompose(){
  echo
  echo "========================================================="
  echo "Now installing docker-compose"
  echo "========================================================="
  echo

  sleep 1s

  apt-get install docker-compose -y
}

installLibtool(){

  echo
  echo "========================================================="
  echo "Now installing libtool"
  echo "========================================================="
  echo

  sleep 1s

  apt-get install libtool libltdl-dev -y
}

checkCURL(){
  command -v jq >/dev/null 2>&1 || { installJQ; }
}

installJQ(){
  echo
  echo "========================================================="
  echo "Now installing JQ"
  echo "========================================================="
  echo

  sleep 1s

  apt-get install jq -y
}

if [ `id -u` != "0" ]; then
  echo "Please, run as root"
  exit 1
fi

checkCURL
check_returnCode $?

checkDocker
check_returnCode $?

checkDockerCompose
check_returnCode $?

checkJQ
check_returnCode $?

installLibtool
check_returnCode $?

echo
echo "========================================================="
echo "It is required to reboot before continuing the setup"
echo "========================================================="
echo

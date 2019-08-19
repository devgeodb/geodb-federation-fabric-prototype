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

checkDependencies(){
  command -v curl >/dev/null 2>&1 || { echo "cURL not found. Please, run install-dependencies.sh as root"; exit 1; }
  command -v docker >/dev/null 2>&1 || { echo "docker not found. Please, run install-dependencies.sh as root"; exit 1; }
  command -v docker-compose >/dev/null 2>&1 || { echo "docker-compose not found. Please, run install-dependencies.sh as root"; exit 1; }
}

checkGo(){
  command -v go >/dev/null 2>&1 || { installGo; }
}

installGo(){
  echo
  echo "========================================================="
  echo "Now installing go"
  echo "========================================================="
  echo

  sleep 1s

  if [ -d "$HOME/go" ]; then
    echo "Removing $HOME/go"
    rm -rf $HOME/go
  fi

  wget https://dl.google.com/go/go1.12.5.linux-amd64.tar.gz -O /tmp/golang.tar.gz
  tar -xvf /tmp/golang.tar.gz --directory $HOME

}

checkEnvironment(){

  echo
  echo "========================================================="
  echo "Checking and setting ENV"
  echo "========================================================="
  echo

  sleep 1s

  while IFS="" read -r checkVar || [ -n "$p" ]
  do
    if grep -Fxq "$checkVar" $HOME/.profile
    then
        echo "$checkVar IS SET"
    else
        echo $checkVar >> $HOME/.profile
    fi
  done < fabric-environment
}

installFabric(){

  echo
  echo "========================================================="
  echo "Now installing Hyperledger Fabric"
  echo "========================================================="
  echo

  sleep 1s

  currDir=`pwd`

  if [ ! -d "$HOME/hyperledger" ]; then
    echo "Creating $HOME/hyperledger"
    mkdir $HOME/hyperledger
  fi

  cd $HOME/hyperledger

  curl -sSL http://bit.ly/2ysbOFE | bash -s -- 1.4.1 1.4.1 0.4.15

  mv fabric-samples fabric-samples-1.4.1

  cd $currDir

  if [ ! -d "$HOME/go-lib" ]; then
    echo "Creating $HOME/go-lib"
    mkdir $HOME/go-lib
  fi

  echo
  echo "========================================================="
  echo "Setting up FABRIC-CA"
  echo "========================================================="
  echo

  GOPATH=$HOME/go-lib $HOME/go/bin/go get -u github.com/hyperledger/fabric-ca/cmd/...
}

installGeodb(){

  echo
  echo "========================================================="
  echo "Now installing GeoDB bootstrap scripts"
  echo "========================================================="
  echo

  sleep 1s

  git clone https://github.com/GeoDB-Limited/geodb-federation-fabric-prototype $HOME/geodb
}

checkDependencies
check_returnCode $?

checkGo
check_returnCode $?

checkEnvironment
check_returnCode $?

installFabric
check_returnCode $?

installGeodb
check_returnCode $?

echo
echo "========================================================="
echo "Setup is now complete. Please reboot the system."
echo "========================================================="
echo

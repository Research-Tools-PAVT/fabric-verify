#https://github.com/chaifeng/bento-ubuntu-docker/blob/master/Vagrantfile-bento

if [ -z $SUDO_USER ]
then
    echo "===== Script need to be executed with sudo ===="
    echo "Change directory to 'setup'"
    echo "Usage: sudo ./docker.sh"
    exit 0
fi

export DOCKER_VERSION=17

apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
#    apt-get install -y "docker-ce=${DOCKER_VERSION}.*"
apt-get install -y "docker-ce"
docker info
# usermod -aG docker vagrant
echo "======= Adding $USER to the docker group ======="
usermod -aG docker $SUDO_USER

echo "======= Done. PLEASE LOG OUT & LOG Back In ===="
echo "Then validate by executing    'docker ps'"

# Restart is needed after this


# local_k8s.sh https://github.com/kubernetes/kubernetes.git master v1.20.2

# Install Docker
cd /tmp

# Install Docker
apt-get update
apt-get -y install make docker.io
systemctl enable docker

# Install Golang 1.15
wget https://dl.google.com/go/go1.15.linux-amd64.tar.gz
sudo tar -xvf go1.15.linux-amd64.tar.gz
sudo mv go /usr/local

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin

# Install Kind
curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.9.0/kind-$(uname)-amd64"
chmod +x ./kind
mv ./kind /usr/local/bin/kind

# Install Kubectl
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Clone k8s, My branch
mkdir -p $(go env GOPATH)/src/k8s.io/
cd $(go env GOPATH)/src/k8s.io/
git clone -b $2 --depth 1 $1

# My custom release
export KUBE_GIT_VERSION=$3

# Build a node image and create a cluster with
# To cleanup docker images $ docker rmi $(docker images -a -q)
kind build node-image
kind create cluster --image kindest/node:latest

# kubectl cluster-info --context kind-kind
# kubectl apply -f https://k8s.io/examples/application/deployment.yaml

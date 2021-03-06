#!/bin/bash -e
#bdereims@gmail.com

COMPOSE_VERSION=1.25.0
HELM_VERSION=3.0.0 
KUBECTL_VERSION=1.16.3
SHIP_VERSION=0.40.0
STERN_VERSION=1.11.0
COMPLETIONS=/etc/bash_completion.d

curl -L -o /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-Linux-x86_64 && chmod +x /usr/local/bin/docker-compose

curl -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && chmod +x /usr/local/bin/kubectl

curl -L -o /usr/local/bin/stern https://github.com/wercker/stern/releases/download/${STERN_VERSION}/stern_linux_amd64 && chmod +x /usr/local/bin/stern

curl -L https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar zx -C /usr/local/bin --strip-components=1 linux-amd64/helm

curl -L https://github.com/replicatedhq/ship/releases/download/v${SHIP_VERSION}/ship_${SHIP_VERSION}_linux_amd64.tar.gz | tar zx -C /usr/local/bin ship

curl -L https://github.com/static-linux/static-binaries-i386/raw/4266c69990ae11315bad7b928f85b6c8e605ef14/httping-2.4.tar.gz | tar zx -C /usr/local/bin --strip-components=1 httping-2.4/httping

git clone https://github.com/ahmetb/kubectx \
&& cd kubectx \
&& mv kubectx /usr/local/bin/kctx \
&& mv kubens /usr/local/bin/kns \
&& mv completion/*.bash $COMPLETIONS \
&& cd .. \
&& rm -rf kubectx

git clone https://github.com/jonmosco/kube-ps1 \
&& cp kube-ps1/kube-ps1.sh /etc/profile.d/ \
&& rm -rf kube-ps1

stern --completion bash > $COMPLETIONS/stern.bash
kubectl completion bash > $COMPLETIONS/kubectl.bash
helm completion bash > $COMPLETIONS/helm.bash


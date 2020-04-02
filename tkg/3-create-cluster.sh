#!/bin/bash
#bdereims@vmware.com

. ./password
. ./env

tkg create cluster dev-cluster --plan dev --kubernetes-version v1.17.3+vmware.1 --controlplane-machine-count 1 --worker-machine-count 3 

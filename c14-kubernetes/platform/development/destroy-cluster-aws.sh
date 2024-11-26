#!/bin/sh
source ~/.bashrc

echo "\n🏴️ Destroying Kubernetes cluster...\n"

minikube stop --profile line

minikube delete --profile line

echo "\n🏴️ Cluster destroyed\n"

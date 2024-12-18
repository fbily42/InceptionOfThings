#!/bin/bash

export RESET="\033[0m" YELLOW="\033[0;33m" GREEN="\033[0;32m"

echo -e "$YELLOW Cluster and namespaces creation... $RESET"
k3d cluster create iot
kubectl create namespace dev
kubectl create namespace argocd

echo -e "$YELLOW AgroCD installation... $RESET"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sleep 5

echo -e "$YELLOW Waiting for argocd-server to be ready... $RESET"
kubectl wait --namespace argocd --for=condition=Ready pods --all --timeout=-1s

gnome-terminal --tab -- bash -c "kubectl port-forward svc/argocd-server -n argocd 8080:443"

echo -e "$YELLOW Retrieve password from ArgoCD... $RESET"
export ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo -e "$YELLOW Login into ArgoCD... $RESET"
argocd login localhost:8080 --username admin --password $ARGOCD_PASSWORD --insecure
argocd account update-password --current-password $ARGOCD_PASSWORD --new-password Salem2024

echo -e "$YELLOW Application deployment... $RESET"
argocd app create my-app --repo https://github.com/fbily42/iot-fbily.git --path my-app --dest-server https://kubernetes.default.svc --dest-namespace dev
argocd app sync my-app

echo -e "$GREEN Configuration success $RESET"

echo -e "$YELLOW Waiting for application to be ready... $RESET"
kubectl wait --namespace dev --for=condition=Ready pods --all --timeout=-1s
kubectl port-forward service/wil42-service 8888:8888 -n dev
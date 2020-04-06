#!/bin/bash
cp kube_config_cluster.yml ~/.kube/config

kubectl create ns fluxcd


GHUSER=ams0
GHREPO=rancher-home

helm upgrade -i flux fluxcd/flux --wait \
--namespace fluxcd \
--set git.url="https://github.com/${GHUSER}/${GHREPO}.git" \
--set git.readonly=true \
--set sync.state=secret \
--set git.path=manifests \
--set git.pollInterval=1m


# Install the HelmRelease CRD that contains the helm version field:

kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/master/deploy/crds.yaml


#Install Helm Operator with Helm v3 support using the latest build:

helm upgrade -i helm-operator fluxcd/helm-operator --wait \
--namespace fluxcd \
--set git.ssh.secretName=flux-git-deploy \
--set configureRepositories.enable=true \
--set configureRepositories.repositories[0].name=stable \
--set configureRepositories.repositories[0].url=https://kubernetes-charts.storage.googleapis.com \
--set helm.versions=v3


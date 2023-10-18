### KIND - Local Kubernetes clusters using docker
# Image for nodes
# https://hub.docker.com/r/kindest/node/tags

.ONESHELL:

FOLDER=deploy/
# https://github.com/kubernetes/ingress-nginx
#INGRESS = "https://raw.githubusercontent.com/kubernetes/ingress-nginx/release-1.9/deploy/static/provider/kind/deploy.yaml"
INGRESS = "https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.3/deploy/static/provider/kind/deploy.yaml"
INGRESS_FILE = "${FOLDER}ingress-nginx.yaml"
# https://github.com/cert-manager/cert-manager
CERT = "https://github.com/cert-manager/cert-manager/releases/download/v1.13.1/cert-manager.yaml"
CERT_FILE = "${FOLDER}cert-manager.yaml"
# https://github.com/kubernetes-sigs/metrics-server
METRICS = "https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.6.4/components.yaml"
METRICS_FILE = "${FOLDER}metrics-server.yaml"
# https://github.com/kubernetes/dashboard
DASHBOARD = "https://raw.githubusercontent.com/kubernetes/dashboard/v3.0.0-alpha0/charts/kubernetes-dashboard.yaml"
DASHBOARD_FILE = "${FOLDER}kubernetes-dashboard.yaml"
# https://prometheus-community.github.io/helm-charts

# Init kind cluster
build:
	docker build -t nginx-glpi -f Dockerfile-nginx .
	docker build -t php-fpm -f Dockerfile-php .

clear:
	docker system prune -a --force

clean:
	docker image prune --force
	docker rm $(docker ps -a | grep "Exited" | awk 'FS=" " {print $1}')
	docker rmi $(docker images | grep "<none>" | awk 'FS=" " {print $3}')

load:
	kind load docker-image --name k8s localhost/nginx-glpi:latest
	kind load docker-image --name k8s localhost/php-fpm:latest

push:
	docker tag localhost/php-fpm docker.io/hrabalvojta/glpi-php
	docker tag localhost/nginx-glpi docker.io/hrabalvojta/glpi-web
	docker push docker.io/hrabalvojta/glpi-web:latest
	docker push docker.io/hrabalvojta/glpi-php:latest

all: build load

.PHONY: build clear clean load all
#!/bin/sh
source ~/.bashrc

# echo "\n📦 Initializing Kubernetes cluster...\n"

# minikube start --driver docker --profile line

# echo "\n🔌 Enabling NGINX Ingress Controller...\n"

# minikube addons enable ingress --profile line

sleep 30

echo "\n📦 Deploying Keycloak..."

kubectl apply -f services/keycloak-config.yml
kubectl apply -f services/keycloak.yml

sleep 5

echo "\n⌛ Waiting for Keycloak to be deployed..."

while [ $(kubectl get pod -l app=line-keycloak | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\n⌛ Waiting for Keycloak to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=app=line-keycloak \
  --timeout=300s

echo "\n⌛ Ensuring Keycloak Ingress is created..."

kubectl apply -f services/keycloak.yml

echo "\n📦 Deploying PostgreSQL..."

kubectl apply -f services/postgresql.yml

sleep 5

echo "\n⌛ Waiting for PostgreSQL to be deployed..."

while [ $(kubectl get pod -l db=line-postgres | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\n⌛ Waiting for PostgreSQL to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=line-postgres \
  --timeout=180s

echo "\n📦 Deploying Redis..."

kubectl apply -f services/redis.yml

sleep 5

echo "\n⌛ Waiting for Redis to be deployed..."

while [ $(kubectl get pod -l db=line-redis | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\n⌛ Waiting for Redis to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=line-redis \
  --timeout=180s

echo "\n📦 Deploying RabbitMQ..."

kubectl apply -f services/rabbitmq.yml

sleep 5

echo "\n⌛ Waiting for RabbitMQ to be deployed..."

while [ $(kubectl get pod -l db=line-rabbitmq | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\n⌛ Waiting for RabbitMQ to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=line-rabbitmq \
  --timeout=180s

# echo "\n📦 Deploying Line UI..."
# 
# kubectl apply -f services/line-ui.yml
# 
# sleep 5
# 
# echo "\n⌛ Waiting for Line UI to be deployed..."
# 
# while [ $(kubectl get pod -l app=line-ui | wc -l) -eq 0 ] ; do
#   sleep 5
# done
# 
# echo "\n⌛ Waiting for Line UI to be ready..."
# 
# kubectl wait \
#   --for=condition=ready pod \
#   --selector=app=line-ui \
#   --timeout=180s

echo "\n⛵ Happy Sailing!\n"

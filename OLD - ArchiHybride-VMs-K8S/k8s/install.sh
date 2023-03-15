

cd /tmp


# DELETE ENV
kubectl delete services lamp-php-fpm  lamp-apache  -n lamp-k8s
kubectl delete deployment lamp-php-fpm lamp-apache -n lamp-k8s
kubectl delete configmap php-content apache-conf   -n lamp-k8s
kubectl delete namespace lamp-k8s


# GET NEW SOURCES
rm -rf /tmp/Docaposte
git clone https://github.com/ahugla/Docaposte.git


# CREATE ENV
kubectl apply -f /tmp/Docaposte/k8s/lamp-k8s-namespace.yaml
sleep 3
kubectl apply -f /tmp/Docaposte/k8s


# INFOS
sleep 3
kubectl get service -n lamp-k8s | grep LoadBalancer
kubectl get pod -n lamp-k8s -o wide | grep php

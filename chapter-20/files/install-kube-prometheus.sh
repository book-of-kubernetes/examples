#!/bin/bash -e
source /opt/k8sver
cd /etc/kubernetes
curl -Lo kube-prom.zip $prometheus_url
unzip -qqo kube-prom.zip '*/manifests/*' 
rm -fr /etc/kubernetes/prometheus
mv kube-prometheus-release-* prometheus
kubectl apply --server-side -f /etc/kubernetes/prometheus/manifests/setup
until kubectl get servicemonitors --all-namespaces ; do sleep 1; done
kubectl apply -f /etc/kubernetes/prometheus/manifests
kubectl patch -n monitoring svc/grafana -p \
  '{"spec":{"type":"NodePort","ports":[{"port": 3000, "nodePort": 3000}]}}'
kubectl patch -n monitoring svc/prometheus-k8s -p \
  '{"spec":{"type":"NodePort","ports":[{"port": 9090, "nodePort": 9090}]}}'

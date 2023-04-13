#!/bin/sh

######
#⠀⠀⠀⠀⠀⠀⠀⠠⣀⣀⣾⣄⠀⠀⠀⠀⢀⣀⣀
#⠀⠀⠀⠀⠀⠀⠀⠀⢙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⣀⡀
#⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧
#⠀⢀⣠⣴⣶⣦⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣴⣶⣦⣤⡀
#⢠⡿⢉⣤⣤⣤⣿⣿⡿⠛⠛⠛⢿⣿⣿⣿⠟⠛⠛⢿⣿⣿⣦⣤⣤⡉⢻⡆
#⣾⡇⢸⣿⣿⣿⣿⣿⡇⠀⠀⠀⢸⣿⣿⣿⠀⠀⠀⢈⣿⣿⣿⣿⣿⡇⢸⣿
#⠸⣷⡘⠻⠿⠟⠻⣿⣿⣦⣤⣴⡿⣿⣿⠿⣦⣤⣤⣾⣿⡟⠻⠿⠟⢃⣼⠏
#⠀⠈⠻⠷⣶⡶⠿⠛⠻⣿⣿⣿⠀⣾⣿⠀⣿⣿⣿⠿⠛⠻⢶⣶⠶⠟⠁
#⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧
#⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠂
#⠀⠀⠀⠀⠀⠀⠀⠀⢤⣈⡉⠙⠛⠛⠛⠛⠛⢉⣁⣤
#⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣿⡿⠟⠁
#
# Este script hace todo los cambios necesarios para "romper" tu cluster.
#
# NO deberías leerlo antes de hacer el reto, de lo contrario encontrarás 
# las respuestas rápidamente.

export MINIKUBE_PROFILE="${1:-failed-cluster}"

minikube kubectl -- get pods -A
echo '
Everything was fine until now 

🔥🔥🔥
'

# Cambiando donde se hace scheduling de pods
CONTROL_PLANE=$(minikube kubectl -- get nodes --no-headers | grep control-plane | cut -d' ' -f1)
minikube kubectl -- cordon "${CONTROL_PLANE}" >/dev/null

WORKER_NODE=$(minikube kubectl -- get nodes --no-headers | grep -v control-plane | cut -d' ' -f1)
minikube kubectl -- cordon "${WORKER_NODE}" >/dev/null

# Rompiendo CoreDNS
OLD_IMAGE=$(minikube kubectl -- describe deploy -n kube-system | grep -oP 'Image:\s*\K.*')
minikube kubectl -- set image deployment.apps/coredns -n kube-system  coredns="${OLD_IMAGE}-mono-mono" >/dev/null

# Rompiendo API server
minikube ssh "sudo \
  sed -i 's%client-ca-file=/var/lib/minikube/certs/ca.crt%client-ca-file=/var/lib/minikube/certs/mono-mono-ca.crt%' \
  /etc/kubernetes/manifests/kube-apiserver.yaml"

# Rompiendo el kubeconfig
CONTROL_PLANE_IP=$(minikube ip)
minikube kubectl -- config set-cluster "${MINIKUBE_PROFILE}" --server="${CONTROL_PLANE_IP}:8446" >/dev/null

echo '
⠀⠀⠀⠀⠀⠀⠀⠀⠠⣀⣀⣾⣄⠀⠀⠀⠀⢀⣀⣀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⣀⡀
⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧
⠀⠀⢀⣠⣴⣶⣦⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣴⣶⣦⣤⡀
⠀⢠⡿⢉⣤⣤⣤⣿⣿⡿⠛⠛⠛⢿⣿⣿⣿⠟⠛⠛⢿⣿⣿⣦⣤⣤⡉⢻⡆
⠀⣾⡇⢸⣿⣿⣿⣿⣿⡇⠀⠀⠀⢸⣿⣿⣿⠀⠀⠀⢈⣿⣿⣿⣿⣿⡇⢸⣿
⠀⠸⣷⡘⠻⠿⠟⠻⣿⣿⣦⣤⣴⡿⣿⣿⠿⣦⣤⣤⣾⣿⡟⠻⠿⠟⢃⣼⠏
⠀⠀⠈⠻⠷⣶⡶⠿⠛⠻⣿⣿⣿⠀⣾⣿⠀⣿⣿⣿⠿⠛⠻⢶⣶⠶⠟⠁
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠂
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢤⣈⡉⠙⠛⠛⠛⠛⠛⢉⣁⣤
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣿⡿⠟⠁

      My J0b Iz Don3! Oock! 🔥
'

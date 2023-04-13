minikube start -p challenge01
minikube profile challenge01
mkdir csr/

openssl genrsa -out $(pwd)/martin.key 4096

cat <<STDIN > csr/martin.csr.cnf
[ req ]
default_bits = 2048
prompt = no
default_md = sha256 # algoritmo de encriptacion
distinguished_name = dn
[ dn ]
CN = martin
O = developers
[ v3_ext ]
authorityKeyIdentifier=keyid,issuer:always
basicConstraints=CA:FALSE
keyUsage=keyEncipherment,dataEncipherment
extendedKeyUsage=serverAuth,clientAuth
STDIN

openssl req -config csr/martin.csr.cnf -new -key martin.key -nodes -out csr/martin.csr

cat <<STDIN > martin-csr.yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: martin-cluster-authentication
spec:
  groups:
    - system:authenticated
  request: $(cat $(pwd)/csr/martin.csr | base64 | tr -d '\n')
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
STDIN

kubectl apply -f martin-csr.yaml

kubectl certificate approve martin-cluster-authentication

kubectl get csr martin-cluster-authentication -o jsonpath='{.status.certificate}' | base64 --decode > martin.pem
rm -rf csr martin-csr.yaml
ls martin.key  martin.pem

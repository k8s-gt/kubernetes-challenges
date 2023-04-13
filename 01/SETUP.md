---
title: Kubernetes Challenges Parte 1
author: Kubernetes Guatemala
date: 2023-04-13

---
## Prerequisitos para el reto 1
### Configurar autentication de usuario
```bash
# revisamos el estado de nuestro cluster
kubectl cluster-info
```

```bash
mkdir csr/
```
```bash
openssl genrsa -out $(pwd)/martin.key 4096
```

---
### Archivo de configuracion para el CSR

creamos el archivo `csr/martin.csr.cnf` con el siguiente contenido
```ini
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
```
---
### Creamos el Certificate Signing Request
```bash
openssl req -config csr/martin.csr.conf -new -key martin.key -nodes -out csr/martin.csr
```
#### ... Y verificamos

```bash
openssl req -in csr/martin.csr
```
---
### CSR para Kubernetes
Creamos el archivo `martin-csr.yaml` con el siguiente contenido

```yaml
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
```

... Y aplicamos el manifiesto
```bash
kubectl apply -f martin-csr.yaml
```

---

Revisamos que fue lo que se creo en cluster
```bash
kubectl get csr
```
Procedemos a firmar el Certificate Signing Request

```bash
kubectl certificate approve martin-cluster-authentication
```
... Y descargamos el certificado

```bash
kubectl get csr martin-cluster-authentication -o jsonpath='{.status.certificate}' | base64 --decode > martin.pem
```

Verificamos el contenido del certificado
```bash
openssl x509 -in martin.pem -noout -text
```
En nuestro workspace tenemos que encontrar los siguientes archivos
```bash
key.crt martin.crt
```

Documentacion: **[managing-tls-in-a-cluster](https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/)** 



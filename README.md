---
title: Kubernetes Challenges
author: Kubernetes Guatemala
date: 2023-03-17
extensions:
- file_loader
- terminal
---

# Reto 1

<!-- stop -->

- Developer
  * Configurar user data para el usuario `martin` en kubeconfig
  * Configurar un nuevo contexto `developer` para el usuario `martin`
  * Utilizar el contexto creado `developer`

<!-- stop -->

- Permisos
  - Crear `developer role`
  - Crear `developer role binding`

<!-- stop -->

- Aplicacion Jekyll
  * Revisar el Persistent Volume
  * Crear un Persistent Volume Claim que use el Persistent Volume anterior
  * Crear el Pod
    - Usar el Volume Claim
    - Configurar Jekyll
  * Exponer el Pod via Service

---
## Configurar user data para el usuario `martin` en kubeconfig

<!-- stop -->

```file
path: ./commands/commandlist.sh
relative: true
lang: bash
lines:
  start: 0
  end: 5
```

<!-- stop -->
`--client-certificate` Indica la ruta del certificado del cliente que fue firmado por el cluster
`--client-key` Indica la ruta de la llave del certificado del cliente




<!-- stop -->

*No se de que estas hablando o que estas haciendo?*

[Kubernetes RBAC with examples](https://sysdig.com/learn-cloud-native/kubernetes-security/kubernetes-rbac/)

<!-- stop -->

*Terminos que puedo buscar para entender mejor este paso del ejercicio

* Kubernetes User Accounts
* RBAC
* SSL Basics
* Kubeconfig Contexts

---
## Configurar un nuevo contexto `developer` con el usuario `martin` y el cluster

<!-- stop -->

```file
path: ./commands/commandlist.sh
relative: true
lang: bash
lines:
  start: 5
  end: 9
```

---
## Utilizar el contexto `developer`

<!-- stop -->

```file
path: ./commands/commandlist.sh
relative: true
lang: bash
lines:
  start: 10
```

---
## Permisos

<!-- stop -->

### Crear `developer role`

<!-- stop -->

```file
path: ./challenge01.yaml
lang: yaml
lines:
  start: 1
  end: 2
```

<!-- stop -->


```file
path: ./challenge01.yaml
lang: yaml
lines:
  start: 2
  end: 3
```
<!-- stop -->

```file
path: ./challenge01.yaml
lang: yaml
lines:
  start: 3
  end: 6
```
<!-- stop -->

```file
path: ./challenge01.yaml
lang: yaml
lines:
  start: 6
  end: 7 
```
<!-- stop -->

```file
path: ./challenge01.yaml
lang: yaml
lines:
  start: 7
  end: 9
```
<!-- stop -->

```file
path: ./challenge01.yaml
lang: yaml
lines:
  start: 9
  end: 13
```

<!-- stop -->


```file
path: ./challenge01.yaml
lang: yaml
lines:
  start: 13
  end: 15
```


---
### Crear `developer role binding`

<!-- stop -->

```yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: challenge01binding
  namespace: development
subjects:
- kind: User
  name: martin
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: challenge01
  apiGroup: rbac.authorization.k8s.io
```
---
##  Aplicacion Jekyll

<!-- stop -->

### Revisar el Persistent Volume
<!-- stop -->


```bash
kubectl get persistentvolumes -n development
```
---
### Crear un Persistent Volume Claim que use el Persistent Volume anterior

<!-- stop -->

```yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: jekyll-site
  namespace: development
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: local-storage
  resources:
    requests:
      storage: 1Gi
```
---
### Crear el Pod

#### El Pod
```yaml
---
apiVersion: v1
kind: Pod
metadata:
  namespace: development
  name: jekyll
  labels:
    run: jekyll
spec:
  containers:
    - name: jekyll
      image: kodekloud/jekyll-serve
      volumeMounts:
        - mountPath: /site
          name: site
```
---
#### Usar el Volume Claim

<!-- stop -->

```yaml
  volumes:
    - name: site
      persistentVolumeClaim:
        claimName: jekyll-site
```

---
#### Configurar Jekyll

<!-- stop -->

```yaml
  initContainers:
    - name: copy-jekyll-site
      image: kodecloud/jekill
      command: [ "jekyll", "new", "/site"]
      volumeMounts:
      - mountPath: /site
        name: site
```

---
### Exponer el Pod via un Service

<!-- stop -->

```yaml
---
kind: Service
apiVersion: v1
metadata:
  namespace: development
  name: jekyll
spec:
  type: NodePort
  ports:
    - port: 8080
      targetPort: 4000
      nodePort: 30097
  selector:
    run: jekyll
```

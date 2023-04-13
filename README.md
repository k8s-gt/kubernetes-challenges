# Kubernetes Challenges

Estos desafios se han preparado especialmente para practicar los conocimientos en la administracion y el manejo de distintos componentes de Kubernetes.

Los desafios en este repositorio fueron inspirados por [KodeKloud](https://kodekloud.com/), puedes crear una cuenta con ellos o bien utilizar minikube y realizar los localmente.

- [Cómo instalar Minikube](https://minikube.sigs.k8s.io/docs/start/)

## Retos

- [Reto 1](https://kodekloud.com/topic/kubernetes-challenge-1/)
  - [Solución](01/README.md)
- [Reto 2](https://kodekloud.com/topic/kubernetes-challenge-2/)
  - [Solución](02/README.md)

### Preparación del cluster para el reto 1

Creamos un cluster con `minikube` y seteamos el perfil globalmente.

```shell
minikube start -p challenge01
minikube profile challenge01
```

Luegos provisionamos los pre-requisitos necesarios con el `setup` script

```shell
./01/setup.sh
```

**Nota**: No te preocupes, explicaremos que hicimos en este script al final.

### Preparación del cluster para el reto 2

Creamos un cluster con 2 nodos y seteamos el perfil globalmente.

```shell
minikube start -p failed-cluster --nodes 2
minikube profile failed-cluster
```

Luego rompemos el cluster con nuestro `chaos-monkey` script.

```shell
./02/chaos-monkey.sh
```

**Nota**: No hagas trampa revisando el contenido del script ;)

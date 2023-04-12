# Kubernetes Challenges
Estos desafios se han preparado especialmente para practicar los conocimientos en la administracion y el manejo de distintos componentes de Kubernetes

## Retos
- [Reto 1](https://kodekloud.com/topic/kubernetes-challenge-1/)
  - [Solución](01/README.md) 
- [Reto 2](https://kodekloud.com/topic/kubernetes-challenge-2/) 
  - [Solución](02/README.md) 


## Nota
Para poder realizar los ejercicios sin depender de una cuenta de KodeKloud y para propositos de la charla hemos configurado dos clusters de minikube los pasos a continuación describen como instalar/configurar los mismos:

- [Instalar Minikube](https://minikube.sigs.k8s.io/docs/start/) 

## Preparar el cluster para el reto 1

Creamos un cluster para el reto 1
```bash
minikube start -p challenge01
```

```bash
minikube profile challenge01
```

## Preparar el cluster para el reto 2

Creamos un cluster con 2 nodos

```bash
minikube start -p failed-cluster
minikube profile failed-cluster
```

## Otra Nota
Para el reto 2 el cluster se encuentra inaccesible por multiples razones, en el ejercicio de KodeKloud el cluster se ha manipulado de manera intencionada el objetivo del ejercicio es que encontremos la forma de arreglarlo, sin embargo no describiremos en los pre-requisitos los pasos para dejar el cluster en el estado del ejercicio ya que el reto perderia sentido :).

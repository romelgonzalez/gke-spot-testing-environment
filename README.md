# Entorno de Pruebas en Google Cloud

Este proyecto despliega un entorno de pruebas en Google Cloud Platform (GCP).

## Arquitectura

El entorno consta de los siguientes componentes:

* **Red Virtual (VPC):** Se crea una VPC personalizada para aislar los recursos.
* **Subred:** Dentro de la VPC, se configura una subred para el clúster.
* **Clúster de Google Kubernetes Engine (GKE):** Se despliega un clúster de GKE para orquestar contenedores.
* **Node Pool de Spot VMs:** El clúster utiliza un grupo de nodos (node pool) con máquinas virtuales (VMs) de tipo Spot para optimizar costos.

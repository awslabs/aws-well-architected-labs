+++
title = "Módulo 3: Espera cálida"
date = 2021-05-06T09:52:56-04:00
weight = 140
chapter = false
pre = ""
+++

En este módulo, analizaremos la estrategia de recuperación de desastres (DR) espera cálida. Para aprender más sobre esta estrategia de DR, puede revisar el [Blog de recuperación de desastres](https://aws.amazon.com/blogs/architecture/disaster-recovery-dr-architecture-on-aws-part-iii-pilot-light-and-warm-standby/).

Nuestra aplicación de prueba es Unishop. Es una aplicación Java Spring Boot con un frontend escrito utilizando bootstrap. La aplicación usa un bucket de Amazon S3 para alojar la interfaz de web estática. Una única instancia EC2 sirve como proxy para las llamadas API a la base de datos Amazon Aurora MySQL. La base de datos contiene información de prueba de usuarios y productos.

Inicialmente, desplegaremos la instancia primaria de Unishop a la región N. Virginia. Posteriormente, la región N. California alojará la instancia de espera cálida para DR. Para configurar y desplegar la infraestrucutra, utilizaremos AWS CloudFormation. CloudFormation permite la automatización en la creación de infraestructura a partir de la automatización de aprovisionamiento de recursos en la nube con código.

Posteriormente, verificaremos el escenario de recuperación de desastres. Para alcanzar los objetivos de [RPO / RTO](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/disaster-recovery-dr-objectives.html) _de minutos_ requerimos Clusters de Amazon Aurora MySQL con **1/** Reenvio de escritura para replicas de lectura y **2/** Tablas globales de Amazon Aurora MySQL habilitada. Estas funcionalidades soportan la replicación de los cambios a la base de datos desde cualquier región.

Experiencia previa con la consola de AWS y la línea de comandos de Linux son recomendables, pero no requeridos.

{{< img arch-3.png >}}

{{< prev_next_button link_next_url="./prerequisites/" button_next_text="Empezar Lab" first_step="true" />}}


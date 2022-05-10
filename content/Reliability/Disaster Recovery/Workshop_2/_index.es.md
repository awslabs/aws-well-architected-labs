+++
title = "Módulo 2: Pilot Light"
date = 2021-05-06T09:52:56-04:00
weight = 140
chapter = false
pre = ""
+++


En este módulo, analizaremos la estrategia de recuperación de desastres Pilot-Light. Para aprender más sobre esta estrategia de DR, puede revisar este [blog de Recuperación de Desastres](https://aws.amazon.com/blogs/architecture/disaster-recovery-dr-architecture-on-aws-part-iii-pilot-light-and-warm-standby/).

Nuestra aplicación de prueba es Unishop. Es una aplicación en Java sobre Spring Boot conectada a una base de datos MySQL con un frontend escrito en bootstrap.

La aplicación utiliza un bucket de Amazon S3 para alojar una interfaz web estática. Una única instancia EC2 sirve como un proxy para las llamadas API hacia una base de datos Aurora MySQL. La base de datos contiene datos de prueba en cuanto a usuarios y productos.

Inicialmente, desplegaremos la instancia primaria de Unishop en la región N. Virginia. Posteriormente, la región N.California alojará la instancia de tipo Pilot-Light. Para configurar y desplegar esta infraestructura, utilizaremos AWS CloudFormation. CloudFormation permite la automatización de creación de infraestructura como código, agilizando el aprovisionamiento de recursos en la nube.

Posteriormente, verificaremos el escenario de DR. Para alcanzar nuestro objetivos de [RPO / RTO](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/disaster-recovery-dr-objectives.html) en decenas de minutos requiere un Cluster de Amazon Aurora MySQL con la función de Global database habilitada. Esta función añade capacidades de replicación a través de regiones a la base de datos.

Se recomienda experiencia previa con la consola de AWS y la linea de comandos de Linux, pero no es requerido.

{{< img arch-2.png >}}

{{< prev_next_button link_next_url="./prerequisites/" button_next_text="Empezar lab" first_step="true" />}}

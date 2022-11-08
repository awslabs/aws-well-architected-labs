+++
title = "Módulo 4: Espera activa"
date = 2021-05-06T09:52:56-04:00
weight = 140
chapter = false
pre = ""
+++

Nuestra aplicación de prueba es Unishop. Es una aplicación en Java con Spring Boot y un frontend creado con Bootstrap. La aplicación usa un bucket de S3 para alojar la interfaz estática web. Una única instancia EC2 sirve como proxy para las llamadas API a una base de datos Amazon Aurora MySQL. La base de datos contiene información de prueba de usuarios y productos. Se usa Amazon API Gateway para conectar la base de datos DynamoDB al carrito de compras e información de sesión, aprovechando también AWS Lambda.

Inicialmente desplegaremos la instancia primaria de Unishop a la región us-east-1 (N. Virginia). Posteriormente, la región us-west-1 (N. California) alojará la instancia de espera caliente para recuperación de desastres (DR). Para configurar la infraestructura y desplegar la aplicación utilizaremos CloudFormation. CloudFormation permite la automatización de creación de infraestructura como código, agilizando el aprovisionamiento de recursos en la nube.

Posteriormente, verificaremos el escenario de DR. Cumplir con nuestros objetivos de [RPO / RTO](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/disaster-recovery-dr-objectives.html) _de forma virtualmente instantánea_, requiere una distribución de CloudFront con una política de failover de origen. Adicionalmente, el workshop despliega un Cluster de Amazon RDS Aurora MySQL en cada región, y habilita **1/** Reenvio de escritura para replicas de lectura y **2/** Tablas globales de Amazon Aurora MySQL habilitada. Estas funcionalidades permiten replicar cambios a la base de datos de cualquier región. Finalmente, configuraremos las tablas globales de DynamoDB que replicarán la información entre regiones.

Se recomiendo experiencia previa con la consola de AWS y la línea de comandos de Linux, pero no es requerido.

{{< img workshop-4-arch.png >}}

{{< prev_next_button link_next_url="./prerequisites/" button_next_text="Empezar Lab" first_step="true" />}}

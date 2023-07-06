+++
title = "Módulo 3: Espera semi-activa"
date = 2021-05-06T09:52:56-04:00
weight = 140
chapter = false
pre = ""
+++

En este módulo, analizaremos la estrategia de recuperación de desastres (DR) espera semi-activa. Para aprender más sobre esta estrategia de DR, puede revisar el [Blog de recuperación de desastres](https://aws.amazon.com/blogs/architecture/disaster-recovery-dr-architecture-on-aws-part-iii-pilot-light-and-warm-standby/).

La estrategia de recuperación ante desastres en espera semi-activa tiene [Objetivo de punto de recuperación (RPO) /Objetivo de tiempo de recuperación (RTO)](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/disaster-recovery-dr-objectives.html) _en minutos_. Para la región secundaria de la estrategia de espera semi-activa, los datos están activos, se aprovisiona la infraestructura principal y los servicios de aplicación se ejecutan a una capacidad reducida.

Nuestra aplicación está implementada actualmente en nuestra región principal **Norte de Virginia (us-east-1)** y usaremos **N. California (us-west-1)** como nuestra región secundaria.

Nuestra aplicación de prueba es Unishop. Es una aplicación Java Spring Boot implementada mediante [Elastic Load Balancing](https://aws.amazon.com/elasticloadbalancing/) y dos instancias de [Amazon Elastic Compute Cloud (EC2)](https://aws.amazon.com/ec2) que utilizan una subred pública. Nuestro almacén de datos es una base de datos MySQL [Amazon Aurora](https://aws.amazon.com/rds/aurora/) con una interfaz escrita mediante bootstrap y alojada en [Amazon Simple Storage Service (S3)](https://aws.amazon.com/pm/serv-s3). 

Este módulo aprovecha [Auto Scaling Groups (ASG)](https://docs.aws.amazon.com/autoscaling/ec2/userguide/auto-scaling-groups.html) que nos permitirá escalar nuestras instancias informáticas de la región secundaria durante la conmutación por error. [Base de datos global de Amazon Aurora](https://aws.amazon.com/rds/aurora/global-database/) se utiliza para replicar nuestros datos de Amazon Aurora MySQL en nuestra región secundaria. También estamos aprovechando la réplica de lectura [envío de escritura](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-write-forwarding.html) de Amazon Aurora . Con esta función habilitada, las escrituras se pueden enviar a una réplica de lectura en una región secundaria y se reenviarán sin problemas al escritor de la región principal a través de un canal de comunicación seguro.

Se utilizará [CloudFormation](https://aws.amazon.com/cloudformation/) para configurar la infraestructura e implementar la aplicación. Aprovisionar su infraestructura con metodologías de infraestructura como código (IaC) es una práctica recomendada. CloudFormation es una forma sencilla de acelerar el aprovisionamiento en la nube con infraestructura como código.

Experiencia previa con la consola de AWS y la línea de comandos de Linux son recomendables, pero no requeridos.

{{< img WarmStandby.png >}}

{{< prev_next_button link_next_url="./1-prerequisites/" button_next_text="Empezar Lab" first_step="true" />}}


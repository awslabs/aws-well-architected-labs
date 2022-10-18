+++
title = "Módulo 2: Pilot Light"
date = 2021-05-06T09:52:56-04:00
weight = 140
chapter = false
pre = ""
+++


En este módulo analizaremos la estrategia de recuperación de desastres Pilot-Light. Para aprender más sobre esta estrategia de DR, puede revisar éste [blog de Recuperación de Desastres](https://aws.amazon.com/blogs/architecture/disaster-recovery-dr-architecture-on-aws-part-iii-pilot-light-and-warm-standby/).

La estrategia de recuperación de desastres Pilot-Light tiene [Recovery Point Objective(RPO) / Recovery Time Objective (RTO)](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/disaster-recovery-dr-objectives.html) _medidos en decenas de minutos_. Para la estrategía de pilot-light en la región secundaria, la data está en vivo y la infraestructura desplegada, pero los servicios están apagados o ausentes.

Nuestra aplicación se encuentra desplegada en nuestra región primaria **N. Virginia (us-east-1)** y utilizaremos **N. California (us-west-1)** como nuestra región secundaria.

Nuestra aplicación de prueba es Unishop. Es una aplicación en Java sobre Spring Boot desplegada en una sola instancia de [Amazon Elastic Compute Cloud (EC2)](https://aws.amazon.com/es/ec2/) utilizando una subred pública. Nuestro almacén de datos es una base de datos [Amazon Aurora](https://aws.amazon.com/es/rds/aurora/) MySQL con una interfaz escrita en bootstrap alojada en [Amazon Simple Storage Service (S3)](https://aws.amazon.com/pm/serv-s3).

Éste módulo hace uso de [Imágenes de máquina de Amazon (AMI)](https://docs.aws.amazon.com/es_es/AWSEC2/latest/UserGuide/AMIs.html) para desplegar nuestra instancia de cómputos EC2 y [Bases de datos globales de Amazon Aurora](https://aws.amazon.com/es/rds/aurora/global-database/) para replicar la data en Amazon Aurora MySQL a nuestra segunda región.

Utilizaremos [CloudFormation](https://aws.amazon.com/es/cloudformation/) para configurar la infraestructura y desplegar nuestra aplicación. El aprovisionamiento de la infraestructura utilizando metodologías de infraestructura como código (IaC) es considerado como una buena práctica. CloudFormation es una manera fácil de agilizar el aprovisionamiento en la nube con infraestructura como código.

Se recomienda experiencia previa con la consola de AWS y la línea de comandos de Linux, pero no es requerido.

{{% notice note %}}
Debido a que ésta aplicación solo tiene **una** instancia EC2 desplegada en **una** zona de disponibilidad, ésta arquitectura no cumple con los requisitos de mejores prácticas del _AWS Well Architected Framework_ para operar aplicaciones altamente disponibles, pero es suficiente para propósitos de demostración en éste workshop.
{{% /notice %}}

{{< img PilotLight.png >}}

{{< prev_next_button link_next_url="./1-prerequisites/" button_next_text="Empezar lab" first_step="true" />}}

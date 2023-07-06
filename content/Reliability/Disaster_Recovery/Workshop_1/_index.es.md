+++
title = "Modulo 1: Respaldar y restaurar"
date = 2021-05-06T09:52:56-04:00
weight = 110
chapter = false
pre = ""
+++

En este módulo, revisaremos la estrategia de recuperación de desastres Respaldar y restaurar (Backup & Restore). Para aprender más sobre esta estrategia de DR, puede revisar este [Blog de recuperación de desastres](https://aws.amazon.com/blogs/architecture/disaster-recovery-dr-architecture-on-aws-part-ii-backup-and-restore-with-rapid-recovery/).

La estrategia de recuperación de desastres Respaldar y restaurar tiene un [Recovery Point Objective(RPO) / Recovery Time Objective (RTO)](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/disaster-recovery-dr-objectives.html) de _horas_.

La aplicación está desplegada actualmente en la región primaria **N. Virginia (us-east-1)** y se utilizará la región **N. California (us-west-1)** como la región secundaria.

La aplicación de prueba es Unishop. Es una aplicación Java Spring Boot desplegada en una instancia de [Amazon Elastic Compute Cloud (EC2)](https://aws.amazon.com/ec2) utilizando una subred pública. Para almacenar los datos, se usará una base de datos [Amazon RDS](https://aws.amazon.com/rds/) MySQL con un frontend implementado con bootstrap y alojado en [Amazon Simple Storage Service (S3)](https://aws.amazon.com/pm/serv-s3).  

Este módulo aprovecha [AWS Backup](https://aws.amazon.com/backup/), que será el punto central para respaldar, copiar y restaurar la instancia EC2 y la base de datos RDS a la región secundaria.

Se utilizará [Amazon S3 Cross-Region Replication (CRR)](https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication.html#crr-scenario) para replicar los objetos de S3 hacía la región secundaria.

[CloudFormation](https://aws.amazon.com/cloudformation/) será utilizado para configurar la infraestructura y desplegar la aplicación. Aprovisionar su infraestructura con la metodología Infraestructura como código (IaC) es una buena práctica. CloudFormation es una forma sencilla de acelerar al aprovisionamiento con infraestructura como código en la nube.

Se recomienda experiencia previa con la consola de AWS y la linea de comandos de Linux, pero no es requerido.

{{% notice info %}}
Como esta carga de trabajo tiene solo **una** instancia EC2 desplegada en solo **una** Zona de disponibilidad, esta arquitectura no cumple con las mejores prácticas del Marco de buena arquitectura de AWS para correr aplicaciones en producción altamente disponibles, pero es suficiente para este laboratorio.
{{% /notice %}}

{{< img BackupAndRestore.png >}}

{{< prev_next_button link_next_url="./1-prerequisites/" button_next_text="Empezar el lab" first_step="true" />}}


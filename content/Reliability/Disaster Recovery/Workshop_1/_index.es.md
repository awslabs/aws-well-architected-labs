+++
title = "Modulo 1: Respaldar y restaurar"
date = 2021-05-06T09:52:56-04:00
weight = 110
chapter = false
pre = ""
+++

En este módulo, revisaremos la estrategia de recuperación de desastres Respaldar y restaurar (Backup & Restore). Para aprender más sobre esta estrategia de DR, puede revisar este [Blog de recuperación de desastres](https://aws.amazon.com/blogs/architecture/disaster-recovery-dr-architecture-on-aws-part-ii-backup-and-restore-with-rapid-recovery/).

Nuestra aplicación de prueba es Unishop. Es una aplicación en Java sobre Spring Boot conectada a una base de datos MySQL con un frontend escrito en Bootstrap.

La aplicación está desplegada sobre una única instancia EC2 (t3.small) contenida dentro de una VPC dedicada con una única subred pública. Nótese que esta no es la infraestructura ideal para correr aplicaciones altamente disponibles en producción, pero es suficiente para este taller.

Para configurar esta infraestructura y desplegar la aplicación, usaremos CloudFormation. CloudFormation es una forma de agilizar el aprovisionamiento de infraestructura en la nube a partir de código.

Inicialmente, desplegaremos Unishop en la región us-east-1 y verificaremos su funcionalidad. Posteriormente, utilizaremos una AWS AMI de EC2 y AWS Backup para crear copias del servidor que soporta la aplicación, así como la base de datos en la región us-west-1. Finalmente, usaremos las copias para crear y probar la aplicación totalmente funcional en la región us-west-1.

Se recomienda experiencia previa con la consola de AWS y la linea de comandos de Linux, pero no es requerido.

{{< img AC-1.png >}}

{{< prev_next_button link_next_url="./prerequisites/" button_next_text="Empezar el lab" first_step="true" />}}


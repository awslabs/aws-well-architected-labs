+++
title = "Crear recursos para el respaldo"
date =  2021-05-11T20:33:54-04:00
weight = 2
+++

Ahora vamos a hacer una copia de seguridad de nuestros recursos.

Vamos a realizar lo siguiente:
- Crear una copia de seguridad de la base de datos RDS
- Crear una nueva AMI (Amazon Machine Image) de EC2
- Crear un nuevo bucket de S3 para la UI

Para una aplicación de producción, crearíamos un [plan de respaldo](https://docs.aws.amazon.com/aws-backup/latest/devguide/creating-a-backup-plan.html) y agendaríamos copias de seguridad recurrentes para cumplir con el RPO.

Sin embargo, para este taller, crearemos un **respaldo manual**.

{{< prev_next_button button_next_text="Siguiente paso" button_prev_text="Paso anterior" link_prev_url="../prerequisites/" link_next_url="./rds/" />}}

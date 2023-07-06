+++
title = "Prepare la región secundaria"
date =  2021-05-11T20:33:54-04:00
weight = 4
+++

[AWS Backup](https://aws.amazon.com/backup/) es una forma de centralizar y automatizar la protección de información a través de diferentes servicios de AWS y cargas de trabajo híbridas. AWS Backup ofrece un servicio rentable, totalmente administrado y basado en políticas que simplifica la protección de datos a escala. AWS Backup también soporta sus políticas de cumplimiento o de negocio en cuanto a protección de datos. Junto a AWS Organizations, puede utilizar AWS Backup para desplegar políticas de protección de datos para configurar, administrar, y controlar su actividad de respaldo a través de las diferentes cuentas y recursos de su compañia en AWS.

Puede encontrar una lista de los recursos soportados por AWS Backup [acá](https://aws.amazon.com/backup/?whats-new-cards.sort-by=item.additionalFields.postDateTime&whats-new-cards.sort-order=desc.).

{{% notice info %}}
Llevará a cabo una serie de tareas **manualmente** para respaldar, copiar y restaurar la aplicación a la región secundaria **N. California (us-west-1)**.  
En un ambiente de producción, se **automatizarian** estos pasos creando un [Plan de backup](https://docs.aws.amazon.com/aws-backup/latest/devguide/creating-a-backup-plan.html) para agendar copias de respaldo recurrentes y lograr el RPO objetivo.
{{% /notice %}}

{{% notice note %}}
Si está usando su cuenta de AWS puede que quiera crear una boveda no predeterminada para este laboratorios. Esto prevendrá juntar las copias de respaldo de este laboratorio con otras copias en la boveda predeterminada. Las instrucciones se pueden encontrar en la [documentación del servicio](https://docs.aws.amazon.com/aws-backup/latest/devguide/vaults.html).
{{% /notice %}}

{{< prev_next_button link_prev_url="../3-verify-primary/" link_next_url="./4.1-backup/" />}}
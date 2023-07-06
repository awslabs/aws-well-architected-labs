+++
title = "Respaldar"
date =  2021-05-11T20:33:54-04:00
weight = 2
+++

Ahora, vamos a respaldar los recursos de la región primari **N.Virginia (us-east-1).**

### Respalde la instancia de EC2

1.1 Oprima [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) para navegar a la consola en la región **N. Virginia (us-east-1)**.

1.2 Oprima el link **Recursos protegidos**, después oprima el botón **Crear copia de seguridad bajo demanda**.

{{< img bk-1-es.png >}}

1.3 Seleccione **EC2** como el **Tipo de recurso**, después seleccione **backupandrestore-primary** como el **ID de la instancia**.  Seleccione **Elegir un rol de IAM**, Después seleccione **Team Role** como el **Nombre del rol**. Oprima el botón **Crear copia de seguridad bajo demanda**.

{{< img bk-8-es.png >}}

1.4 Esto creará un **Trabajo de copia de seguridad**.

### Respaldo de la base de datos RDS

2.1 Oprima el link **Recursos protegidos**, después oprima el botón **Crear copia de seguridad bajo demanada**.

{{< img bk-1-es.png >}}

2.2 Seleccione **RDS** como el **Tipo de recurso**, después seleccione **backupandrestore-primary** como el **Nombre de la base de datos**. Seleccione **Elegir un rol de IAM**, después seleccione **Team Role** como el  **Nombre del rol**. Oprima el botón **Crear copia de seguridad bajo demanda**.

{{< img bk-5-es.png >}}

2.3 Esto creará un **Trabajo de copia de seguridad**.

{{% notice info %}}
Los respaldos también puede proteger contra la corrupción o eliminación accidental de datos.
{{% /notice %}}

Debe ver sus 2 trabajos de respaldo.

{{< img bk-10-es.png >}}

{{% notice warning %}}
A medida que cada trabajo se mueve al estado de **Completado**, puede moverse a la sección **Copia**. Esto puede tomar varios minutos.
{{% /notice %}}

{{< prev_next_button link_prev_url="../" link_next_url="../4.2-copy/" />}}
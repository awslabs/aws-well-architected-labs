+++
title = "RDS"
date =  2021-05-11T20:33:54-04:00
weight = 1
+++

###  Copiar Backup de RDS

1.1 Oprima [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) para navegar a la consola en la región **N. Virginia (us-east-1)**.

1.2 Oprima el link **Almacenes de copia de seguridad** , después oprima el link **Default**.

{{< img BK-24-ES.png >}}

{{% notice note %}}
Si está usando su cuenta de AWS propia puede que quiera crear un almacén de copias de seguridad personalizado para este taller. Esto evitará juntar las copias de seguridad del taller con otras copias de seguridad en el almacén por defecto. Las instrucciones se pueden encontrar en: [documentación del servicio](https://docs.aws.amazon.com/aws-backup/latest/devguide/vaults.html).
{{% /notice %}}

1.3 En la sección **Copias de seguridad**, seleccione el backup. Oprima **Copiar** bajo el menú desplegable **Acciones**.

{{< img BK-27-ES.png >}}

{{% notice warning %}}
Si no ve su backup, revise el estado del **Trabajo de Backup**. Oprima el link **Trabajos**, después oprima el link **Trabajos de copia de seguridad**. Verifique que el **Estado** de su backup sea **Completado**.
{{% /notice %}}

{{< img BK-26-ES.png >}}

1.4 Seleccione **US West (N. California)** como **Copiar en el destino**, después oprima el botón **Copiar**.

{{< img BK-28-ES.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../ec2/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}

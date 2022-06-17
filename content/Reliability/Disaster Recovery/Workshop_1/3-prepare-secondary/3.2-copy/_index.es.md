+++
title = "Copiar a una región secundaria"
date =  2021-05-11T20:33:54-04:00
weight = 3
+++

####  Copiar Backup de RDS

1.1 Oprima [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) para navegar a la consola en la región **N. Virginia (us-east-1)**.

1.2 Oprima el link **Almacenes de copia de seguridad** , después oprima el link **Default**.

{{< img cp-1-ES.png >}}

{{% notice note %}}
Si está usando su cuenta de AWS propia puede que quiera crear un almacén de copias de seguridad personalizado para este taller. Esto evitará juntar las copias de seguridad del taller con otras copias de seguridad en el almacén por defecto. Las instrucciones se pueden encontrar en: [documentación del servicio](https://docs.aws.amazon.com/aws-backup/latest/devguide/vaults.html).
{{% /notice %}}

1.3 En la sección **Copias de seguridad**, seleccione el backup. Oprima **Copiar** bajo el menú desplegable **Acciones**.

{{< img cp-2-ES.png >}}

{{% notice warning %}}
Si no ve su backup, revise el estado del **Trabajo de Backup**. Oprima el link **Trabajos**, después oprima el link **Trabajos de copia de seguridad**. Verifique que el **Estado** de su backup sea **Completado**.
{{% /notice %}}

{{< img cp-3-ES.png >}}

1.4 Seleccione **US West (N. California)** como **Copiar en el destino**, después oprima el botón **Copiar**.

#### Copiar la AMI (Amazon Machine Image) de EC2

1.1 Oprima [EC2](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#/) para navegar a la consola en la región **N. Virginia (us-east-1)**.

1.2 Oprima el link **AMIs**.

1.3 Verifique que la imagen **BackupAndRestoreImage** tenga un estado de **Disponible**.



1.4 Seleccione **BackupAndRestoreImage**.  Oprima **Copiar AMI** en el desplegable **Acciones**.



1.5 Seleccione **US-West (N. California)** como la **Región de destino**, después oprima el botón **Copiar AMI**.



{{< prev_next_button link_prev_url="../backup-resources/s3/" link_next_url="./rds/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}

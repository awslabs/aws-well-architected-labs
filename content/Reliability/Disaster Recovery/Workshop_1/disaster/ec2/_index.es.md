+++
title = "EC2"
date =  2021-05-11T20:35:50-04:00
weight = 1
+++

###  Iniciar la instancia EC2 a partir de la AMI (Amazon Machine Image)

1.1 Oprima [EC2](https://us-west-1.console.aws.amazon.com/ec2/home?region=us-west-1#/) Para navegar a la consola en la región **N. California (us-west-1)**.

1.2 Oprima el link **AMIs**.

1.3 Verifique que **BackupAndRestoreImage** tiene un estado de **Disponible**.

{{< img BK-4-ES.png >}}

1.4 Seleccione **BackupAndRestoreImage**.  Oprima el botón **Lanzar instancia a partir de una AMI**.

{{< img RS-7-ES.png >}}

1.5 Seleccione el tipo de instancia **t2.micro**, después oprima el botón **Siguientet: Configure los detalles de la instancia**.

{{< img RS-8-ES.png >}}

1.6 Seleccione **BackupAndRestore-S3InstanceProfile-xxxx** como el **Rol de IAM**, después oprima el botón **Siguiente: Añada almacenamiento**.

{{< img rs-9-ES.png >}}

1.7 Oprima el botón **Siguiente: Añada etiquetas**.

1.8 Añada `Nombre` como la  **Llave** y `BackupAndRestoreSecondary` como el **Valor**, después oprima el botón **Siguiente: Configurar grupo de seguridad**.

{{< img rs-10-ES.png >}}

1.9 Seleccione **Crear nuevo grupo de seguridad** e introduzca `backupandrestore-us-west-ec2-SG` como el **Nombre de grupo de seguridad** e introduzca una **Descripción**.  Añada las reglas como se puede ver oprimiendo el botón **Añadir regla**.  (Oprima la imagen para expandirla) Oprima el botón **Revisar y lanzar**.

{{< img ss-3-ES.png >}}

1.10 Oprima el botón **Lanzar**.

1.11 Seleccione **Continuar sin par de llaves**, Habilite la casilla de verificacio4n **Reconozco que sin un par de llaves,...**, después oprima el botón **Lanzar instancias**.

{{< img RS-15-ES.png >}}

{{% notice note %}}
Copie la dirección DNS IPv4 pública de la instancia. La necesitará más adelante.
{{% /notice %}}

{{< img RS-47-ES.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../rds/" button_next_text="Siguiente paso" button_prev_text="Paso anterior"/>}}

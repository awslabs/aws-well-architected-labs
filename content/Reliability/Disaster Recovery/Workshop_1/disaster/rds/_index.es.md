+++
title = "RDS"
date =  2021-05-11T20:35:50-04:00
weight = 2
+++

### Restore RDS Database

{{% notice info %}}
Si está realizando este taller como parte de un taller liderado por un instructor, la instancia RDS ya fue restaurada en la región **N. California (us-west-1)** debido a restricciones de tiempo.  **Por favor revise los pasos de esta sección para que entienda como funcionaría una restauración y posteriormente continue con la configuración del grupo de seguridad**.
{{% /notice  %}}


1.1 Oprima [AWS Backup](https://us-west-1.console.aws.amazon.com/backup/home?region=us-west-1#/) para navegar a la consola en la región **N. California (us-west-1)**.

1.2 Oprima el link **Almacenes de copia de seguridad**, después oprima el link **Default**.

{{< img BK-24-ES.png >}}

1.3 En la sección **Copias de seguridad**, seleccione el backup. Oprima **Restaurar** bajo el desplegable **Acciones**.

{{< img BK-27-ES.png >}}

{{% notice warning %}}
Si no ve su backup, revise el estado de su **Trabajo de copia**. Oprima [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) para navegar a la consola en la región **N. Virginia (us-east-1)**. Oprima el link **Trabajos** después oprima el link **Trabajos de copia**.  Verifique que el **Estado** de su backup es **Completado**.
{{% /notice %}}

{{< img BK-26-ES.png >}}

1.4 En la sección **Configuración**, escriba `backupandrestore-secondary-region` como el **Identificador de instancia de base de datos**. En la sección **Redes y seguridad**, seleccione **us-west-xx** como la **Zona de disponibilidad**.

{{< img RS-18-ES.png >}}

1.5 Oprima el botón **Restaurar copia de segurdad**.

{{< img RS-20-ES.png >}}

### Configure el grupo de segurdad

2.1 Oprima [VPC](https://us-west-1.console.aws.amazon.com/vpc/home?region=us-west-1#/) para navegar a la consola en la región **N. California (us-west-1)**.

2.2 Oprima el link **Grupos de seguridad**, después oprima el botón **Crear grupo de seguridad**.

{{< img RS-23-ES.png >}}

2.3 En la sección **Detalles básicos**, escriba `backupandrestore-us-west-rds-SG` como el **Nombre del grupo de seguridad** y **Descripción**.

{{< img RS-24-ES.png >}}

2.4 En la sección **Reglas de entrada**, oprima el botón **Agregar regla**.  Seleccione **MYSQL/Aurora** como el **Tipo**.  Seleccione **Personalizada** como la **Fuente** y escoja **backupandrestore-us-west-ec2-SG**. Esto permitirá la comunicación entre su instancia EC2 y su instancia RDS. Oprima el botón **Crear grupo de seguridad**.

{{< img RS-40-ES.png >}}

### Modifique RDS 

3.1 Oprima [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#/) para navegar a la consola en la región **N. California (us-west-1)**.

3.2 Oprima el link **Instancias de base de datos**.

{{< img BK-1-ES.png >}}

3.3 Seleccione **backupandrestore-secondary-region**, después oprima el botón **Modificar**.

{{% notice note %}}
La bse de datos debe tener un **Estado** de **Disponible**.
{{% /notice %}}

{{< img RS-25-ES.png >}}

3.4 En la sección **Connectividad**, seleccione **backupandrestore-us-west-rds-SG** como el **Grupo de seguridad**. Oprima el botón **Continuar**.

{{< img RS-27-ES.png >}}

3.5 Seleccione **Aplicar inmediatamente** y después oprima el botón **Modificar instancia de BD**..

{{< img RS-43-ES.png >}}

3.6 Oprima el link **backupandrestore-secondary-region**.

{{< img RS-26-ES.png >}}

{{% notice note %}}
Copie el nombre del punto de enlace y puerto. Necesitará esto en un paso más adelante.
{{% /notice %}}

{{< img RS-46-ES.png >}}

{{< prev_next_button link_prev_url="../ec2/" link_next_url="../modify-application/" button_next_text="Siguiente paso" button_prev_text="Paso anterior">}}
